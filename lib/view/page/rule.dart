import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiver/collection.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/provider/rule_config.dart';
import 'package:sphia/app/tray.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/server/xray/config.dart';
import 'package:sphia/view/page/agent/rule.dart';
import 'package:sphia/view/widget/widget.dart';

class RulePage extends StatefulWidget {
  const RulePage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RulePageState();
}

class _RulePageState extends State<RulePage> with TickerProviderStateMixin {
  late int _index;
  late final RuleAgent _agent;
  List<Rule> _rules = [];
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    final ruleConfigProvider =
        Provider.of<RuleConfigProvider>(context, listen: false);
    _index = ruleConfigProvider.ruleGroups.indexWhere((element) =>
        element.id == ruleConfigProvider.config.selectedRuleGroupId);
    _updateTabController();
    _loadRules().then((_) => setState(() {}));
    _agent = RuleAgent(context);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _loadRules() async {
    final ruleConfigProvider =
        Provider.of<RuleConfigProvider>(context, listen: false);
    _rules = await SphiaDatabase.ruleDao
        .getOrderedRulesByGroupId(ruleConfigProvider.ruleGroups[_index].id);
  }

  void _updateTabController() {
    _tabController?.removeListener(() {});
    _tabController?.dispose();
    final ruleConfigProvider =
        Provider.of<RuleConfigProvider>(context, listen: false);
    if (_index == ruleConfigProvider.ruleGroups.length) {
      _index -= 1;
      ruleConfigProvider.config.selectedRuleGroupId =
          ruleConfigProvider.ruleGroups[_index].id;
    } else if (_index > ruleConfigProvider.ruleGroups.length) {
      _index = 0;
      ruleConfigProvider.config.selectedRuleGroupId =
          ruleConfigProvider.ruleGroups[_index].id;
    } else if (_index < 0) {
      _index = 0;
      ruleConfigProvider.config.selectedRuleGroupId =
          ruleConfigProvider.ruleGroups[_index].id;
    }
    ruleConfigProvider.saveConfigWithoutNotify();
    _tabController = TabController(
      initialIndex: _index,
      length: ruleConfigProvider.ruleGroups.length,
      vsync: this,
    );
    _tabController!.addListener(() async {
      switchTab() async {
        _index = _tabController!.index;
        await _loadRules();
        setState(() {});
      }

      if (_tabController!.indexIsChanging) {
        await switchTab();
        return;
      } else if (_tabController!.index != _index) {
        await switchTab();
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ruleConfigProvider = Provider.of<RuleConfigProvider>(context);
    final appBar = AppBar(
      title: Text(
        S.of(context).rules,
      ),
      elevation: 0,
      actions: [
        WidgetBuild.buildPopupMenuButton(
          context: context,
          items: [
            WidgetBuild.buildPopupMenuItem(
              value: 'AddGroup',
              child: Text(S.of(context).addGroup),
            ),
            WidgetBuild.buildPopupMenuItem(
              value: 'EditGroup',
              child: Text(S.of(context).editGroup),
            ),
            WidgetBuild.buildPopupMenuItem(
              value: 'DeleteGroup',
              child: Text(S.of(context).deleteGroup),
            ),
            WidgetBuild.buildPopupMenuItem(
              value: 'ReorderGroup',
              child: Text(S.of(context).reorderGroup),
            ),
          ],
          onItemSelected: (value) async {
            switch (value) {
              case 'AddGroup':
                if (await _agent.addGroup()) {
                  _updateTabController();
                  SphiaTray.generateRuleItems();
                  SphiaTray.setMenu();
                  setState(() {});
                }
                break;
              case 'EditGroup':
                if (await _agent
                    .editGroup(ruleConfigProvider.ruleGroups[_index])) {
                  SphiaTray.generateRuleItems();
                  SphiaTray.setMenu();
                  setState(() {});
                }
                break;
              case 'DeleteGroup':
                if (await _agent
                    .deleteGroup(ruleConfigProvider.ruleGroups[_index].id)) {
                  if (_index == ruleConfigProvider.ruleGroups.length) {
                    _index -= 1;
                  } else if (_index > ruleConfigProvider.ruleGroups.length) {
                    _index = 0;
                  }
                  _updateTabController();
                  await _loadRules();
                  SphiaTray.generateRuleItems();
                  SphiaTray.setMenu();
                  setState(() {});
                }
                break;
              case 'ReorderGroup':
                if (await _agent.reorderGroup()) {
                  await _loadRules();
                  SphiaTray.generateRuleItems();
                  SphiaTray.setMenu();
                  setState(() {});
                }
                break;
              default:
                break;
            }
          },
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
        tabs: ruleConfigProvider.ruleGroups
            .map<Widget>((ruleGroup) => Tab(
                  text: ruleGroup.name,
                ))
            .toList(),
      ),
    );
    return DefaultTabController(
      initialIndex: _index,
      length: ruleConfigProvider.ruleGroups.length,
      child: Scaffold(
        appBar: appBar,
        body: TabBarView(
          controller: _tabController,
          children: ruleConfigProvider.ruleGroups.map<Widget>(
            (ruleGroup) {
              if (_index == ruleConfigProvider.ruleGroups.indexOf(ruleGroup)) {
                return ReorderableListView.builder(
                  proxyDecorator: (child, index, animation) => child,
                  onReorder: (int oldIndex, int newIndex) async {
                    final oldOrder = _rules.map((e) => e.id).toList();
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final rule = _rules.removeAt(oldIndex);
                      _rules.insert(newIndex, rule);
                    });
                    final newOrder = _rules.map((e) => e.id).toList();
                    if (listsEqual(oldOrder, newOrder)) {
                      return;
                    }
                    await SphiaDatabase.ruleDao.updateRulesOrderByGroupId(
                      ruleGroup.id,
                      newOrder,
                    );
                  },
                  itemCount: _rules.length,
                  itemBuilder: (context, index) {
                    final rule = _rules[index];
                    final xrayRule = XrayRule.fromJson(
                      jsonDecode(rule.data),
                    );
                    return Column(
                      key: Key('${ruleGroup.id}-$index'),
                      children: [
                        Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          child: ListTile(
                            title: Text(xrayRule.name ?? 'Rule'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Type: ${xrayRule.type}'),
                                Text('Outbound Tag: ${xrayRule.outboundTag}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Switch(
                                  value: xrayRule.enabled,
                                  onChanged: (bool value) async {
                                    _rules[index] = rule.copyWith(
                                      data: jsonEncode(
                                        xrayRule..enabled = value,
                                      ),
                                    );
                                    await SphiaDatabase.ruleDao.updateRule(
                                      rule.id,
                                      jsonEncode(xrayRule..enabled = value),
                                    );
                                    setState(() {});
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () async {
                                    late final Rule? newRule;
                                    if ((newRule =
                                            await _agent.editRule(rule)) !=
                                        null) {
                                      _rules[index] = newRule!;
                                      setState(() {});
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    if (await _agent.deleteRule(rule.id)) {
                                      _rules.removeAt(index);
                                      setState(() {});
                                    }
                                  },
                                ),
                                const SizedBox(width: 16),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            late final Rule? newRule;
            if ((newRule = await _agent
                    .addRule(ruleConfigProvider.ruleGroups[_index].id)) !=
                null) {
              _rules.add(newRule!);
              setState(() {});
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
