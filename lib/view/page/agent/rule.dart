import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiver/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/database/dao/rule.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/notifier/config/rule_config.dart';
import 'package:sphia/app/notifier/config/sphia_config.dart';
import 'package:sphia/app/notifier/data/rule.dart';
import 'package:sphia/app/notifier/data/rule_group.dart';
import 'package:sphia/app/theme.dart';
import 'package:sphia/core/rule/extension.dart';
import 'package:sphia/core/rule/rule_model.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/dialog/rule.dart';
import 'package:sphia/view/dialog/rule_group.dart';
import 'package:sphia/view/widget/widget.dart';

part 'rule.g.dart';

@riverpod
class RuleGroupIndexNotifier extends _$RuleGroupIndexNotifier {
  @override
  int build() {
    final ruleConfig = ref.read(ruleConfigNotifierProvider);
    final ruleGroups = ref.read(ruleGroupNotifierProvider);
    final index = ruleGroups
        .indexWhere((element) => element.id == ruleConfig.selectedRuleGroupId);
    return index == -1 ? 0 : index;
  }

  void setIndex(int index) => state = index;
}

enum RuleGroupAction {
  add,
  edit,
  delete,
  reorder,
  reset,
  none,
}

@riverpod
class RuleGroupStatus extends _$RuleGroupStatus {
  @override
  RuleGroupAction build() {
    return RuleGroupAction.none;
  }

  void set(RuleGroupAction action) {
    state = action;
  }

  void reset() {
    state = RuleGroupAction.none;
  }
}

