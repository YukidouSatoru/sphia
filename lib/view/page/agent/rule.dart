import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:quiver/collection.dart';
import 'package:sphia/app/database/dao/rule.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/rule_config.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/theme.dart';
import 'package:sphia/core/rule/extension.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/dialog/rule.dart';
import 'package:sphia/view/widget/widget.dart';

class RuleAgent {
  BuildContext context;

  RuleAgent(this.context);

  Future<Rule?> addRule(int groupId) async {
    Rule? rule = await _showEditRuleDialog(
      '${S.current.add} ${S.current.rule}',
      Rule(
        id: defaultRuleId,
        groupId: groupId,
        name: '',
        enabled: true,
        outboundTag: outboundProxyId,
      ),
    );
    if (rule == null) {
      return null;
    }
    logger.i('Adding Rule: ${rule.name}');
    final ruleId = await ruleDao.insertRule(rule);
    await ruleDao.refreshRulesOrder(groupId);
    return rule.copyWith(id: ruleId);
  }

  Future<Rule?> editRule(Rule rule) async {
    Rule? newRule = await _showEditRuleDialog(
        '${S.of(context).edit} ${S.of(context).rule}', rule);
    if (newRule == null || newRule == rule) {
      return null;
    }
    logger.i('Editing Rule: ${rule.id}');
    await ruleDao.updateRule(newRule);
    // await ruleDao.refreshRulesOrderByGroupId(newRule.groupId);
    return newRule;
  }

  Future<bool> deleteRule(int ruleId) async {
    final rule = await ruleDao.getRuleById(ruleId);
    if (rule == null) {
      return false;
    }
    logger.i('Deleting Rule: ${rule.id}');
    await ruleDao.deleteRule(ruleId);
    await ruleDao.refreshRulesOrder(rule.groupId);
    return true;
  }

  Future<bool> addGroup() async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final groupNameController = TextEditingController();
    String? newGroupName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).addGroup),
          scrollable: true,
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SphiaWidget.textInput(
                  groupNameController,
                  S.of(context).groupName,
                  (value) {
                    if (value == null || value.trim().isEmpty) {
                      return S.current.groupNameEnterMsg;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(S.of(context).add),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop(
                    groupNameController.text,
                  );
                }
              },
            ),
          ],
        );
      },
    );
    if (newGroupName == null) {
      return false;
    }
    logger.i('Adding Rule Group: $newGroupName');
    final groupId = await ruleGroupDao.insertRuleGroup(newGroupName);
    await ruleGroupDao.refreshRuleGroupsOrder();
    final ruleConfigProvider = GetIt.I.get<RuleConfigProvider>();
    ruleConfigProvider.ruleGroups.add(RuleGroup(
      id: groupId,
      name: newGroupName,
    ));
    ruleConfigProvider.notify();
    return true;
  }

  Future<bool> editGroup(RuleGroup ruleGroup) async {
    if (ruleGroup.name != 'Default') {
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();
      final groupNameController = TextEditingController();
      groupNameController.text = ruleGroup.name;
      String? newGroupName = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(S.of(context).editGroup),
            scrollable: true,
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SphiaWidget.textInput(
                    groupNameController,
                    S.of(context).groupName,
                    (value) {
                      if (value == null || value.trim().isEmpty) {
                        return S.of(context).groupNameEnterMsg;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(S.of(context).cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(S.of(context).save),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.of(context).pop(
                      groupNameController.text,
                    );
                  }
                },
              ),
            ],
          );
        },
      );
      if (newGroupName == null || newGroupName == ruleGroup.name) {
        return false;
      }
      logger.i('Editing Rule Group: ${ruleGroup.id}');
      await ruleGroupDao.updateRuleGroup(ruleGroup.id, newGroupName);
      final ruleConfigProvider = GetIt.I.get<RuleConfigProvider>();
      ruleConfigProvider.ruleGroups[ruleConfigProvider.ruleGroups
          .indexWhere((element) => element.id == ruleGroup.id)] = RuleGroup(
        id: ruleGroup.id,
        name: newGroupName,
      );
      ruleConfigProvider.notify();
      return true;
    }
    await _showErrorDialog(ruleGroup.name);
    return false;
  }

  Future<bool> deleteGroup(int groupId) async {
    final groupName = await ruleGroupDao.getRuleGroupNameById(groupId);
    if (groupName == null) {
      return false;
    }
    if (groupName == 'Default') {
      await _showErrorDialog(groupName);
      return false;
    }
    logger.i('Deleting Rule Group: $groupId');
    await ruleGroupDao.deleteRuleGroup(groupId);
    await ruleGroupDao.refreshRuleGroupsOrder();
    final ruleConfigProvider = GetIt.I.get<RuleConfigProvider>();
    ruleConfigProvider.ruleGroups
        .removeWhere((element) => element.id == groupId);
    if (ruleConfigProvider.config.selectedRuleGroupId == groupId) {
      ruleConfigProvider.config.selectedRuleGroupId = 1;
      ruleConfigProvider.saveConfig();
    }
    return true;
  }

  Future<bool> reorderGroup() async {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    final ruleConfigProvider = GetIt.I.get<RuleConfigProvider>();
    final ruleGroups = ruleConfigProvider.ruleGroups;
    final oldOrder = ruleGroups.map((e) => e.id).toList();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).reorderGroup),
          content: SizedBox(
            width: double.minPositive,
            child: ReorderableListView.builder(
              buildDefaultDragHandles: false,
              proxyDecorator: (child, index, animation) => child,
              shrinkWrap: true,
              itemCount: ruleGroups.length,
              itemBuilder: (context, index) {
                final group = ruleGroups[index];
                return RepaintBoundary(
                  key: ValueKey(group.name),
                  child: ReorderableDragStartListener(
                    index: index,
                    child: Card(
                      color: Colors.transparent,
                      shadowColor: Colors.transparent,
                      child: ListTile(
                        shape:
                            SphiaTheme.listTileShape(sphiaConfig.useMaterial3),
                        title: Text(group.name),
                      ),
                    ),
                  ),
                );
              },
              onReorder: (int oldIndex, int newIndex) async {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final group = ruleGroups.removeAt(oldIndex);
                ruleGroups.insert(newIndex, group);
              },
            ),
          ),
        );
      },
    );
    final newOrder = ruleGroups.map((e) => e.id).toList();
    if (listsEqual(oldOrder, newOrder)) {
      return false;
    }
    logger.i('Reordered Rule Group');
    await ruleGroupDao.updateRuleGroupsOrder(newOrder);
    ruleConfigProvider.notify();
    return true;
  }

  Future<Rule?> _showEditRuleDialog(String title, Rule rule) async {
    return showDialog<Rule>(
      context: context,
      builder: (context) => RuleDialog(title: title, rule: rule),
    );
  }

  Future<void> _showErrorDialog(String groupName) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.current.warning),
          content: Text('${S.current.cannotEditOrDeleteGroup}: $groupName'),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).ok),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
