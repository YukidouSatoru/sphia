import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/notifier/config/sphia_config.dart';
import 'package:sphia/app/notifier/data/rule.dart';
import 'package:sphia/app/theme.dart';
import 'package:sphia/core/rule/rule_model.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/dialog/rule.dart';
import 'package:sphia/view/page/agent/rule.dart';
import 'package:sphia/view/widget/widget.dart';

part 'rule_card.g.dart';

@riverpod
RuleModel currentRule(Ref ref) => throw UnimplementedError();

class RuleCard extends ConsumerWidget with RuleAgent {
  const RuleCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useMaterial3 = ref.watch(
        sphiaConfigNotifierProvider.select((value) => value.useMaterial3));
    final rule = ref.watch(currentRuleProvider);
    return Column(
      children: [
        Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            shape: SphiaTheme.listTileShape(useMaterial3),
            title: Text(rule.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: OutboundTagHelper.determineOutboundTagDisplay(
                      rule.outboundTag),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final outboundTagDisplay = snapshot.data as String;
                      return Text('Outbound Tag: $outboundTagDisplay');
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                if (rule.domain != null)
                  Text(
                    'Domain: ${rule.domain}',
                  ),
                if (rule.ip != null)
                  Text(
                    'IP: ${rule.ip}',
                  ),
                if (rule.port != null)
                  Text(
                    'Port: ${rule.port}',
                  ),
                if (rule.source != null)
                  Text(
                    'Source: ${rule.source}',
                  ),
                if (rule.sourcePort != null)
                  Text(
                    'Source Port: ${rule.sourcePort}',
                  ),
                if (rule.network != null)
                  Text(
                    'Network: ${rule.network}',
                  ),
                if (rule.protocol != null)
                  Text(
                    'Protocol: ${rule.protocol}',
                  ),
                if (rule.processName != null)
                  Text(
                    'Process Name: ${rule.processName}',
                  ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: rule.enabled,
                  onChanged: (bool value) async {
                    final notifier = ref.read(ruleNotifierProvider.notifier);
                    await ruleDao.updateEnabled(rule.id, value);
                    notifier.updateRuleEnabled(rule.id, value);
                  },
                ),
                SphiaWidget.iconButton(
                  icon: Icons.edit,
                  onTap: () async {
                    late final RuleModel? newRule;
                    if ((newRule = await _editRule(rule: rule, ref: ref)) !=
                        null) {
                      final notifier = ref.read(ruleNotifierProvider.notifier);
                      notifier.updateRule(newRule!);
                    }
                  },
                ),
                SphiaWidget.iconButton(
                  icon: Icons.delete,
                  onTap: () async {
                    logger.i('Deleting Rule: ${rule.id}');
                    await ruleDao.deleteRule(rule.id);
                    await ruleDao.refreshRulesOrder(rule.groupId);
                    final notifier = ref.read(ruleNotifierProvider.notifier);
                    notifier.removeRule(rule.id);
                  },
                ),
              ],
            ),
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Future<RuleModel?> _editRule({
    required RuleModel rule,
    required WidgetRef ref,
  }) async {
    final context = ref.context;
    final RuleModel? editedRule = await showEditRuleDialog(
      title: '${S.of(context).edit} ${S.of(context).rule}',
      rule: rule,
      context: context,
    );
    if (editedRule == null || editedRule == rule) {
      return null;
    }
    logger.i('Editing Rule: ${rule.id}');
    await ruleDao.updateRule(editedRule);
    // await ruleDao.refreshRulesOrderByGroupId(editedRule.groupId);
    return editedRule;
  }
}
