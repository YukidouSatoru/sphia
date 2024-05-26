import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/notifier/data/rule_group.dart';
import 'package:sphia/app/notifier/proxy.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/card/dashboard_card/card.dart';
import 'package:sphia/view/widget/rule_group_list_tile.dart';

part 'rule_group.g.dart';

@riverpod
RuleGroup currentRuleGroup(Ref ref) => throw UnimplementedError();

class RuleGroupCard extends ConsumerWidget {
  const RuleGroupCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ruleGroups = ref.watch(ruleGroupNotifierProvider);

    Widget widget = ListView.builder(
      itemCount: ruleGroups.length,
      itemBuilder: (BuildContext context, int index) {
        final ruleGroup = ruleGroups[index];
        return ProviderScope(
          overrides: [
            currentRuleGroupProvider.overrideWithValue(ruleGroup),
          ],
          child: const RuleGroupListTile(),
        );
      },
    );

    final coreRunning =
        ref.watch(proxyNotifierProvider.select((value) => value.coreRunning));
    if (coreRunning) {
      final isCustom = ref.watch(proxyNotifierProvider).customConfig;
      if (isCustom) {
        widget = Center(
          child: IconButton(
            icon: const Icon(
              Icons.block,
              color: Colors.grey,
            ),
            tooltip: S.of(context).customConfigSwitchUnsupported,
            onPressed: null,
          ),
        );
      }
    }

    final rulesCard = CardData(
      title: Text(S.of(context).rules),
      icon: Icons.alt_route,
      widget: widget,
    );

    return buildCard(rulesCard);
  }
}
