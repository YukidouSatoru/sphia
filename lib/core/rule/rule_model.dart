import 'package:drift/drift.dart' show Value;
import 'package:sphia/app/database/dao/rule.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/core/rule/extension.dart';

class RuleModel {
  int id;
  int groupId;
  String name;
  bool enabled;
  int outboundTag;
  String? domain;
  String? ip;
  String? port;
  String? source;
  String? sourcePort;
  String? network;
  String? protocol;
  String? processName;

  RuleModel({
    required this.id,
    required this.groupId,
    required this.name,
    required this.enabled,
    required this.outboundTag,
    this.domain,
    this.ip,
    this.port,
    this.source,
    this.sourcePort,
    this.network,
    this.protocol,
    this.processName,
  });

  factory RuleModel.defaults() => RuleModel(
        id: defaultRuleId,
        groupId: defaultRuleGroupId,
        name: '',
        enabled: true,
        outboundTag: outboundProxyId,
      );

  factory RuleModel.fromRule(Rule rule) {
    return RuleModel(
      id: rule.id,
      groupId: rule.groupId,
      name: rule.name,
      enabled: rule.enabled,
      outboundTag: rule.outboundTag,
      domain: rule.domain,
      ip: rule.ip,
      port: rule.port,
      source: rule.source,
      sourcePort: rule.sourcePort,
      network: rule.network,
      protocol: rule.protocol,
      processName: rule.processName,
    );
  }

  Rule toRule() {
    return Rule(
      id: id,
      groupId: groupId,
      name: name,
      enabled: enabled,
      outboundTag: outboundTag,
      domain: domain,
      ip: ip,
      port: port,
      source: source,
      sourcePort: sourcePort,
      network: network,
      protocol: protocol,
      processName: processName,
    );
  }

  RulesCompanion toCompanion() {
    return RulesCompanion(
      groupId: Value(groupId),
      name: Value(name),
      enabled: Value(enabled),
      outboundTag: Value(outboundTag),
      domain: Value(domain),
      ip: Value(ip),
      port: Value(port),
      source: Value(source),
      sourcePort: Value(sourcePort),
      network: Value(network),
      protocol: Value(protocol),
      processName: Value(processName),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RuleModel &&
        other.id == id &&
        other.groupId == groupId &&
        other.name == name &&
        other.enabled == enabled &&
        other.outboundTag == outboundTag &&
        other.domain == domain &&
        other.ip == ip &&
        other.port == port &&
        other.source == source &&
        other.sourcePort == sourcePort &&
        other.network == network &&
        other.protocol == protocol &&
        other.processName == processName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        groupId.hashCode ^
        name.hashCode ^
        enabled.hashCode ^
        outboundTag.hashCode ^
        domain.hashCode ^
        ip.hashCode ^
        port.hashCode ^
        source.hashCode ^
        sourcePort.hashCode ^
        network.hashCode ^
        protocol.hashCode ^
        processName.hashCode;
  }
}
