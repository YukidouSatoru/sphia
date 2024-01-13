import 'dart:convert';
import 'dart:core';

import 'package:drift/drift.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/core/server/defaults.dart';

class VMessUtil {
  static String getUri(Server server) {
    late final String? path;
    if (server.transport == 'grpc') {
      path = server.serviceName;
    } else {
      path = server.path;
    }
    final Map<String, dynamic> vmessJson = {
      'v': 2,
      'ps': server.remark,
      'add': server.address,
      'port': server.port,
      'id': server.authPayload,
      'aid': server.alterId,
      'scy': server.encryption,
      'net': server.transport,
      'type': 'none',
      'host': server.host,
      'path': path,
      'tls': server.tls,
      'sni': server.serverName,
      'fp': server.fingerprint,
    }..removeWhere(
        (key, value) => value == null || (value is String && value == ''));
    String jsonString = json.encode(vmessJson);
    return 'vmess://${base64UrlEncode(utf8.encode(jsonString))}';
  }

  static Server parseUri(String uri) {
    String vmessJson;
    String remark = '';
    String address = '';
    int port = 0;
    String uuid = '';
    int alterId = 0;
    String encryption = 'auto';
    String transport = 'tcp';
    String? path;
    String? host;
    String? tls;
    String? serverName;
    String? fingerPrint;
    String? serviceName;

    try {
      vmessJson = utf8.decode(base64Url.decode(uri.substring(8)));
    } on Exception catch (_) {
      throw const FormatException('Failed to parse vmess URI');
    }

    try {
      Map<String, dynamic> vmess =
          json.decode(vmessJson) as Map<String, dynamic>;
      remark = vmess['ps'] ?? '';
      address = vmess['add'];
      port = vmess['port'] is String ? int.parse(vmess['port']) : vmess['port'];
      uuid = vmess['id'];
      alterId = vmess['aid'] is String ? int.parse(vmess['aid']) : vmess['aid'];
      if (vmess.containsKey('scy')) {
        encryption = vmess['scy'];
      }
      if (vmess.containsKey('type')) {
        encryption = vmess['type'];
      }
      transport = vmess['net'];
      switch (transport) {
        case 'grpc':
          serviceName = vmess['path'];
          break;
        default:
          path = vmess['path'];
          break;
      }
      host = vmess['host'];
      tls = vmess['tls'] ?? 'none';
      serverName = vmess['sni'];
      fingerPrint = vmess['fp'];
    } on Exception catch (_) {
      throw const FormatException('Failed to parse vmess URI');
    }
    return ServerDefaults.xrayDefaults(-1, -1).copyWith(
      protocol: 'vmess',
      remark: remark,
      address: address,
      port: port,
      authPayload: uuid,
      alterId: Value(alterId),
      encryption: Value(encryption),
      transport: Value(transport),
      path: Value(path),
      host: Value(host),
      tls: Value(tls),
      serverName: Value(serverName),
      fingerprint: Value(fingerPrint),
      serviceName: Value(serviceName),
    );
  }
}
