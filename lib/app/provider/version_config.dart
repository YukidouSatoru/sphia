import 'package:flutter/material.dart';
import 'package:sphia/app/config/version.dart';
import 'package:sphia/app/database/database.dart';

class VersionConfigProvider extends ChangeNotifier {
  VersionConfig config;

  VersionConfigProvider(this.config);

  void saveConfig() {
    versionConfigDao.saveConfig();
    notifyListeners();
  }

  String? getVersion(String coreName) {
    switch (coreName) {
      case 'sing-box':
        return config.singBoxVersion;
      case 'xray-core':
        return config.xrayCoreVersion;
      case 'shadowsocks-rust':
        return config.shadowsocksRustVersion;
      case 'hysteria':
        return config.hysteriaVersion;
      case 'sing-box-rules':
        return config.singBoxRulesVersion;
      case 'v2ray-rules-dat':
        return config.v2rayRulesVersion;
      default:
        return null;
    }
  }

  void updateVersion(String coreName, String version) {
    switch (coreName) {
      case 'sing-box':
        config.singBoxVersion = version;
        break;
      case 'xray-core':
        config.xrayCoreVersion = version;
        break;
      case 'shadowsocks-rust':
        config.shadowsocksRustVersion = version;
        break;
      case 'hysteria':
        config.hysteriaVersion = version;
        break;
      case 'sing-box-rules':
        config.singBoxRulesVersion = version;
        break;
      case 'v2ray-rules-dat':
        config.v2rayRulesVersion = version;
        break;
      default:
        break;
    }
    saveConfig();
  }

  void removeVersion(String coreName) {
    switch (coreName) {
      case 'sing-box':
        config.singBoxVersion = null;
        break;
      case 'xray-core':
        config.xrayCoreVersion = null;
        break;
      case 'shadowsocks-rust':
        config.shadowsocksRustVersion = null;
        break;
      case 'hysteria':
        config.hysteriaVersion = null;
        break;
      case 'sing-box-rules':
        config.singBoxRulesVersion = null;
        break;
      case 'v2ray-rules-dat':
        config.v2rayRulesVersion = null;
        break;
      default:
        break;
    }
    saveConfig();
  }

  String generateLog() {
    var json = config.toJson();
    final List<String> logList = [];
    // json.removeWhere((key, value) => value == null);
    json.forEach((key, value) {
      logList.add('$key: $value');
    });
    return logList.join('\n');
  }
}
