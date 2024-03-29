import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/core.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/core/helper.dart';

class NetworkUtil {
  static Future<HttpClientResponse> getHttpResponse(String url) async {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    final coreProvider = GetIt.I.get<CoreProvider>();
    final client = HttpClient();
    // init userAgent
    final userAgent = sphiaConfig.getUserAgent();
    client.userAgent = userAgent;
    if (coreProvider.coreRunning &&
        (sphiaConfig.updateThroughProxy ||
            (url == 'https://api.ip.sb/ip' && !coreProvider.tunMode) ||
            url.contains('sphia'))) {
      client.findProxy = (uri) {
        final port = coreProvider.routing.name == 'sing-box'
            ? sphiaConfig.mixedPort
            : sphiaConfig.httpPort;
        final proxyUrl = '${sphiaConfig.listen}:${port.toString()}';
        if (sphiaConfig.authentication) {
          final user = sphiaConfig.user;
          final password = sphiaConfig.password;
          return 'PROXY $user:$password@$proxyUrl';
        }
        return 'PROXY $proxyUrl';
      };
    }
    final uri = Uri.parse(url);
    try {
      final request = await client.getUrl(uri);
      final response = await request.close();
      client.close();
      return response;
    } on Exception catch (e) {
      logger.e('Failed to get response from $url\n$e');
      throw Exception('Failed to get response from $url\n$e');
    }
  }

  static Future<Uint8List> downloadFile(String url) async {
    try {
      logger.i('Downloading from $url');
      final response = await getHttpResponse(url);
      final bytes = await consolidateHttpClientResponseBytes(response);
      logger.i('Downloaded ${bytes.length} bytes from $url');
      return bytes;
    } on Exception catch (_) {
      rethrow;
    }
  }

  static Future<String> getIp() async {
    try {
      logger.i('Getting ip');
      final response = await getHttpResponse('https://api.ip.sb/ip');
      final responseBody =
          (await response.transform(utf8.decoder).join()).trim();
      return responseBody;
    } on Exception catch (e) {
      logger.e('Failed to get ip: $e');
      return '';
    }
  }

  static Future<String> getLatestVersion(String coreName) async {
    final apiUrl =
        '${coreRepositories[coreName]!.replaceAll('https://github.com', 'https://api.github.com/repos')}/releases/latest';
    final response = await NetworkUtil.getHttpResponse(apiUrl);
    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      final version = jsonDecode(responseBody)['tag_name'];
      if (version != null) {
        if (coreName == 'sphia') {
          return version.split('v').last;
        }
        return version;
      } else {
        throw Exception('Failed to parse version');
      }
    } else {
      throw Exception('Failed to connect to Github');
    }
  }

  static Future<String> getSphiaChangeLog() async {
    const url =
        'https://api.github.com/repos/YukidouSatoru/sphia/releases/latest';
    final response = await NetworkUtil.getHttpResponse(url);
    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      final changeLog = jsonDecode(responseBody)['body'];
      if (changeLog != null) {
        return changeLog;
      } else {
        throw Exception('Failed to parse change log');
      }
    } else {
      throw Exception('Failed to connect to Github');
    }
  }
}
