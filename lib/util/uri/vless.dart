import 'dart:core';

import 'package:drift/drift.dart' show Value;
import 'package:sphia/app/database/database.dart';
import 'package:sphia/core/server/defaults.dart';
import 'package:sphia/util/uri/uri.dart';

class VlessUtil {
  static String getUri(Server server) {
    final parameters = getParameters(server);

    final parameterComponent = parameters.entries
        .map((e) => UriUtil.encodeParameter(e.key, e.value))
        .join('&');

    final remarkComponent = server.remark.isNotEmpty
        ? '#${Uri.encodeComponent(server.remark)}'
        : '';

    return 'vless://${server.authPayload}@${server.address}:${server.port}?$parameterComponent$remarkComponent';
  }

  static Server parseUri(String uri) {
    String remark = '';
    String address = '';
    int port = 0;
    String uuid = '';
    String? serverName;
    String? fingerPrint;
    String? publicKey;
    String? shortId;
    String? spiderX;
    String? tls;
    String? transport;
    String? flow;
    String? grpcMode;
    String? serviceName;
    String? path;
    String? host;

    uri = uri.replaceAll('/?', '?');

    if (uri.contains('#')) {
      String parseRemark = UriUtil.extractComponent(uri, '#');
      remark = parseRemark;
      uri = uri.split('#')[0];
    }

    final parameters = UriUtil.extractParameters(uri);

    transport = parameters['type'] ?? 'tcp';
    switch (transport) {
      case 'tcp':
        break;
      case 'ws':
        path = parameters['path'] != null
            ? Uri.decodeComponent(parameters['path']!)
            : null;
        host = parameters['host'] != null
            ? Uri.decodeComponent(parameters['host']!)
            : null;
        break;
      case 'grpc':
        grpcMode = parameters['mode'] ?? 'gun';
        serviceName = parameters['serviceName'];
        break;
    }

    switch (parameters['flow']) {
      case 'xtls-rprx-vision':
        flow = 'xtls-rprx-vision';
        break;
      default:
        flow = null;
    }

    tls = parameters['security'] ?? 'none';
    if (tls != 'none') {
      switch (tls) {
        case 'tls':
          serverName = parameters['sni'];
          fingerPrint = parameters['fp'];
          break;
        case 'reality':
          serverName = parameters['sni'];
          fingerPrint = parameters['fp'];
          publicKey = parameters['pbk'];
          shortId = parameters['sid'];
          spiderX = parameters['spx'];
          break;
        default:
          break;
      }
    }

    final regex =
        RegExp(r'^' 'vless' r'://(?<uuid>.+?)@(?<address>.+):(?<port>\d+)');
    final match = regex.firstMatch(uri.split('?').first);

    if (match == null) {
      throw const FormatException('Failed to parse vless URI');
    }

    address = match.namedGroup('address')!;
    port = int.parse(match.namedGroup('port')!);
    uuid = match.namedGroup('uuid')!;
    return ServerDefaults.xrayDefaults(-1, -1).copyWith(
      protocol: 'vless',
      remark: remark,
      address: address,
      port: port,
      authPayload: uuid,
      encryption: const Value('none'),
      serverName: Value(serverName),
      fingerprint: Value(fingerPrint),
      publicKey: Value(publicKey),
      shortId: Value(shortId),
      spiderX: Value(spiderX),
      tls: Value(tls),
      transport: Value(transport),
      flow: Value(flow),
      grpcMode: Value(grpcMode),
      serviceName: Value(serviceName),
      path: Value(path),
      host: Value(host),
    );
  }

  static Map<String, dynamic> transportParameters(Server server) {
    final transportParameters = <String, Map<String, dynamic>>{
      'tcp': {},
      'ws': {
        'path': server.path,
        'host': server.host,
      },
      'grpc': {
        'serviceName': server.serviceName,
        'mode': server.grpcMode ?? 'gun',
      },
      'httpupgrade': {
        'path': server.path,
        'host': server.host,
      },
    };
    return transportParameters[server.transport]!;
  }

  static Map<String, dynamic> tlsParameters(Server server) {
    return server.tls != 'none'
        ? {
            'security': server.tls,
            'sni': server.serverName,
          }
        : {};
  }

  static Map<String, String?> getParameters(Server server) {
    return {
      'type': server.transport,
      'encryption': server.encryption,
      'flow': server.flow,
      'fp': server.fingerprint,
      'pbk': server.publicKey,
      'sid': server.shortId,
      'spx': server.spiderX,
      ...transportParameters(server).map((k, v) => MapEntry(k, v?.toString())),
      ...tlsParameters(server).map((k, v) => MapEntry(k, v?.toString())),
    }..removeWhere((key, value) => value == null || value.isEmpty);
  }
}
