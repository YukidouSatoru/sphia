import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/config/rule.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/provider/config.dart';

part 'rule_config.g.dart';

@Riverpod(keepAlive: true)
class RuleConfigNotifier extends _$RuleConfigNotifier {
  @override
  RuleConfig build() {
    final config = ref.read(ruleConfigProvider);
    return config;
  }

  void updateSelectedRuleGroupId(int selectedRuleGroupId) {
    state = state.copyWith(selectedRuleGroupId: selectedRuleGroupId);
    ruleConfigDao.saveConfig(state);
  }
}
