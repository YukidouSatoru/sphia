import 'dart:core';

import 'package:get_it/get_it.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/core/core.dart';
import 'package:sphia/server/shadowsocks/server.dart';

class ShadowsocksRustCore extends Core {
  ShadowsocksRustCore() : super('shadowsocks-rust', [], '');

  @override
  Future<void> configure() async {
    final server = servers.first as ShadowsocksServer;
    if (server.protocol == 'shadowsocks') {
      final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
      final arguments = [
        '-s',
        '${server.address}:${server.port}',
        '-b',
        '127.0.0.1:${sphiaConfig.additionalSocksPort}',
        '-m',
        server.encryption,
        '-k',
        server.authPayload,
      ];
      usedPorts.add(sphiaConfig.additionalSocksPort);
      args.addAll(arguments);
    } else {
      throw Exception(
          'Shadowsocks-Rust does not support this server type: ${server.protocol}');
    }
  }

  @override
  Future<String> generateConfig(ConfigParameters parameters) {
    throw UnimplementedError();
  }

  String convertPluginOpts(String pluginOpts) {
    String result = '';
    final opts = pluginOpts.split(';');
    for (var opt in opts) {
      if (opt.contains('=')) {
        result += '${opt.split('=')[0]}=${opt.split('=')[1]}&';
      } else {
        result += '$opt&';
      }
    }
    return result.substring(0, result.length - 1);
  }
}
