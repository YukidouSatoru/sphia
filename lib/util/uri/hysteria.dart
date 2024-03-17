import 'dart:core';

import 'package:sphia/server/hysteria/server.dart';
import 'package:sphia/util/uri/uri.dart';

class HysteriaUtil {
  static String getUri(HysteriaServer server) {
    final parameters = getParameters(server);

    final parameterComponent = parameters.entries
        .map((e) => UriUtil.encodeParameter(e.key, e.value))
        .join('&');

    final remarkComponent = server.remark.isNotEmpty
        ? '#${Uri.encodeComponent(server.remark)}'
        : '';
    return 'hysteria://${server.address}:${server.port}?$parameterComponent$remarkComponent';
  }

  static HysteriaServer parseUri(String uri) {
    final server = HysteriaServer.defaults();

    uri = uri.replaceAll('/?', '?');

    if (uri.contains('#')) {
      String parseRemark = UriUtil.extractComponent(uri, '#');
      server.remark = parseRemark;
      uri = uri.split('#')[0];
    }

    if (uri.contains('?')) {
      final parameters = UriUtil.extractParameters(uri);
      if (parameters.containsKey('protocol')) {
        server.hysteriaProtocol = parameters['protocol']!;
      }
      server.obfs = parameters['obfsParam'];
      server.alpn = parameters['alpn'];
      if (parameters.containsKey('authType')) {
        server.authType = parameters['authType']!;
      }
      if (parameters.containsKey('auth')) {
        server.authPayload = parameters['auth']!;
      }
      server.serverName = parameters['peer'];
      if (parameters.containsKey('insecure')) {
        server.insecure = parameters['insecure'] == '1';
      }
      if (parameters.containsKey('upmbps')) {
        server.upMbps = int.parse(parameters['upmbps']!);
      }
      if (parameters.containsKey('downmbps')) {
        server.downMbps = int.parse(parameters['downmbps']!);
      }
      uri = uri.split('?')[0];
    }

    final regex = RegExp(r'^hysteria://(?<address>[^:]+):(?<port>\d+)');

    final match = regex.firstMatch(uri);

    if (match == null) {
      throw const FormatException('Failed to parse hysteria URI');
    }

    server.address = match.namedGroup('address')!;
    server.port = int.parse(match.namedGroup('port')!);
    return server;
  }

  static Map<String, String?> getParameters(HysteriaServer server) {
    return {
      'protocol': server.hysteriaProtocol,
      'auth': server.authPayload,
      'peer': server.serverName,
      'insecure': server.insecure ? '1' : '0',
      'upmbps': server.upMbps.toString(),
      'downmbps': server.downMbps.toString(),
      'alpn': server.alpn,
      'obfsParam': server.obfs,
    }..removeWhere((key, value) => value == null || value.isEmpty);
  }
}
