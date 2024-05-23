import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/notifier/config/sphia_config.dart';
import 'package:sphia/app/notifier/proxy.dart';
import 'package:sphia/app/notifier/traffic.dart';
import 'package:sphia/app/provider/core.dart';
import 'package:sphia/app/state/core_state.dart';
import 'package:sphia/core/core.dart';
import 'package:sphia/server/custom_config/server.dart';
import 'package:sphia/server/server_model.dart';
import 'package:sphia/server/xray/server.dart';
import 'package:sphia/util/network.dart';
import 'package:sphia/util/system.dart';
import 'package:sphia/util/tray.dart';

part 'core_state.g.dart';

@Riverpod(keepAlive: true)
class CoreStateNotifier extends _$CoreStateNotifier {
  @override
  Future<CoreState> build() async => const CoreState(cores: []);

  Future<void> toggleCores(ServerModel selectedServer) async {
    try {
      final currentState = state.valueOrNull;
      if (currentState == null) {
        return;
      }
      if (currentState.cores.isNotEmpty) {
        final runningServer = await getRunningServerModel();
        if (selectedServer == runningServer) {
          await stopCores();
        } else {
          await stopCores(keepSysProxy: true);
          await startCores(selectedServer);
        }
      } else {
        await startCores(selectedServer);
      }
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<void> startCores(ServerModel selectedServer) async {
    final preState = state.valueOrNull;
    if (preState == null) {
      return;
    }

    state = const AsyncValue.loading();
    final cores = await _addCores(selectedServer);
    final sphiaConfig = ref.read(sphiaConfigNotifierProvider);
    late final String routingProviderName;

    final isCustom = cores.first.isCustom;

    try {
      logger.i('Starting cores');
      if (isCustom) {
        cores.first.servers.add(selectedServer);
        final jsonString = (selectedServer as CustomConfigServer).configString;
        await cores.first.writeConfig(jsonString);
        await cores.first.start(manual: true);
        routingProviderName = cores.first.name;
      } else {
        if (cores.length == 1) {
          // Only routing core
          cores.first.servers.add(selectedServer);
          await cores.first.start();
          routingProviderName = cores.first.name;
        } else {
          for (int i = 0; i < cores.length; i++) {
            if (cores[i].isRouting) {
              await cores[i].start();
              routingProviderName = cores[i].name;
            } else {
              cores[i].servers.add(selectedServer);
              await cores[i].start();
            }
          }
        }
      }
    } on Exception catch (_) {
      for (var core in cores) {
        await core.stop();
      }
      state = const AsyncValue.data(CoreState(cores: []));
      rethrow;
    }
    state = AsyncValue.data(CoreState(cores: cores));

    late final int httpPort;
    if (isCustom) {
      httpPort = selectedServer.port;
      if (httpPort == -1) {
        final proxyNotifier = ref.read(proxyNotifierProvider.notifier);
        proxyNotifier.setCoreRunning(true);
        await TrayUtil.setIcon(coreRunning: true);
        return;
      }
    } else {
      if (routingProviderName == 'sing-box') {
        httpPort = sphiaConfig.mixedPort;
      } else {
        httpPort = sphiaConfig.httpPort;
      }
    }
    final proxyNotifier = ref.read(proxyNotifierProvider.notifier);
    final localServerAvailable = await NetworkUtil.isServerAvailable(
      httpPort,
      maxRetry: 10,
    );
    if (!localServerAvailable) {
      // stop cores
      await stopCores();
      logger.e('Port $httpPort is not available');
      logger.e('Local server is not available');
      throw Exception('Local server is not available');
    }

    final isTun = !isCustom && sphiaConfig.enableTun;

    if (isTun) {
      proxyNotifier.setTunMode(true);
    }

    proxyNotifier.setCoreRunning(true);
    await TrayUtil.setIcon(coreRunning: true);

    final enableStatistics = !isCustom && sphiaConfig.enableStatistics;
    if (enableStatistics) {
      final trafficNotifier = ref.read(trafficNotifierProvider.notifier);
      await trafficNotifier.start();
    }

    if (isTun) {
      // do not enable system proxy in tun mode
      SystemUtil.disableSystemProxy();
      proxyNotifier.setSystemProxy(false);
    } else {
      proxyNotifier.setTunMode(false);
      if (sphiaConfig.autoConfigureSystemProxy) {
        SystemUtil.enableSystemProxy(
          sphiaConfig.listen,
          httpPort,
        );
        proxyNotifier.setSystemProxy(true);
      }
    }
  }

  Future<List<Core>> _addCores(ServerModel selectedServer) async {
    if (selectedServer.protocol == 'custom') {
      selectedServer = selectedServer as CustomConfigServer;
      final coreProvider = selectedServer.protocolProvider;
      if (coreProvider == null) {
        logger.f('Custom server must have a protocol provider');
        throw Exception('Custom server must have a protocol provider');
      }
      final toCore = {
        CustomServerProvider.sing.index: ref.read(singBoxCoreProvider)
          ..configFileName = 'sing-box.${selectedServer.configFormat}',
        CustomServerProvider.xray.index: ref.read(xrayCoreProvider)
          ..configFileName = 'xray.${selectedServer.configFormat}',
        CustomServerProvider.hysteria.index: ref.read(hysteriaCoreProvider)
          ..configFileName = 'hysteria.${selectedServer.configFormat}',
      };
      final core = toCore[coreProvider];
      if (core == null) {
        logger.e('Unsupported custom server provider: $coreProvider');
        throw Exception('Unsupported custom server provider: $coreProvider');
      }
      return [
        core
          ..isRouting = true
          ..isCustom = true
      ];
    }

    final sphiaConfig = ref.read(sphiaConfigNotifierProvider);
    final protocol = selectedServer.protocol;
    final routingProvider =
        selectedServer.routingProvider ?? sphiaConfig.routingProvider.index;
    ServerModel? additionalServer;
    final cores = <Core>[];

    if (sphiaConfig.enableTun) {
      if (!SystemUtil.isRoot) {
        logger.e('Tun mode requires administrator privileges');
        throw Exception('Tun mode requires administrator privileges');
      }
      cores.add(ref.read(singBoxCoreProvider)..isRouting = true);
    } else if (sphiaConfig.multiOutboundSupport) {
      if (sphiaConfig.routingProvider == RoutingProvider.sing) {
        cores.add(ref.read(singBoxCoreProvider)..isRouting = true);
      } else {
        cores.add(ref.read(xrayCoreProvider)..isRouting = true);
      }
    } else {
      final protocolToCore = {
        'vmess': (ServerModel selectedServer, SphiaConfig sphiaConfig) =>
            (selectedServer.protocolProvider ??
                        sphiaConfig.vmessProvider.index) ==
                    VmessProvider.xray.index
                ? ref.read(xrayCoreProvider)
                : ref.read(singBoxCoreProvider),
        'vless': (ServerModel selectedServer, SphiaConfig sphiaConfig) =>
            (selectedServer.protocolProvider ??
                        sphiaConfig.vlessProvider.index) ==
                    VlessProvider.xray.index
                ? ref.read(xrayCoreProvider)
                : ref.read(singBoxCoreProvider),
        'shadowsocks': (ServerModel selectedServer, SphiaConfig sphiaConfig) {
          final protocolProvider = selectedServer.protocolProvider ??
              sphiaConfig.shadowsocksProvider.index;
          if (protocolProvider == ShadowsocksProvider.xray.index) {
            return ref.read(xrayCoreProvider);
          } else if (protocolProvider == ShadowsocksProvider.sing.index) {
            return ref.read(singBoxCoreProvider);
          } else {
            return ref.read(shadowsocksRustCoreProvider);
          }
        },
        'trojan': (ServerModel selectedServer, SphiaConfig sphiaConfig) =>
            (selectedServer.protocolProvider ??
                        sphiaConfig.trojanProvider.index) ==
                    TrojanProvider.xray.index
                ? ref.read(xrayCoreProvider)
                : ref.read(singBoxCoreProvider),
        'hysteria': (ServerModel selectedServer, SphiaConfig sphiaConfig) =>
            (selectedServer.protocolProvider ??
                        sphiaConfig.hysteriaProvider.index) ==
                    HysteriaProvider.sing.index
                ? ref.read(singBoxCoreProvider)
                : ref.read(hysteriaCoreProvider),
      };
      final core = protocolToCore[protocol]?.call(selectedServer, sphiaConfig);
      if (core == null) {
        logger.e('Unsupported protocol: $protocol');
        throw Exception('Unsupported protocol: $protocol');
      }
      final routingProviderName = _getProviderCoreName(routingProvider);
      // if routing provider is different from the selected server's provider
      if (routingProviderName != core.name) {
        cores.add(core);
        late final int additionalServerPort;
        // determine the additional server port
        // if protocol provider is sing-box or xray-core
        // use the socks port or mixed port as the additional server port
        // otherwise use the additional socks port
        if (routingProvider == RoutingProvider.sing.index) {
          cores.add(ref.read(singBoxCoreProvider)..isRouting = true);
          if (core.name == 'xray-core') {
            additionalServerPort = sphiaConfig.socksPort;
          } else {
            additionalServerPort = sphiaConfig.additionalSocksPort;
          }
        } else {
          cores.add(ref.read(xrayCoreProvider)..isRouting = true);
          if (core.name == 'sing-box') {
            additionalServerPort = sphiaConfig.mixedPort;
          } else {
            additionalServerPort = sphiaConfig.additionalSocksPort;
          }
        }
        additionalServer = XrayServer.socksDefaults()
          ..remark = 'Additional Socks Server'
          ..address = sphiaConfig.listen
          ..port = additionalServerPort;
      } else {
        // mark the first core as routing
        cores.add(core..isRouting = true);
      }
    }
    if (additionalServer != null) {
      // add additional server to the routing core
      final index = cores.indexWhere((core) => core.isRouting);
      if (index != -1) {
        cores[index].servers.add(additionalServer);
      }
    }
    return cores;
  }

  Future<void> stopCores({bool keepSysProxy = false}) async {
    final preState = state.valueOrNull;
    if (preState == null) {
      return;
    }
    if (preState.cores.isNotEmpty) {
      state = const AsyncValue.loading();
      final proxyNotifier = ref.read(proxyNotifierProvider.notifier);
      if (!keepSysProxy) {
        if (SystemUtil.getSystemProxy()) {
          // automatically disable system proxy
          SystemUtil.disableSystemProxy();
          proxyNotifier.setSystemProxy(false);
        }
      }
      // wait for collecting traffic data
      await Future.delayed(const Duration(milliseconds: 200));
      final trafficNotifier = ref.read(trafficNotifierProvider.notifier);
      await trafficNotifier.stop();
      logger.i('Stopping cores');
      proxyNotifier.setCoreRunning(false);
      await TrayUtil.setIcon(coreRunning: false);
      for (var core in preState.cores) {
        await core.stop();
      }
      proxyNotifier.setTunMode(false);
      state = const AsyncValue.data(CoreState(cores: []));
    }
  }

  // switch to another rule group will restart cores
  Future<void> restartCores() async {
    final currState = state.valueOrNull;
    if (currState == null) {
      return;
    }
    if (currState.cores.isNotEmpty) {
      logger.i('Restarting cores');
      final runningServer = await getRunningServerModel();
      try {
        await stopCores(keepSysProxy: true);
        await startCores(runningServer);
      } on Exception catch (e) {
        logger.e('Failed to restart cores: $e');
        throw Exception('Failed to restart cores: $e');
      }
    }
  }

  String _getProviderCoreName(int index) =>
      index == RoutingProvider.sing.index ? 'sing-box' : 'xray-core';

  int _getRunningServerId() {
    final currentState = state.valueOrNull;
    if (currentState == null) {
      logger.e('No proxy state');
      throw Exception('No proxy state');
    }
    if (currentState.cores.isEmpty) {
      logger.e('No running server');
      throw Exception('No running server');
    }
    // only single server is supported
    return currentState.proxy.servers.first.id;
  }

  Future<ServerModel> getRunningServerModel() async {
    final runningServerId = _getRunningServerId();
    // do not get server from coreProvider, because it may has been modified
    final runningServerModel =
        await serverDao.getServerModelById(runningServerId);
    if (runningServerModel == null) {
      logger.e('Failed to get running server');
      throw Exception('Failed to get running server');
    }
    return runningServerModel;
  }
}
