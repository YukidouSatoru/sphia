import 'dart:core';

import 'package:get_it/get_it.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/core/core_base.dart';

class ShadowsocksRustCore extends CoreBase {
  ShadowsocksRustCore() : super('shadowsocks-rust', [], '');

  @override
  Future<void> configure(Server server) async {
    if (server.protocol == 'shadowsocks') {
      final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
      final arguments = [
        '-s',
        '${server.address}:${server.port}',
        '-b',
        '127.0.0.1:${sphiaConfig.additionalSocksPort}',
        '-m',
        server.encryption ?? 'aes-128-gcm',
        '-k',
        server.authPayload,
      ];
      coreArgs.addAll(arguments);
    } else {
      throw Exception(
          'Shadowsocks-Rust does not support this server type: ${server.protocol}');
    }
  }

  @override
  Future<String> generateConfig(Server server) async {
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
