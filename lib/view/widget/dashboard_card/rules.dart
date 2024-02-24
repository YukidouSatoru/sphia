import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sphia/app/controller.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/rule_config.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/theme.dart';
import 'package:sphia/app/tray.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/widget/dashboard_card/card.dart';

class RulesCard extends StatefulWidget {
  const RulesCard({
    super.key,
  });

  @override
  State<RulesCard> createState() => _RulesCardState();
}

class _RulesCardState extends State<RulesCard> {
  @override
  Widget build(BuildContext context) {
    final sphiaConfigProvider = Provider.of<SphiaConfigProvider>(context);
    final sphiaConfig = sphiaConfigProvider.config;
    final rulesCard = CardData(
      title: Text(S.of(context).rules),
      icon: Icons.alt_route,
      widget: Consumer<RuleConfigProvider>(
        builder: (context, ruleConfigProvider, child) {
          return ListView.builder(
            itemCount: ruleConfigProvider.ruleGroups.length,
            itemBuilder: (BuildContext context, int index) {
              final ruleGroup = ruleConfigProvider.ruleGroups[index];
              return ListTile(
                shape: SphiaTheme.listTileShape(sphiaConfig.useMaterial3),
                title: Text(
                  ruleConfigProvider.ruleGroups[index].name,
                ),
                trailing: Icon(
                  ruleGroup.id == ruleConfigProvider.config.selectedRuleGroupId
                      ? Icons.check
                      : null,
                ),
                onTap: () async {
                  if (ruleGroup.id !=
                      ruleConfigProvider.config.selectedRuleGroupId) {
                    logger.i('Switching to rule group $index');
                    SphiaTray.setMenuItemCheck(
                        'rule-${ruleConfigProvider.config.selectedRuleGroupId}',
                        false);
                    SphiaTray.setMenuItemCheck('rule-${ruleGroup.id}', true);
                    ruleConfigProvider.config.selectedRuleGroupId =
                        ruleGroup.id;
                    ruleConfigProvider.saveConfig();
                    await SphiaController.restartCores();
                  }
                },
              );
            },
          );
        },
      ),
    );

    return buildCard(rulesCard);
  }
}
