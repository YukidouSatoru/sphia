import 'package:freezed_annotation/freezed_annotation.dart';

part 'version.freezed.dart';

part 'version.g.dart';

@freezed
class VersionConfig with _$VersionConfig {
  const factory VersionConfig({
    String? singBoxVersion,
    String? xrayCoreVersion,
    String? shadowsocksRustVersion,
    String? hysteriaVersion,
    String? singBoxRulesVersion,
    String? v2rayRulesVersion,
  }) = _VersionConfig;

  factory VersionConfig.fromJson(Map<String, dynamic> json) =>
      _$VersionConfigFromJson(json);
}

extension VersionConfigExtension on VersionConfig {
  String? getVersion(String coreName) {
    switch (coreName) {
      case 'sing-box':
        return singBoxVersion;
      case 'xray-core':
        return xrayCoreVersion;
      case 'shadowsocks-rust':
        return shadowsocksRustVersion;
      case 'hysteria':
        return hysteriaVersion;
      case 'sing-box-rules':
        return singBoxRulesVersion;
      case 'v2ray-rules-dat':
        return v2rayRulesVersion;
      default:
        return null;
    }
  }

  String generateLog() {
    var json = toJson();
    final List<String> logList = [];
    // json.removeWhere((key, value) => value == null);
    json.forEach((key, value) {
      logList.add('$key: $value');
    });
    return logList.join('\n');
  }
}
