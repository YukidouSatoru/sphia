import 'dart:convert';
import 'dart:core';

import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/core/core.dart';
import 'package:sphia/core/hysteria/config.dart';
import 'package:sphia/util/system.dart';

class HysteriaCore extends Core {
  HysteriaCore()
      : super('hysteria', ['-c', p.join(tempPath, 'hysteria.json')],
            'hysteria.json');

  @override
  Future<void> configure(Server selectedServer) async {
    serverId = [selectedServer.id];
    final jsonString = await generateConfig(selectedServer);
    await writeConfig(jsonString);
  }

  @override
  Future<String> generateConfig(Server mainServer) async {
    if (mainServer.protocol == 'hysteria') {
      final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
      final hysteriaConfig = HysteriaConfig(
        server: '${mainServer.address}:${mainServer.port}',
        protocol: mainServer.hysteriaProtocol ?? 'udp',
        obfs: mainServer.obfs,
        alpn: mainServer.alpn,
        auth: mainServer.authType != 'none'
            ? (mainServer.authType == 'base64' ? mainServer.authPayload : null)
            : null,
        authStr: mainServer.authType != 'none'
            ? (mainServer.authType == 'str' ? mainServer.authPayload : null)
            : null,
        serverName: mainServer.serverName,
        insecure: mainServer.allowInsecure ?? false,
        upMbps: mainServer.upMbps ?? 10,
        downMbps: mainServer.downMbps ?? 50,
        recvWindowConn: mainServer.recvWindowConn,
        recvWindow: mainServer.recvWindow,
        disableMtuDiscovery: mainServer.disableMtuDiscovery ?? false,
        socks5: Socks5(
          listen: '127.0.0.1:${sphiaConfig.additionalSocksPort}',
          timeout: 300,
          disableUdp: !sphiaConfig.enableUdp,
        ),
      );

      return jsonEncode(hysteriaConfig.toJson());
    } else {
      throw Exception(
          'Hyteria does not support this server type: ${mainServer.protocol}');
    }
  }
}
