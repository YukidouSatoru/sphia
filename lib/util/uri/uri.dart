import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/server/hysteria/server.dart';
import 'package:sphia/server/server_model.dart';
import 'package:sphia/server/shadowsocks/server.dart';
import 'package:sphia/server/trojan/server.dart';
import 'package:sphia/server/xray/server.dart';
import 'package:sphia/util/uri/hysteria.dart';
import 'package:sphia/util/uri/shadowsocks.dart';
import 'package:sphia/util/uri/trojan.dart';
import 'package:sphia/util/uri/vless.dart';
import 'package:sphia/util/uri/vmess.dart';

part 'uri.g.dart';

@riverpod
class UriUtil extends _$UriUtil {
  @override
  void build() {}

  static String? getUri(ServerModel server) {
    switch (server.protocol) {
      case 'vless':
        return VlessUtil.getUri(server as XrayServer);
      case 'vmess':
        return VMessUtil.getUri(server as XrayServer);
      case 'shadowsocks':
        return ShadowsocksUtil.getUri(server as ShadowsocksServer);
      case 'trojan':
        return TrojanUtil.getUri(server as TrojanServer);
      case 'hysteria':
        return HysteriaUtil.getUri(server as HysteriaServer);
    }
    return null;
  }

  static ServerModel? parseUri(String uri) {
    try {
      uri = uri.trim();
      String scheme = uri.split('://')[0];
      switch (scheme) {
        case 'vless':
          return VlessUtil.parseUri(uri);
        case 'vmess':
          return VMessUtil.parseUri(uri);
        case 'ss':
          return ShadowsocksUtil.parseUri(uri);
        case 'trojan':
          return TrojanUtil.parseUri(uri);
        case 'hysteria':
          return HysteriaUtil.parseUri(uri);
      }
    } on Exception catch (e) {
      logger.e('$e: $uri');
      throw Exception('$e: $uri');
    }
    return null;
  }

  static void exportUriToClipboard(String uri) async {
    logger.i('Exporting to clipboard: $uri');
    Clipboard.setData(ClipboardData(text: uri));
  }

  static Future<List<String>> importUriFromClipboard() async {
    final clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData != null && clipboardData.text != null) {
      final text = clipboardData.text!.trim();
      final uris = text.split('\n');
      return uris;
    } else {
      logger.w('Clipboard is empty');
      return [];
    }
  }

  static String extractComponent(String link, String delimiter) {
    if (link.contains(delimiter)) {
      String component = Uri.decodeComponent(link.split(delimiter).last);
      link = link.split(delimiter).first;
      return component;
    }
    return '';
  }

  static Map<String, String> extractParameters(String link) {
    if (link.contains('?')) {
      final parameters = Uri.splitQueryString(link.split('?').last);
      link = link.substring(0, link.indexOf('?'));
      return parameters;
    }
    return {};
  }

  static String encodeParameter(String key, String? value) {
    return value != null && value.isNotEmpty
        ? '$key=${Uri.encodeComponent(value)}'
        : '';
  }

  static Map<String, String> extractPluginOpts(String pluginOpts) {
    Map<String, String> opts = {};
    List<String> keyValuePairs = pluginOpts.split(';');
    for (String keyValuePair in keyValuePairs) {
      List<String> keyValue = keyValuePair.split('=');
      if (keyValue.length == 2) {
        opts[keyValue[0]] = keyValue[1];
      }
    }
    return opts;
  }

  static String decodeBase64(String base64UrlString) {
    try {
      return utf8.decode(base64Url.decode(base64UrlString));
    } on Exception catch (_) {
      try {
        final base64String = convertBase64UrlToBase64(base64UrlString);
        return utf8.decode(base64Url.decode(base64String));
      } on Exception catch (_) {
        logger.e('Failed to decode base64');
        throw Exception('Failed to decode base64');
      }
    }
  }

  static String convertBase64UrlToBase64(String base64Url) {
    String base64 = base64Url.replaceAll('-', '+').replaceAll('_', '/');
    int padLength = 4 - (base64.length % 4);
    base64 = base64.padRight(base64.length + padLength, '=');
    return base64;
  }
}
