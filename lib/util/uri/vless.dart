import 'dart:core';

import 'package:sphia/server/xray/server.dart';
import 'package:sphia/util/uri/uri.dart';

class VlessUtil {
  static String getUri(XrayServer server) {
    final parameters = getParameters(server);

    final parameterComponent = parameters.entries
        .map((e) => UriUtil.encodeParameter(e.key, e.value))
        .join('&');

    final remarkComponent = server.remark.isNotEmpty
        ? '#${Uri.encodeComponent(server.remark)}'
        : '';

    return 'vless://${server.authPayload}@${server.address}:${server.port}?$parameterComponent$remarkComponent';
  }

  static XrayServer parseUri(String uri) {
    final server = XrayServer.vlessDefaults();

    uri = uri.replaceAll('/?', '?');

    if (uri.contains('#')) {
      String parseRemark = UriUtil.extractComponent(uri, '#');
      server.remark = parseRemark;
      uri = uri.split('#')[0];
    }

    final parameters = UriUtil.extractParameters(uri);

    server.transport = parameters['type'] ?? 'tcp';
    switch (server.transport) {
      case 'tcp':
        break;
      case 'ws':
        server.path = parameters['path'] != null
            ? Uri.decodeComponent(parameters['path']!)
            : null;
        server.host = parameters['host'] != null
            ? Uri.decodeComponent(parameters['host']!)
            : null;
        break;
      case 'grpc':
        server.grpcMode = parameters['mode'] ?? 'gun';
        server.serviceName = parameters['serviceName'];
        break;
    }

    switch (parameters['flow']) {
      case 'xtls-rprx-vision':
        server.flow = 'xtls-rprx-vision';
        break;
      default:
        server.flow = null;
    }

    server.tls = parameters['security'] ?? 'none';
    if (server.tls != 'none') {
      switch (server.tls) {
        case 'tls':
          server.serverName = parameters['sni'];
          server.fingerprint = parameters['fp'];
          break;
        case 'reality':
          server.serverName = parameters['sni'];
          server.fingerprint = parameters['fp'];
          server.publicKey = parameters['pbk'];
          server.shortId = parameters['sid'];
          server.spiderX = parameters['spx'];
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

    server.address = match.namedGroup('address')!;
    server.port = int.parse(match.namedGroup('port')!);
    server.authPayload = match.namedGroup('uuid')!;
    return server;
  }

  static Map<String, dynamic> transportParameters(XrayServer server) {
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

  static Map<String, dynamic> tlsParameters(XrayServer server) {
    return server.tls != 'none'
        ? {
            'security': server.tls,
            'sni': server.serverName,
          }
        : {};
  }

  static Map<String, String?> getParameters(XrayServer server) {
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
