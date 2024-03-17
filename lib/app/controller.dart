import 'package:get_it/get_it.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/core.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/tray.dart';
import 'package:sphia/core/hysteria/core.dart';
import 'package:sphia/core/sing/core.dart';
import 'package:sphia/core/ssrust/core.dart';
import 'package:sphia/core/xray/core.dart';
import 'package:sphia/server/server_model.dart';
import 'package:sphia/server/xray/server.dart';
import 'package:sphia/util/system.dart';

class SphiaController {
  static Future<void> toggleCores() async {
    final coreProvider = GetIt.I.get<CoreProvider>();
    try {
      final selectedServer = await serverDao.getSelectedServerModel();
      if (selectedServer == null) {
        return;
      }
      if (coreProvider.cores.isNotEmpty) {
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

  static Future<void> startCores(ServerModel selectedServer) async {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    final coreProvider = GetIt.I.get<CoreProvider>();
    final protocol = selectedServer.protocol;
    final int routingProvider =
        selectedServer.routingProvider ?? sphiaConfig.routingProvider;
    late final ServerModel? additionalServer;

    coreProvider.cores = [];

    if (sphiaConfig.enableTun) {
      if (!SystemUtil.isRoot) {
        logger.e('Tun mode requires administrator privileges');
        throw Exception('Tun mode requires administrator privileges');
      }
      coreProvider.cores.add(SingBoxCore()..isRouting = true);
    } else if (sphiaConfig.multiOutboundSupport) {
      if (sphiaConfig.routingProvider == RoutingProvider.sing.index) {
        coreProvider.cores.add(SingBoxCore()..isRouting = true);
      } else {
        coreProvider.cores.add(XrayCore()..isRouting = true);
      }
    } else {
      final protocolToCore = {
        'vmess': (ServerModel selectedServer, SphiaConfig sphiaConfig) =>
            (selectedServer.protocolProvider ?? sphiaConfig.vmessProvider) ==
                    VmessProvider.xray.index
                ? XrayCore()
                : SingBoxCore(),
        'vless': (ServerModel selectedServer, SphiaConfig sphiaConfig) =>
            (selectedServer.protocolProvider ?? sphiaConfig.vlessProvider) ==
                    VlessProvider.xray.index
                ? XrayCore()
                : SingBoxCore(),
        'shadowsocks': (ServerModel selectedServer, SphiaConfig sphiaConfig) {
          final protocolProvider = selectedServer.protocolProvider ??
              sphiaConfig.shadowsocksProvider;
          if (protocolProvider == ShadowsocksProvider.xray.index) {
            return XrayCore();
          } else if (protocolProvider == ShadowsocksProvider.sing.index) {
            return SingBoxCore();
          } else {
            return ShadowsocksRustCore();
          }
        },
        'trojan': (ServerModel selectedServer, SphiaConfig sphiaConfig) =>
            (selectedServer.protocolProvider ?? sphiaConfig.trojanProvider) ==
                    TrojanProvider.xray.index
                ? XrayCore()
                : SingBoxCore(),
        'hysteria': (ServerModel selectedServer, SphiaConfig sphiaConfig) =>
            (selectedServer.protocolProvider ?? sphiaConfig.hysteriaProvider) ==
                    HysteriaProvider.sing.index
                ? SingBoxCore()
                : HysteriaCore(),
      };
      final core = protocolToCore[protocol]?.call(selectedServer, sphiaConfig);
      if (core == null) {
        logger.e('Unsupported protocol: $protocol');
        throw Exception('Unsupported protocol: $protocol');
      }
      final routingProviderName = getProviderCoreName(routingProvider);
      // if routing provider is different from the selected server's provider
      if (routingProviderName != core.name) {
        coreProvider.cores.add(core);
        late final int additionalServerPort;
        // determine the additional server port
        if (routingProvider == RoutingProvider.sing.index) {
          coreProvider.cores.add(SingBoxCore()..isRouting = true);
          if (core.name == 'xray-core') {
            additionalServerPort = sphiaConfig.socksPort;
          } else {
            additionalServerPort = sphiaConfig.additionalSocksPort;
          }
        } else {
          coreProvider.cores.add(XrayCore()..isRouting = true);
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
        coreProvider.cores.add(core..isRouting = true);
      }
    }

    try {
      logger.i('Starting cores');
      if (coreProvider.cores.length == 1) {
        // Only routing core
        coreProvider.routing.servers.add(selectedServer);
        await coreProvider.routing.start();
      } else {
        for (int i = 0; i < coreProvider.cores.length; i++) {
          if (coreProvider.cores[i].isRouting && additionalServer != null) {
            coreProvider.cores[i].servers.add(additionalServer);
            await coreProvider.cores[i].start();
          } else {
            coreProvider.cores[i].servers.add(selectedServer);
            await coreProvider.cores[i].start();
          }
        }
      }
    } on Exception catch (_) {
      await stopCores();
      rethrow;
    }
    // wait for core to start, or get ip may be failed
    await Future.delayed(const Duration(milliseconds: 200));
    coreProvider.updateCoreRunning(true);
    logger.i('Starting traffic');
    coreProvider.updateTrafficRunning(true);
    if (sphiaConfig.enableTun) {
      coreProvider.updateTunMode(true);
      // do not enable system proxy in tun mode
      SystemUtil.disableSystemProxy();
      return;
    } else {
      coreProvider.updateTunMode(false);
      if (sphiaConfig.autoConfigureSystemProxy) {
        int socksPort = sphiaConfig.socksPort;
        int httpPort = sphiaConfig.httpPort;
        if (routingProvider == RoutingProvider.sing.index) {
          socksPort = sphiaConfig.mixedPort;
          httpPort = sphiaConfig.mixedPort;
        }
        SystemUtil.enableSystemProxy(
          sphiaConfig.listen,
          socksPort,
          httpPort,
        );
        await SphiaTray.setMenuItemCheck('sysProxy', true);
      }
    }
  }

  static Future<void> stopCores({bool keepSysProxy = false}) async {
    final coreProvider = GetIt.I.get<CoreProvider>();
    if (coreProvider.cores.isNotEmpty) {
      final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
      if (!keepSysProxy) {
        if (sphiaConfig.autoConfigureSystemProxy ||
            SystemUtil.getSystemProxy()) {
          // automatically disable system proxy
          SystemUtil.disableSystemProxy();
          await SphiaTray.setMenuItemCheck('sysProxy', false);
        }
      }
      logger.i('Stopping traffic');
      coreProvider.updateTrafficRunning(false);
      // wait for collecting traffic data
      await Future.delayed(const Duration(milliseconds: 200));
      logger.i('Stopping cores');
      coreProvider.updateCoreRunning(false);
      for (var core in coreProvider.cores) {
        await core.stop();
      }
      if (coreProvider.tunMode) {
        coreProvider.updateTunMode(false);
      }
      coreProvider.cores = [];
    }
  }

  // switch to another rule group will restart cores
  static Future<void> restartCores() async {
    final coreProvider = GetIt.I.get<CoreProvider>();
    if (coreProvider.cores.isNotEmpty) {
      logger.i('Restarting cores');
      final runningServer = await getRunningServerModel();
      try {
        await stopCores(keepSysProxy: true);
        await startCores(runningServer);
      } on Exception catch (e) {
        logger.e('Failed to restart cores: $e');
        rethrow;
      }
    }
  }

  static String getProviderCoreName(int providerIndex) =>
      providerIndex == RoutingProvider.sing.index ? 'sing-box' : 'xray-core';

  static int getRunningServerId() {
    final coreProvider = GetIt.I.get<CoreProvider>();
    if (coreProvider.cores.isEmpty) {
      logger.e('No running server');
      throw Exception('No running server');
    }
    // only single server is supported
    return coreProvider.proxy.servers.first.id;
  }

  static Future<ServerModel> getRunningServerModel() async {
    final runningServerId = getRunningServerId();
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
