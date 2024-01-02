import 'package:get_it/get_it.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/core.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/core/core_base.dart';
import 'package:sphia/core/hysteria/core.dart';
import 'package:sphia/core/server/defaults.dart';
import 'package:sphia/core/shadowsocks/core.dart';
import 'package:sphia/core/sing/core.dart';
import 'package:sphia/core/xray/core.dart';
import 'package:sphia/util/system.dart';

class SphiaController {
  static Future<void> toggleCores(Server server) async {
    final coreProvider = GetIt.I.get<CoreProvider>();
    try {
      if (coreProvider.cores.isNotEmpty) {
        if (server == coreProvider.cores[0].runningServer) {
          await stopCores();
        } else {
          await stopCores();
          await startCores(server);
        }
      } else {
        await startCores(server);
      }
    } on Exception catch (_) {
      // logger.e('Failed to start core: $e');
      rethrow;
    }
  }

  static Future<void> startCores(Server server) async {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    final coreProvider = GetIt.I.get<CoreProvider>();
    final protocol = server.protocol;
    final int routingProvider =
        server.routingProvider ?? sphiaConfig.routingProvider;
    late final int protocolProvider;
    List<CoreBase> newCores = [];
    late final Server? additionalServer;

    if (sphiaConfig.enableTun) {
      if (!SystemUtil.isRoot) {
        logger.e('Tun mode requires administrator privileges');
        throw Exception('Tun mode requires administrator privileges');
      }
      newCores.add(SingBoxCore()..isRouting = true);
    } else {
      switch (protocol) {
        case 'vmess':
          protocolProvider =
              server.protocolProvider ?? sphiaConfig.vmessProvider;
          if (protocolProvider == VmessProvider.xray.index) {
            newCores.add(XrayCore());
          } else {
            newCores.add(SingBoxCore());
          }
          break;
        case 'vless':
          protocolProvider =
              server.protocolProvider ?? sphiaConfig.vlessProvider;
          if (protocolProvider == VlessProvider.xray.index) {
            newCores.add(XrayCore());
          } else {
            newCores.add(SingBoxCore());
          }
          break;
        case 'shadowsocks':
          protocolProvider =
              server.protocolProvider ?? sphiaConfig.shadowsocksProvider;
          if (protocolProvider == ShadowsocksProvider.xray.index) {
            newCores.add(XrayCore());
          } else if (protocolProvider == ShadowsocksProvider.sing.index) {
            newCores.add(SingBoxCore());
          } else {
            newCores.add(ShadowsocksRustCore());
          }
          break;
        case 'trojan':
          protocolProvider =
              server.protocolProvider ?? sphiaConfig.trojanProvider;
          if (protocolProvider == TrojanProvider.xray.index) {
            newCores.add(XrayCore());
          } else {
            newCores.add(SingBoxCore());
          }
          break;
        case 'hysteria':
          protocolProvider =
              server.protocolProvider ?? sphiaConfig.hysteriaProvider;
          if (protocolProvider == HysteriaProvider.sing.index) {
            newCores.add(SingBoxCore());
          } else {
            newCores.add(HysteriaCore());
          }
          break;
      }
      if (getProviderCoreName(routingProvider) != newCores[0].coreName) {
        late final int additionalServerPort;
        if (routingProvider == RoutingProvider.sing.index) {
          newCores.add(SingBoxCore()..isRouting = true);
          if (newCores[0].coreName == 'xray-core') {
            additionalServerPort = sphiaConfig.socksPort;
          } else {
            additionalServerPort = sphiaConfig.additionalSocksPort;
          }
        } else {
          newCores.add(XrayCore()..isRouting = true);
          if (newCores[0].coreName == 'sing-box') {
            additionalServerPort = sphiaConfig.mixedPort;
          } else {
            additionalServerPort = sphiaConfig.additionalSocksPort;
          }
        }
        additionalServer = ServerDefaults.xrayDefaults(-1, -1).copyWith(
          remark: 'Additional Socks Server',
          protocol: 'socks',
          address: sphiaConfig.listen,
          port: additionalServerPort,
        );
      } else {
        newCores.last.isRouting = true;
      }
    }

    coreProvider.updateCores(newCores);

    try {
      logger.i('Starting cores');
      if (sphiaConfig.enableTun) {
        // Only SingBoxCore
        await coreProvider.cores[0].start(server);
      } else {
        // If provider core is route core
        if (coreProvider.cores.length == 1) {
          await coreProvider.cores[0].start(server);
        } else {
          for (var core in coreProvider.cores) {
            if (core.coreName == getProviderCoreName(routingProvider) &&
                additionalServer != null) {
              await core.start(additionalServer);
            } else {
              await core.start(server);
            }
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
    }
  }

  static Future<void> stopCores() async {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    final coreProvider = GetIt.I.get<CoreProvider>();
    if (coreProvider.cores.isNotEmpty) {
      logger.i('Stopping cores');
      if (sphiaConfig.autoConfigureSystemProxy || SystemUtil.getSystemProxy()) {
        SystemUtil.disableSystemProxy();
      }
      coreProvider.updateCoreRunning(false);
      // wait traffic to stop
      await Future.delayed(const Duration(milliseconds: 500));
      for (var core in coreProvider.cores) {
        await core.stop();
      }
      coreProvider.updateCores([]);
    }
  }

  static Future<void> restartCores() async {
    final coreProvider = GetIt.I.get<CoreProvider>();
    late final Server server;
    if (coreProvider.cores.isNotEmpty) {
      logger.i('Restarting cores');
      server = coreProvider.cores[0].runningServer;
      try {
        await stopCores();
        await startCores(server);
      } on Exception catch (e) {
        logger.e('Failed to restart cores: $e');
        rethrow;
      }
      coreProvider.updateCoreRunning(true);
    }
  }

  static String getProviderCoreName(int providerIndex) =>
      providerIndex == RoutingProvider.sing.index ? 'sing-box' : 'xray-core';
}
