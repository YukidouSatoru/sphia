import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/notifier/data/rule_group.dart';
import 'package:sphia/app/provider/data.dart';
import 'package:sphia/core/rule/rule_model.dart';
import 'package:sphia/view/page/agent/rule.dart';

part 'rule.g.dart';

@Riverpod(keepAlive: true)
class RuleNotifier extends _$RuleNotifier {
  @override
  List<RuleModel> build() {
    final rules = ref.read(rulesProvider);
    return rules;
  }

  void addRule(RuleModel rule) {
    state = [...state, rule];
  }

  void removeRule(int id) {
    state = state.where((s) => s.id != id).toList();
  }

  void updateRule(RuleModel rule) {
    state = state.map((s) {
      if (s.id == rule.id) {
        return rule;
      }
      return s;
    }).toList();
  }

  void updateRuleEnabled(int id, bool enabled) {
    state = state.map((s) {
      if (s.id == id) {
        return s.copyWith(enabled: enabled);
      }
      return s;
    }).toList();
  }

  Future<void> loadRules() async {
    final notifier = ref.read(ruleNotifierProvider.notifier);
    final index = ref.read(ruleGroupIndexNotifierProvider);
    final ruleGroup = ref.read(ruleGroupNotifierProvider)[index];
    final rules = await ruleDao.getOrderedRuleModelsByGroupId(ruleGroup.id);
    notifier.setRules(rules);
  }

  void setRules(List<RuleModel> rules) {
    state = [...rules];
  }

  void reorderRules(List<int> order) {
    state = order.map((i) => state[i]).toList();
  }

  void clearRules() {
    state = [];
  }
}
