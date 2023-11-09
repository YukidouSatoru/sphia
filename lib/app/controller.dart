import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/core.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/server/core_base.dart';
import 'package:sphia/server/hysteria/core.dart';
import 'package:sphia/server/shadowsocks/core.dart';
import 'package:sphia/server/sing-box/core.dart';
import 'package:sphia/server/xray/core.dart';
import 'package:sphia/server/xray/server.dart';
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
    final protocol = jsonDecode(server.data)['protocol'];
    final int routingProvider = jsonDecode(server.data)['routingProvider'] ??
        sphiaConfig.routingProvider;
    late final int protocolProvider;
    List<CoreBase> newCores = [];
    late final XrayServer? additionalServerBase;

    if (sphiaConfig.enableTun) {
      if (!SystemUtil.isRoot) {
        logger.e('Tun mode requires administrator privileges');
        throw Exception('Tun mode requires administrator privileges');
      }
      newCores.add(SingBoxCore());
    } else {
      switch (protocol) {
        case 'vmess':
          protocolProvider = jsonDecode(server.data)['protocolProvider'] ??
              sphiaConfig.vmessProvider;
          if (protocolProvider == VmessProvider.xray.index) {
            newCores.add(XrayCore());
          } else {
            newCores.add(SingBoxCore());
          }
          break;
        case 'vless':
          protocolProvider = jsonDecode(server.data)['protocolProvider'] ??
              sphiaConfig.vlessProvider;
          if (protocolProvider == VlessProvider.xray.index) {
            newCores.add(XrayCore());
          } else {
            newCores.add(SingBoxCore());
          }
          break;
        case 'shadowsocks':
          protocolProvider = jsonDecode(server.data)['protocolProvider'] ??
              sphiaConfig.shadowsocksProvider;
          if (protocolProvider == ShadowsocksProvider.xray.index) {
            newCores.add(XrayCore());
          } else if (protocolProvider == ShadowsocksProvider.sing.index) {
            newCores.add(SingBoxCore());
          } else {
            newCores.add(ShadowsocksRustCore());
          }
          break;
        case 'trojan':
          protocolProvider = jsonDecode(server.data)['protocolProvider'] ??
              sphiaConfig.trojanProvider;
          if (protocolProvider == TrojanProvider.xray.index) {
            newCores.add(XrayCore());
          } else {
            newCores.add(SingBoxCore());
          }
          break;
        case 'hysteria':
          protocolProvider = jsonDecode(server.data)['protocolProvider'] ??
              sphiaConfig.hysteriaProvider;
          if (protocolProvider == HysteriaProvider.sing.index) {
            newCores.add(SingBoxCore());
          } else {
            newCores.add(HysteriaCore());
          }
          break;
      }
      if (getProviderCoreName(routingProvider) != newCores[0].coreName) {
        additionalServerBase = XrayServer.defaults()
          ..remark = 'Additional Socks Server'
          ..protocol = 'socks'
          ..address = sphiaConfig.listen;
        if (routingProvider == RoutingProvider.sing.index) {
          newCores.add(SingBoxCore());
          if (newCores[0].coreName == 'xray-core') {
            additionalServerBase.port = sphiaConfig.socksPort;
          } else {
            additionalServerBase.port = sphiaConfig.additionalSocksPort;
          }
        } else {
          newCores.add(XrayCore());
          if (newCores[0].coreName == 'sing-box') {
            additionalServerBase.port = sphiaConfig.mixedPort;
          } else {
            additionalServerBase.port = sphiaConfig.additionalSocksPort;
          }
        }
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
                additionalServerBase != null) {
              final additionalServer = Server(
                id: -1,
                groupId: -1,
                data:
                    const JsonEncoder().convert(additionalServerBase.toJson()),
              );
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
    if (sphiaConfig.autoConfigureSystemProxy) {
      SystemUtil.configureSystemProxy(true);
    }
  }

  static Future<void> stopCores() async {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    final coreProvider = GetIt.I.get<CoreProvider>();
    if (coreProvider.cores.isNotEmpty) {
      logger.i('Stopping cores');
      if (sphiaConfig.autoConfigureSystemProxy) {
        SystemUtil.configureSystemProxy(false);
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
