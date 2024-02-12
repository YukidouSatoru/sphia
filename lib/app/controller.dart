import 'package:get_it/get_it.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/core.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/tray.dart';
import 'package:sphia/core/hysteria/core.dart';
import 'package:sphia/core/server/defaults.dart';
import 'package:sphia/core/shadowsocks/core.dart';
import 'package:sphia/core/sing/core.dart';
import 'package:sphia/core/xray/core.dart';
import 'package:sphia/util/system.dart';

class SphiaController {
  static Future<void> toggleCores() async {
    final coreProvider = GetIt.I.get<CoreProvider>();
    try {
      final selectedServer = await serverDao.getSelectedServer();
      if (selectedServer == null) {
        return;
      }
      if (coreProvider.cores.isNotEmpty) {
        final runningServer = await getRunningServer();
        if (selectedServer == runningServer) {
          await stopCores();
        } else {
          await stopCores();
          await startCores(selectedServer);
        }
      } else {
        await startCores(selectedServer);
      }
    } on Exception catch (_) {
      // logger.e('Failed to start core: $e');
      rethrow;
    }
  }

  static Future<void> startCores(Server selectedServer) async {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    final coreProvider = GetIt.I.get<CoreProvider>();
    final protocol = selectedServer.protocol;
    final int routingProvider =
        selectedServer.routingProvider ?? sphiaConfig.routingProvider;
    late final Server? additionalServer;

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
        'vmess': (Server selectedServer, SphiaConfig sphiaConfig) =>
            (selectedServer.protocolProvider ?? sphiaConfig.vmessProvider) ==
                    VmessProvider.xray.index
                ? XrayCore()
                : SingBoxCore(),
        'vless': (Server selectedServer, SphiaConfig sphiaConfig) =>
            (selectedServer.protocolProvider ?? sphiaConfig.vlessProvider) ==
                    VlessProvider.xray.index
                ? XrayCore()
                : SingBoxCore(),
        'shadowsocks': (Server selectedServer, SphiaConfig sphiaConfig) {
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
        'trojan': (Server selectedServer, SphiaConfig sphiaConfig) =>
            (selectedServer.protocolProvider ?? sphiaConfig.trojanProvider) ==
                    TrojanProvider.xray.index
                ? XrayCore()
                : SingBoxCore(),
        'hysteria': (Server selectedServer, SphiaConfig sphiaConfig) =>
            (selectedServer.protocolProvider ?? sphiaConfig.hysteriaProvider) ==
                    HysteriaProvider.sing.index
                ? SingBoxCore()
                : HysteriaCore(),
      };
      final core = protocolToCore[protocol]?.call(selectedServer, sphiaConfig);
      if (core != null) {
        coreProvider.cores.add(core);
      }
      if (!coreProvider.cores.first.isRouting) {
        late final int additionalServerPort;
        if (routingProvider == RoutingProvider.sing.index) {
          coreProvider.cores.add(SingBoxCore()..isRouting = true);
          if (coreProvider.cores.first.name == 'xray-core') {
            additionalServerPort = sphiaConfig.socksPort;
          } else {
            additionalServerPort = sphiaConfig.additionalSocksPort;
          }
        } else {
          coreProvider.cores.add(XrayCore()..isRouting = true);
          if (coreProvider.cores.first.name == 'sing-box') {
            additionalServerPort = sphiaConfig.mixedPort;
          } else {
            additionalServerPort = sphiaConfig.additionalSocksPort;
          }
        }
        additionalServer =
            ServerDefaults.xrayDefaults(defaultServerGroupId, defaultServerId)
                .copyWith(
          protocol: 'socks',
          address: sphiaConfig.listen,
          port: additionalServerPort,
        );
      } else {
        coreProvider.cores.first.isRouting = true;
      }
    }

    try {
      logger.i('Starting cores');
      if (coreProvider.cores.length == 1) {
        // Only routing core
        await coreProvider.cores.first.start(selectedServer);
      } else {
        for (var core in coreProvider.cores) {
          if (core.isRouting && additionalServer != null) {
            await core.start(additionalServer);
          } else {
            await core.start(selectedServer);
          }
        }
      }
    } on Exception catch (_) {
      await stopCores();
      rethrow;
    }
    coreProvider.updateCoreRunning(true);
    int socksPort = sphiaConfig.socksPort;
    int httpPort = sphiaConfig.httpPort;
    if (routingProvider == RoutingProvider.sing.index) {
      socksPort = sphiaConfig.mixedPort;
      httpPort = sphiaConfig.mixedPort;
    }
    if (sphiaConfig.autoConfigureSystemProxy) {
      SystemUtil.enableSystemProxy(
        sphiaConfig.listen,
        socksPort,
        httpPort,
      );
      await SphiaTray.setMenuItem('sysProxy', true);
    }
  }

  static Future<void> stopCores() async {
    final coreProvider = GetIt.I.get<CoreProvider>();
    if (coreProvider.cores.isNotEmpty) {
      logger.i('Stopping cores');
      final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
      if (sphiaConfig.autoConfigureSystemProxy || SystemUtil.getSystemProxy()) {
        SystemUtil.disableSystemProxy();
        await SphiaTray.setMenuItem('sysProxy', false);
      }
      coreProvider.updateCoreRunning(false);
      // wait traffic to stop
      await Future.delayed(const Duration(milliseconds: 500));
      for (var core in coreProvider.cores) {
        await core.stop();
      }
      coreProvider.cores = [];
    }
  }

  // switch to another rule group will restart cores
  static Future<void> restartCores() async {
    final coreProvider = GetIt.I.get<CoreProvider>();
    if (coreProvider.cores.isNotEmpty) {
      logger.i('Restarting cores');
      final runningServer = await getRunningServer();
      try {
        await stopCores();
        await startCores(runningServer);
      } on Exception catch (e) {
        logger.e('Failed to restart cores: $e');
        rethrow;
      }
      coreProvider.updateCoreRunning(true);
    }
  }

  static Future<Server> getRunningServer() async {
    final coreProvider = GetIt.I.get<CoreProvider>();
    if (coreProvider.cores.isEmpty) {
      logger.e('No running server');
      throw Exception('No running server');
    }
    final runningServerId = coreProvider.cores.first.serverId.first;
    final runningServer = await serverDao.getServerById(runningServerId);
    if (runningServer == null) {
      logger.e('Failed to get running server');
      throw Exception('Failed to get running server');
    }
    return runningServer;
  }
}
