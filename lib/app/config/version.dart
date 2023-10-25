import 'package:json_annotation/json_annotation.dart';

part 'version.g.dart';

@JsonSerializable(includeIfNull: false)
class VersionConfig {
  String? singBoxVersion;
  String? xrayCoreVersion;
  String? shadowsocksRustVersion;
  String? hysteriaVersion;
  String? singBoxRulesVersion;
  String? v2rayRulesVersion;

  VersionConfig({
    this.singBoxVersion,
    this.xrayCoreVersion,
    this.shadowsocksRustVersion,
    this.hysteriaVersion,
    this.singBoxRulesVersion,
    this.v2rayRulesVersion,
  });

  factory VersionConfig.empty() => VersionConfig();

  factory VersionConfig.fromJson(Map<String, dynamic> json) =>
      _$VersionConfigFromJson(json);

  Map<String, dynamic> toJson() => _$VersionConfigToJson(this);
}