mixin RuleAgent {
  Future<void> addRule({
    required int groupId,
    required WidgetRef ref,
  }) async {
    final context = ref.context;
    final RuleModel? rule = await showEditRuleDialog(
      title: '${S.of(context).add} ${S.of(context).rule}',
      rule: RuleModel.defaults()..groupId = groupId,
      context: context,
    );
    if (rule == null) {
      return;
    }
    logger.i('Adding Rule: ${rule.name}');
    final ruleId = await ruleDao.insertRule(rule);
    await ruleDao.refreshRulesOrder(groupId);
    final notifier = ref.read(ruleNotifierProvider.notifier);
    notifier.addRule(rule..id = ruleId);
  }

  Future<void> addGroup(WidgetRef ref) async {
    final context = ref.context;
    String? newGroupName = await _showEditRuleGroupDialog(
      title: S.of(context).addGroup,
      groupName: '',
      context: context,
    );
    if (newGroupName == null) {
      return;
    }
    logger.i('Adding Rule Group: $newGroupName');
    final groupId = await ruleGroupDao.insertRuleGroup(newGroupName);
    await ruleGroupDao.refreshRuleGroupsOrder();
    final actionNotifier = ref.read(ruleGroupStatusProvider.notifier);
    actionNotifier.set(RuleGroupAction.add);
    final notifier = ref.read(ruleGroupNotifierProvider.notifier);
    notifier.addGroup(RuleGroup(
      id: groupId,
      name: newGroupName,
    ));
    return;
  }

  Future<bool> editGroup({
    required RuleGroup ruleGroup,
    required WidgetRef ref,
  }) async {
    if (ruleGroup.name == 'Default') {
      await _showErrorDialog(groupName: ruleGroup.name, context: ref.context);
      return false;
    }
    final context = ref.context;
    String? newGroupName = await _showEditRuleGroupDialog(
      title: S.of(context).editGroup,
      groupName: ruleGroup.name,
      context: context,
    );
    if (newGroupName == null || newGroupName == ruleGroup.name) {
      return false;
    }
    logger.i('Editing Rule Group: ${ruleGroup.id}');
    await ruleGroupDao.updateRuleGroup(ruleGroup.id, newGroupName);
    final actionNotifier = ref.read(ruleGroupStatusProvider.notifier);
    actionNotifier.set(RuleGroupAction.edit);
    final notifier = ref.read(ruleGroupNotifierProvider.notifier);
    notifier.updateGroup(RuleGroup(
      id: ruleGroup.id,
      name: newGroupName,
    ));
    return true;
  }

  Future<void> deleteGroup({
    required int groupId,
    required WidgetRef ref,
  }) async {
    final context = ref.context;
    final groupName = await ruleGroupDao.getRuleGroupNameById(groupId);
    if (groupName == null) {
      return;
    }
    if (groupName == 'Default') {
      if (context.mounted) {
        await _showErrorDialog(groupName: groupName, context: context);
      }
      return;
    }
    logger.i('Deleting Rule Group: $groupId');
    await ruleGroupDao.deleteRuleGroup(groupId);
    await ruleGroupDao.refreshRuleGroupsOrder();
    final actionNotifier = ref.read(ruleGroupStatusProvider.notifier);
    actionNotifier.set(RuleGroupAction.delete);
    final notifier = ref.read(ruleGroupNotifierProvider.notifier);
    notifier.removeGroup(groupId);
    if (ref.read(ruleConfigNotifierProvider).selectedRuleGroupId == groupId) {
      final notifier = ref.read(ruleConfigNotifierProvider.notifier);
      final defaultRuleGroupId = await ruleGroupDao.getDefaultRuleGroupId();
      notifier.updateSelectedRuleGroupId(defaultRuleGroupId);
    }
    return;
  }

  Future<void> reorderGroup(WidgetRef ref) async {
    final context = ref.context;
    final useMaterial3 = ref.read(
        sphiaConfigNotifierProvider.select((value) => value.useMaterial3));
    final ruleGroups = ref.read(ruleGroupNotifierProvider);
    final oldOrder = ruleGroups.map((e) => e.id).toList();
    final shape = SphiaTheme.listTileShape(useMaterial3);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).reorderGroup),
          content: SizedBox(
            width: double.minPositive,
            child: ReorderableListView.builder(
              buildDefaultDragHandles: true,
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
                      surfaceTintColor: Colors.transparent,
                      child: ListTile(
                        shape: shape,
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
      return;
    }

    logger.i('Reordered Rule Group');
    await ruleGroupDao.updateRuleGroupsOrder(newOrder);
    final actionNotifier = ref.read(ruleGroupStatusProvider.notifier);
    actionNotifier.set(RuleGroupAction.reorder);
    final notifier = ref.read(ruleGroupNotifierProvider.notifier);
    notifier.setGroups(ruleGroups);
    return;
  }

  Future<void> resetRules(WidgetRef ref) async {
    final context = ref.context;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).resetRules),
        content: Text(S.of(context).resetRulesConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(S.of(context).no),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(S.of(context).yes),
          ),
        ],
      ),
    );
    if (confirm == null || !confirm) {
      return;
    }
    logger.i('Resetting Rules');
    final ruleGroups = ref.read(ruleGroupNotifierProvider);
    // delete all rules and groups
    for (final ruleGroup in ruleGroups) {
      final groupId = ruleGroup.id;
      await ruleGroupDao.deleteRuleGroup(groupId);
    }
    // insert default groups
    final defaultGroupId = await ruleGroupDao.insertRuleGroup('Default');
    final directGroupId = await ruleGroupDao.insertRuleGroup('Direct');
    final globalGroupId = await ruleGroupDao.insertRuleGroup('Global');
    await ruleGroupDao
        .updateRuleGroupsOrder([defaultGroupId, directGroupId, globalGroupId]);
    // insert default rules
    final rules = [
      RuleModel(
        id: defaultRuleId,
        groupId: defaultGroupId,
        name: 'Block QUIC',
        enabled: true,
        outboundTag: outboundBlockId,
        port: '443',
        network: 'udp',
      ),
      RuleModel(
        id: defaultRuleId,
        groupId: defaultGroupId,
        name: 'Block ADS',
        enabled: true,
        outboundTag: outboundBlockId,
        domain: 'geosite:category-ads-all',
      ),
      RuleModel(
        id: defaultRuleId,
        groupId: defaultGroupId,
        name: 'Bypass CN Domains',
        enabled: true,
        outboundTag: outboundDirectId,
        domain: 'geosite:cn',
      ),
      RuleModel(
        id: defaultRuleId,
        groupId: defaultGroupId,
        name: 'Bypass CN & Local IPs',
        enabled: true,
        outboundTag: outboundDirectId,
        ip: 'geoip:private,geoip:cn',
      ),
      RuleModel(
        id: defaultRuleId,
        groupId: defaultGroupId,
        name: 'Proxy',
        enabled: true,
        outboundTag: outboundProxyId,
        port: '0-65535',
      ),
      RuleModel(
        id: defaultRuleId,
        groupId: directGroupId,
        name: 'Direct',
        enabled: true,
        outboundTag: outboundDirectId,
        port: '0-65535',
      ),
      RuleModel(
        id: defaultRuleId,
        groupId: globalGroupId,
        name: 'Proxy',
        enabled: true,
        outboundTag: outboundProxyId,
        port: '0-65535',
      ),
    ];

    for (final rule in rules) {
      await ruleDao.insertRule(rule);
    }

    // refresh rules order
    await ruleDao.refreshRulesOrder(defaultGroupId);
    await ruleDao.refreshRulesOrder(directGroupId);
    await ruleDao.refreshRulesOrder(globalGroupId);

    // refresh rule groups
    final actionNotifier = ref.read(ruleGroupStatusProvider.notifier);
    actionNotifier.set(RuleGroupAction.reset);
    final ruleGroupIndexNotifier =
        ref.read(ruleGroupIndexNotifierProvider.notifier);
    ruleGroupIndexNotifier.setIndex(0);
    final ruleGroupNotifier = ref.read(ruleGroupNotifierProvider.notifier);
    ruleGroupNotifier.setGroups([
      RuleGroup(id: defaultGroupId, name: 'Default'),
      RuleGroup(id: directGroupId, name: 'Direct'),
      RuleGroup(id: globalGroupId, name: 'Global'),
    ]);
    final ruleConfigNotifier = ref.read(ruleConfigNotifierProvider.notifier);
    ruleConfigNotifier.updateSelectedRuleGroupId(defaultGroupId);
    return;
  }

  Future<RuleModel?> showEditRuleDialog({
    required String title,
    required RuleModel rule,
    required BuildContext context,
  }) async {
    return showDialog<RuleModel>(
      context: context,
      builder: (context) => RuleDialog(title: title, rule: rule),
    );
  }

  Future<String?> _showEditRuleGroupDialog({
    required String title,
    required String groupName,
    required BuildContext context,
  }) async {
    return showDialog<String>(
      context: context,
      builder: (context) => RuleGroupDialog(
        title: title,
        groupName: groupName,
      ),
    );
  }

  Future<void> _showErrorDialog({
    required String groupName,
    required BuildContext context,
  }) async {
    final title = '${S.of(context).cannotEditOrDeleteGroup}: $groupName';
    return SphiaWidget.showDialogWithMsg(context: context, message: title);
  }
}
