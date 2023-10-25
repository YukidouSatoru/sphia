// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VersionConfig _$VersionConfigFromJson(Map<String, dynamic> json) =>
    VersionConfig(
      singBoxVersion: json['singBoxVersion'] as String?,
      xrayCoreVersion: json['xrayCoreVersion'] as String?,
      shadowsocksRustVersion: json['ssRustVersion'] as String?,
      hysteriaVersion: json['hysteriaVersion'] as String?,
      singBoxRulesVersion: json['singBoxRulesVersion'] as String?,
      v2rayRulesVersion: json['v2rayRulesVersion'] as String?,
    );

Map<String, dynamic> _$VersionConfigToJson(VersionConfig instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('singBoxVersion', instance.singBoxVersion);
  writeNotNull('xrayCoreVersion', instance.xrayCoreVersion);
  writeNotNull('ssRustVersion', instance.shadowsocksRustVersion);
  writeNotNull('hysteriaVersion', instance.hysteriaVersion);
  writeNotNull('singBoxRulesVersion', instance.singBoxRulesVersion);
  writeNotNull('v2rayRulesVersion', instance.v2rayRulesVersion);
  return val;
}
