import 'dart:core';

import 'package:drift/drift.dart' show Value;
import 'package:sphia/app/database/database.dart';
import 'package:sphia/core/server/defaults.dart';
import 'package:sphia/util/uri/uri.dart';

class TrojanUtil {
  static String getUri(Server server) {
    final parameters = getParameters(server);

    final parameterComponent = parameters.entries
        .map((e) => UriUtil.encodeParameter(e.key, e.value))
        .join('&');

    final remarkComponent = server.remark.isNotEmpty
        ? '#${Uri.encodeComponent(server.remark)}'
        : '';

    return 'trojan://${Uri.encodeComponent(server.authPayload)}@${server.address}:${server.port}?$parameterComponent$remarkComponent';
  }

  static Server parseUri(String uri) {
    String remark = '';
    String address = '';
    int port = 0;
    String password = '';
    String? serverName;
    bool allowInsecure = false;

    uri = uri.replaceAll('/?', '?');

    if (uri.contains('#')) {
      String parseRemark = UriUtil.extractComponent(uri, '#');
      remark = parseRemark;
      uri = uri.split('#')[0];
    }

    if (uri.contains('?')) {
      final parameters = UriUtil.extractParameters(uri);

      if (parameters.containsKey('sni')) {
        serverName = parameters['sni'] != null
            ? Uri.decodeComponent(parameters['sni']!)
            : null;
      } else if (parameters.containsKey('peer')) {
        serverName = parameters['peer'] != null
            ? Uri.decodeComponent(parameters['peer']!)
            : null;
      }

      if (parameters.containsKey('allowInsecure')) {
        allowInsecure = parameters['allowInsecure'] == '1';
      }

      uri = uri.split('?')[0];
    }

    final regex =
        RegExp(r'^trojan://(?<password>[^@]+)@(?<address>[^:]+):(?<port>\d+)');

    final match = regex.firstMatch(uri);

    if (match == null) {
      throw const FormatException('Failed to parse trojan URI');
    }

    address = match.namedGroup('address')!;
    port = int.parse(match.namedGroup('port')!);
    password = match.namedGroup('password')!;
    return ServerDefaults.trojanDefaults(defaultServerGroupId, defaultServerId)
        .copyWith(
      remark: remark,
      address: address,
      port: port,
      authPayload: password,
      serverName: Value(serverName),
      allowInsecure: Value(allowInsecure),
    );
  }

  static Map<String, dynamic> tlsParameters(Server server) {
    return {
      'sni': server.serverName,
      'fp': server.fingerprint,
      'allowInsecure': server.allowInsecure,
    };
  }

  static Map<String, String?> getParameters(Server server) {
    return {
      ...tlsParameters(server).map((k, v) => MapEntry(k, v?.toString())),
    }..removeWhere((key, value) => value == null || value.isEmpty);
  }
}
