import 'package:json_annotation/json_annotation.dart';
import 'package:sphia/server/rule/sing.dart';
import 'package:sphia/server/rule/xray.dart';

part 'mixed.g.dart';

@JsonSerializable(includeIfNull: false)
class MixedRule {
  String name;
  bool enabled;
  String? inboundTag;
  String? outboundTag;
  List<String>? domain;
  List<String>? ip;
  List<String>? port;
  List<String>? processName;

  MixedRule({
    required this.name,
    required this.enabled,
    this.inboundTag,
    this.outboundTag,
    this.domain,
    this.ip,
    this.port,
    this.processName,
  });

  factory MixedRule.fromJson(Map<String, dynamic> json) {
    try {
      final mixedRule = _$MixedRuleFromJson(json);
      if (mixedRule.inboundTag == null) {
        // if inboundTag is null, set it to 'proxy'
        return mixedRule..inboundTag = 'proxy';
      }
      return mixedRule;
    } catch (e) {
      // process previous version (port is String)
      final mixedRule = MixedRule(
        name: json['name'] as String,
        enabled: json['enabled'] as bool,
        inboundTag: json['inboundTag'] as String?,
        outboundTag: json['outboundTag'] as String?,
        domain: (json['domain'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        ip: (json['ip'] as List<dynamic>?)?.map((e) => e as String).toList(),
        port: (json['port'] as String?)?.split(','),
        processName: (json['processName'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
      );
      if (mixedRule.inboundTag == null) {
        // process previous version (inboundTag is not exist)
        return mixedRule..inboundTag = 'proxy';
      }
      return mixedRule;
    }
  }

  Map<String, dynamic> toJson() => _$MixedRuleToJson(this);

  XrayRule toXrayRule() {
    return XrayRule(
      inboundTag: inboundTag,
      outboundTag: outboundTag,
      domain: domain,
      ip: ip,
      port: port?.join(','),
    );
  }

  SingBoxRule toSingBoxRule() {
    List<String> geosite = [];
    List<String> domain = [];
    List<String> geoip = [];
    List<String> ipCidr = [];
    List<int> port = [];
    List<String> portRange = [];
    if (this.domain != null) {
      for (var domainItem in this.domain!) {
        if (domainItem.startsWith('geosite:')) {
          geosite.add(domainItem.replaceFirst('geosite:', ''));
        } else {
          domain.add(domainItem);
        }
      }
    }
    if (ip != null) {
      for (var ipItem in ip!) {
        if (ipItem.startsWith('geoip:')) {
          geoip.add(ipItem.replaceFirst('geoip:', ''));
        } else {
          ipCidr.add(ipItem);
        }
      }
    }
    if (this.port != null) {
      for (var portItem in this.port!) {
        if (portItem.contains('-')) {
          portRange.add(portItem.replaceAll('-', ':'));
        } else {
          try {
            port.add(int.parse(portItem));
          } catch (e) {
            // ignore
          }
        }
      }
    }
    return SingBoxRule(
      geosite: geosite.isEmpty ? null : geosite,
      domain: domain.isEmpty ? null : domain,
      geoip: geoip.isEmpty ? null : geoip,
      ipCidr: ipCidr.isEmpty ? null : ipCidr,
      port: port.isEmpty ? null : port,
      portRange: portRange.isEmpty ? null : portRange,
      outbound: outboundTag,
      processName: processName,
    );
  }
}
