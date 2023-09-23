import 'package:json_annotation/json_annotation.dart';

part 'rule.g.dart';

@JsonSerializable(includeIfNull: false)
class RuleConfig {
  int selectedRuleGroupId;

  RuleConfig({
    required this.selectedRuleGroupId,
  });

  factory RuleConfig.defaults() {
    return RuleConfig(
      selectedRuleGroupId: 1,
    );
  }

  factory RuleConfig.fromJson(Map<String, dynamic> json) =>
      _$RuleConfigFromJson(json);

  Map<String, dynamic> toJson() => _$RuleConfigToJson(this);
}
