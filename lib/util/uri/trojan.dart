import 'dart:core';

import 'package:sphia/server/trojan/server.dart';
import 'package:sphia/util/uri/uri.dart';

class TrojanUtil {
  static String getUri(TrojanServer server) {
    final parameters = getParameters(server);

    final parameterComponent = parameters.entries
        .map((e) => UriUtil.encodeParameter(e.key, e.value))
        .join('&');

    final remarkComponent = server.remark.isNotEmpty
        ? '#${Uri.encodeComponent(server.remark)}'
        : '';

    return 'trojan://${Uri.encodeComponent(server.authPayload)}@${server.address}:${server.port}?$parameterComponent$remarkComponent';
  }

  static TrojanServer parseUri(String uri) {
    final server = TrojanServer.defaults();

    uri = uri.replaceAll('/?', '?');

    if (uri.contains('#')) {
      String parseRemark = UriUtil.extractComponent(uri, '#');
      server.remark = parseRemark;
      uri = uri.split('#')[0];
    }

    if (uri.contains('?')) {
      final parameters = UriUtil.extractParameters(uri);

      if (parameters.containsKey('sni')) {
        server.serverName = parameters['sni'] != null
            ? Uri.decodeComponent(parameters['sni']!)
            : null;
      } else if (parameters.containsKey('peer')) {
        server.serverName = parameters['peer'] != null
            ? Uri.decodeComponent(parameters['peer']!)
            : null;
      }

      if (parameters.containsKey('allowInsecure')) {
        server.allowInsecure = parameters['allowInsecure'] == '1';
      }

      uri = uri.split('?')[0];
    }

    final regex =
        RegExp(r'^trojan://(?<password>[^@]+)@(?<address>[^:]+):(?<port>\d+)');

    final match = regex.firstMatch(uri);

    if (match == null) {
      throw const FormatException('Failed to parse trojan URI');
    }

    server.address = match.namedGroup('address')!;
    server.port = int.parse(match.namedGroup('port')!);
    server.authPayload = match.namedGroup('password')!;
    return server;
  }

  static Map<String, dynamic> tlsParameters(TrojanServer server) {
    return {
      'sni': server.serverName,
      'fp': server.fingerprint,
      'allowInsecure': server.allowInsecure,
    };
  }

  static Map<String, String?> getParameters(TrojanServer server) {
    return {
      ...tlsParameters(server).map((k, v) => MapEntry(k, v?.toString())),
    }..removeWhere((key, value) => value == null || value.isEmpty);
  }
}
