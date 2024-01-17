import 'dart:convert';
import 'dart:core';

import 'package:drift/drift.dart' show Value;
import 'package:sphia/app/database/database.dart';
import 'package:sphia/core/server/defaults.dart';
import 'package:sphia/util/uri/uri.dart';

class ShadowsocksUtil {
  static String getUri(Server server) {
    String uri =
        'ss://${base64Url.encode(utf8.encode('${server.encryption}:${server.authPayload}'))}@${server.address}:${server.port}';
    if (server.plugin != null) {
      uri += '/?plugin=${server.plugin}';
      if (server.pluginOpts != null) {
        uri += Uri.encodeComponent(';${server.pluginOpts}');
      }
    }
    final remarkComponent = server.remark.isNotEmpty
        ? '#${Uri.encodeComponent(server.remark)}'
        : '';
    return '$uri$remarkComponent';
  }

  static Server parseUri(String uri) {
    String remark = '';
    String address = '';
    int port = 0;
    String encryption = '';
    String password = '';
    String? plugin;
    String? pluginOpts;

    uri = uri.replaceAll('/?', '?');

    final parseRemark = UriUtil.extractComponent(uri, '#');
    remark = parseRemark;

    uri = uri.split('#')[0];

    if (uri.contains('?')) {
      final finder = RegExp(r'^(?<data>.+?)\?(.+)$');
      final match = finder.firstMatch(uri);
      if (match == null) {
        throw const FormatException('Failed to parse shadowsocks URI');
      }
      final plugins = UriUtil.extractComponent(uri, '?');
      if (plugins.isNotEmpty) {
        String parsePlugin = '';
        String parsePluginOpts = '';
        if (plugins.contains(';')) {
          parsePlugin =
              plugins.substring(plugins.indexOf('=') + 1, plugins.indexOf(';'));
          parsePluginOpts = plugins.substring(plugins.indexOf(';') + 1);
        } else {
          parsePlugin = plugins.substring(plugins.indexOf('=') + 1);
        }
        switch (parsePlugin) {
          case 'obfs-local':
          case 'simple-obfs':
            if (!parsePluginOpts.contains('obfs=')) {
              parsePluginOpts = 'obfs=http;obfs-host=$parsePluginOpts';
            }
            break;
          case 'simple-obfs-tls':
            if (!parsePluginOpts.contains('obfs=')) {
              parsePluginOpts = 'obfs=tls;obfs-host=$parsePluginOpts';
            }
            break;
        }
        plugin = parsePlugin;
        pluginOpts = parsePluginOpts;
      }
      uri = match.namedGroup('data')!;
    }

    if (uri.contains('@')) {
      final finder =
          RegExp(r'^ss://(?<base64>.+?)@(?<address>.+):(?<port>\d+)');
      final parser = RegExp(r'^(?<encryption>.+?):(?<password>.+)$');
      RegExpMatch? match = finder.firstMatch(uri);
      if (match == null) {
        throw const FormatException('Failed to parse shadowsocks URI');
      }
      address = match.namedGroup('address')!;
      port = int.parse(match.namedGroup('port')!);
      late final String base64;
      try {
        base64 = UriUtil.decodeBase64(match.namedGroup('base64')!);
      } on Exception catch (_) {
        rethrow;
      }
      match = parser.firstMatch(base64);
      if (match == null) {
        throw const FormatException('Failed to parse shadowsocks URI');
      }
      encryption = match.namedGroup('encryption')!;
      password = match.namedGroup('password')!;
    } else {
      final parser = RegExp(
          r'^((?<encryption>.+?):(?<password>.+)@(?<address>.+):(?<port>\d+))');
      final match = parser.firstMatch(
          utf8.decode(base64Url.decode(uri.replaceFirst('ss://', ''))));
      if (match == null) {
        throw const FormatException('Failed to parse shadowsocks URI');
      }
      address = match.namedGroup('address')!;
      port = int.parse(match.namedGroup('port')!);
      encryption = match.namedGroup('encryption')!;
      password = match.namedGroup('password')!;
    }

    const encryptions = <String>[
      'none',
      'plain',
      'aes-128-gcm',
      'aes-192-gcm',
      'aes-256-gcm',
      'chacha20-ietf-poly1305',
      'xchacha20-ietf-poly1305',
      '2022-blake3-aes-128-gcm',
      '2022-blake3-aes-256-gcm',
      '2022-blake3-chacha20-poly1305',
      'aes-128-ctr',
      'aes-192-ctr',
      'aes-256-ctr',
      'aes-128-cfb',
      'aes-192-cfb',
      'aes-256-cfb',
      'rc4-md5',
      'chacha20-ietf',
      'xchacha20',
    ];

    if (!encryptions.contains(encryption)) {
      throw FormatException(
          'Shadowsocks does not support this encryption: $encryption');
    }

    return ServerDefaults.shadowsocksDefaults(
            defaultServerGroupId, defaultServerId)
        .copyWith(
      remark: remark,
      address: address,
      port: port,
      encryption: Value(encryption),
      authPayload: password,
      plugin: Value(plugin),
      pluginOpts: Value(pluginOpts),
    );
  }
}
