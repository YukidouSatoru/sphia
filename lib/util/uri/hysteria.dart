import 'dart:core';

import 'package:drift/drift.dart' show Value;
import 'package:sphia/app/database/database.dart';
import 'package:sphia/core/server/defaults.dart';
import 'package:sphia/util/uri/uri.dart';

class HysteriaUtil {
  static String getUri(Server server) {
    final parameters = getParameters(server);

    final parameterComponent = parameters.entries
        .map((e) => UriUtil.encodeParameter(e.key, e.value))
        .join('&');

    final remarkComponent = server.remark.isNotEmpty
        ? '#${Uri.encodeComponent(server.remark)}'
        : '';
    return 'hysteria://${server.address}:${server.port}?$parameterComponent$remarkComponent';
  }

  static Server parseUri(String uri) {
    String remark = '';
    String hysteriaProtocol = 'udp';
    String authType = 'none';
    String authPayload = '';
    String? serverName;
    bool allowInsecure = false;
    int upMbps = 10;
    int downMbps = 50;
    String? alpn;
    String? obfs;
    String address = '';
    int port = 0;

    uri = uri.replaceAll('/?', '?');

    if (uri.contains('#')) {
      String parseRemark = UriUtil.extractComponent(uri, '#');
      remark = parseRemark;
      uri = uri.split('#')[0];
    }

    if (uri.contains('?')) {
      final parameters = UriUtil.extractParameters(uri);
      if (parameters.containsKey('protocol')) {
        hysteriaProtocol = parameters['protocol']!;
      }
      obfs = parameters['obfsParam'];
      alpn = parameters['alpn'];
      if (parameters.containsKey('authType')) {
        authType = parameters['authType']!;
      }
      if (parameters.containsKey('auth')) {
        authPayload = parameters['auth']!;
      }
      serverName = parameters['peer'];
      if (parameters.containsKey('insecure')) {
        allowInsecure = parameters['insecure'] == '1';
      }
      if (parameters.containsKey('upmbps')) {
        upMbps = int.parse(parameters['upmbps']!);
      }
      if (parameters.containsKey('downmbps')) {
        downMbps = int.parse(parameters['downmbps']!);
      }
      uri = uri.split('?')[0];
    }

    final regex = RegExp(r'^hysteria://(?<address>[^:]+):(?<port>\d+)');

    final match = regex.firstMatch(uri);

    if (match == null) {
      throw const FormatException('Failed to parse hysteria URI');
    }

    address = match.namedGroup('address')!;
    port = int.parse(match.namedGroup('port')!);
    return ServerDefaults.hysteriaDefaults(
            defaultServerGroupId, defaultServerId)
        .copyWith(
      protocol: 'hysteria',
      remark: remark,
      address: address,
      port: port,
      hysteriaProtocol: Value(hysteriaProtocol),
      authType: Value(authType),
      authPayload: authPayload,
      serverName: Value(serverName),
      allowInsecure: Value(allowInsecure),
      upMbps: Value(upMbps),
      downMbps: Value(downMbps),
      alpn: Value(alpn),
      obfs: Value(obfs),
    );
  }

  static Map<String, String?> getParameters(Server server) {
    return {
      'protocol': server.hysteriaProtocol,
      'auth': server.authPayload,
      'peer': server.serverName,
      'insecure': server.allowInsecure ?? false ? '1' : '0',
      'upmbps': server.upMbps.toString(),
      'downmbps': server.downMbps.toString(),
      'alpn': server.alpn,
      'obfsParam': server.obfs,
    }..removeWhere((key, value) => value == null || value.isEmpty);
  }
}
