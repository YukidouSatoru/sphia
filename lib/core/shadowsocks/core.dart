import 'dart:core';

import 'package:get_it/get_it.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/core/core.dart';

class ShadowsocksRustCore extends Core {
  ShadowsocksRustCore() : super('shadowsocks-rust', [], '');

  @override
  Future<void> configure(Server selectedServer) async {
    if (selectedServer.protocol == 'shadowsocks') {
      serverId = [selectedServer.id];
      final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
      final arguments = [
        '-s',
        '${selectedServer.address}:${selectedServer.port}',
        '-b',
        '127.0.0.1:${sphiaConfig.additionalSocksPort}',
        '-m',
        selectedServer.encryption ?? 'aes-128-gcm',
        '-k',
        selectedServer.authPayload,
      ];
      coreArgs.addAll(arguments);
    } else {
      throw Exception(
          'Shadowsocks-Rust does not support this server type: ${selectedServer.protocol}');
    }
  }

  @override
  Future<String> generateConfig(List<Server> servers) async {
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
