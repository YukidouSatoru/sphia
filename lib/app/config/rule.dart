import 'package:freezed_annotation/freezed_annotation.dart';

part 'rule.freezed.dart';

part 'rule.g.dart';

@freezed
class RuleConfig with _$RuleConfig {
  const factory RuleConfig({
    @Default(1) int selectedRuleGroupId,
  }) = _RuleConfig;

  factory RuleConfig.fromJson(Map<String, dynamic> json) =>
      _$RuleConfigFromJson(json);
}
