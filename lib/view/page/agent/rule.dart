import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:quiver/collection.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/rule_config.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/server/xray/config.dart';
import 'package:sphia/view/dialog/rule.dart';
import 'package:sphia/view/widget/widget.dart';

class RuleAgent {
  BuildContext context;

  RuleAgent(this.context);

  Future<Rule?> addRule(int groupId) async {
    XrayRule? rule = await _showEditRuleDialog(
      '${S.of(context).add} ${S.of(context).rule}',
      XrayRule(
        name: '',
        enabled: true,
        type: 'field',
      ),
    );
    if (rule == null) {
      return null;
    }
    logger.i('Adding Rule: ${rule.name}');
    await SphiaDatabase.ruleDao
        .insertRule(groupId, const JsonEncoder().convert(rule.toJson()));
    await SphiaDatabase.ruleDao.refreshRulesOrderByGroupId(groupId);
    return Rule(
      id: await SphiaDatabase.ruleDao.getLastRuleId(),
      groupId: groupId,
      data: const JsonEncoder().convert(rule.toJson()),
    );
  }

  Future<Rule?> editRule(Rule rule) async {
    final xrayRule = XrayRule.fromJson(jsonDecode(rule.data));
    XrayRule? newXrayRule = await _showEditRuleDialog(
        '${S.of(context).edit} ${S.of(context).rule}', xrayRule);
    if (newXrayRule == null || newXrayRule == xrayRule) {
      return null;
    }
    logger.i('Editing Rule: ${rule.id}');
    await SphiaDatabase.ruleDao
        .updateRule(rule.id, const JsonEncoder().convert(newXrayRule.toJson()));
    return Rule(
      id: rule.id,
      groupId: rule.groupId,
      data: const JsonEncoder().convert(newXrayRule.toJson()),
    );
  }

  Future<bool> deleteRule(int ruleId) async {
    final rule = await SphiaDatabase.ruleDao.getRuleById(ruleId);
    if (rule == null) {
      return false;
    }
    logger.i('Deleting Rule: ${rule.id}');
    await SphiaDatabase.ruleDao.deleteRule(rule);
    await SphiaDatabase.ruleDao.refreshRulesOrderByGroupId(rule.groupId);
    return true;
  }

  Future<bool> addGroup() async {
    String? newGroupName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final GlobalKey<FormState> formKey = GlobalKey<FormState>();
        TextEditingController groupNameController = TextEditingController();
        return AlertDialog(
          title: Text(S.of(context).addGroup),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WidgetBuild.buildTextFormField(
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
    await SphiaDatabase.ruleGroupDao.insertRuleGroup(newGroupName);
    await SphiaDatabase.ruleGroupDao.refreshRuleGroupsOrder();
    final ruleConfigProvider = GetIt.I.get<RuleConfigProvider>();
    ruleConfigProvider.ruleGroups.add(RuleGroup(
      id: await SphiaDatabase.ruleGroupDao.getLastRuleGroupId(),
      name: newGroupName,
    ));
    ruleConfigProvider.notify();
    return true;
  }

  Future<bool> editGroup(RuleGroup ruleGroup) async {
    if (ruleGroup.name != 'Default') {
      String? newGroupName = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          final GlobalKey<FormState> formKey = GlobalKey<FormState>();
          TextEditingController groupNameController = TextEditingController();
          groupNameController.text = ruleGroup.name;
          return AlertDialog(
            title: Text(S.of(context).editGroup),
            content: SingleChildScrollView(
                child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WidgetBuild.buildTextFormField(
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
            )),
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
      await SphiaDatabase.ruleGroupDao
          .updateRuleGroup(ruleGroup.id, newGroupName);
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
    final groupName =
        await SphiaDatabase.ruleGroupDao.getRuleGroupNameById(groupId);
    if (groupName == null) {
      return false;
    }
    if (groupName == 'Default') {
      await _showErrorDialog(groupName);
      return false;
    }
    logger.i('Deleting Rule Group: $groupId');
    await SphiaDatabase.ruleGroupDao.deleteRuleGroup(groupId);
    await SphiaDatabase.ruleGroupDao.refreshRuleGroupsOrder();
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
    final ruleConfigProvider = GetIt.I.get<RuleConfigProvider>();
    final ruleGroups = ruleConfigProvider.ruleGroups;
    final oldOrder = ruleGroups.map((e) => e.id).toList();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).reorderGroup),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.15,
            height: ruleGroups.length * 50.0,
            child: ReorderableListView.builder(
              itemCount: ruleGroups.length,
              itemBuilder: (context, index) {
                final group = ruleGroups[index];
                return ListTile(
                  key: Key(group.name),
                  title: Text(group.name),
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
    await SphiaDatabase.ruleGroupDao.updateRuleGroupsOrder(newOrder);
    ruleConfigProvider.notify();
    return true;
  }

  Future<XrayRule?> _showEditRuleDialog(String title, XrayRule rule) async {
    return showDialog<XrayRule>(
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
