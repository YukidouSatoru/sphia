import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiver/collection.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/notifier/data/rule.dart';
import 'package:sphia/app/notifier/data/rule_group.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/card/rule_card.dart';
import 'package:sphia/view/page/agent/rule.dart';
import 'package:sphia/view/widget/widget.dart';
import 'package:sphia/view/wrapper/page.dart';

class RulePage extends ConsumerStatefulWidget {
  const RulePage({
    super.key,
  });

  @override
  ConsumerState<RulePage> createState() => _RulePageState();
}

class _RulePageState extends ConsumerState<RulePage>
    with TickerProviderStateMixin, RuleAgent {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final index = ref.read(ruleGroupIndexNotifierProvider);
    final length = ref.read(ruleGroupNotifierProvider).length;
    _updateTabController(index, length, init: true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ruleGroups = ref.watch(ruleGroupNotifierProvider);
    final index = ref.watch(ruleGroupIndexNotifierProvider);
    void ruleGroupIndexListener(int? previous, int next) async {
      if (previous != null) {
        final notifier = ref.read(ruleNotifierProvider.notifier);
        notifier.clearRules();
        final id = ruleGroups[next].id;
        final rules = await ruleDao.getOrderedRuleModelsByGroupId(id);
        notifier.setRules(rules);
      }
    }

    ref.listen(ruleGroupIndexNotifierProvider, ruleGroupIndexListener);
    ref.listen(ruleGroupNotifierProvider, ruleGroupListener);

    final appBar = AppBar(
      title: Text(
        S.of(context).rules,
      ),
      elevation: 0,
      actions: [
        SphiaWidget.popupMenuButton(
          context: context,
          items: [
            PopupMenuItem(
              value: 'AddGroup',
              child: Text(S.of(context).addGroup),
            ),
            PopupMenuItem(
              value: 'EditGroup',
              child: Text(S.of(context).editGroup),
            ),
            PopupMenuItem(
              value: 'DeleteGroup',
              child: Text(S.of(context).deleteGroup),
            ),
            PopupMenuItem(
              value: 'ReorderGroup',
              child: Text(S.of(context).reorderGroup),
            ),
            PopupMenuItem(
              value: 'ResetRules',
              child: Text(S.of(context).resetRules),
            ),
          ],
          onItemSelected: (value) async {
            switch (value) {
              case 'AddGroup':
                await addGroup(ref);
                break;
              case 'EditGroup':
                final ruleGroup = ruleGroups[index];
                await editGroup(ruleGroup: ruleGroup, ref: ref);
                break;
              case 'DeleteGroup':
                final id = ruleGroups[index].id;
                await deleteGroup(groupId: id, ref: ref);
                break;
              case 'ReorderGroup':
                await reorderGroup(ref);
                break;
              case 'ResetRules':
                await resetRules(ref);
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
        tabs: ruleGroups
            .map<Widget>((ruleGroup) => Tab(
                  text: ruleGroup.name,
                ))
            .toList(),
      ),
    );

    return DefaultTabController(
      initialIndex: index,
      length: ruleGroups.length,
      child: Scaffold(
        appBar: appBar,
        body: PageWrapper(
          child: TabBarView(
            controller: _tabController,
            children: ruleGroups.map<Widget>(
              (ruleGroup) {
                if (index == ruleGroups.indexOf(ruleGroup)) {
                  final rules = ref.watch(ruleNotifierProvider);
                  return ReorderableListView.builder(
                    buildDefaultDragHandles: false,
                    proxyDecorator: (child, index, animation) => child,
                    onReorder: (int oldIndex, int newIndex) async {
                      final oldOrder = rules.map((e) => e.id).toList();
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final rule = rules.removeAt(oldIndex);
                      rules.insert(newIndex, rule);
                      final newOrder = rules.map((e) => e.id).toList();
                      if (listsEqual(oldOrder, newOrder)) {
                        return;
                      }
                      await ruleDao.updateRulesOrder(
                        ruleGroup.id,
                        newOrder,
                      );
                      final notifier = ref.read(ruleNotifierProvider.notifier);
                      notifier.setRules(rules);
                    },
                    itemCount: rules.length,
                    itemBuilder: (context, index) {
                      final rule = rules[index];
                      return RepaintBoundary(
                        key: Key('${ruleGroup.id}-$index'),
                        child: ReorderableDragStartListener(
                          index: index,
                          child: ProviderScope(
                            overrides: [
                              currentRuleProvider.overrideWithValue(rule),
                            ],
                            child: const RuleCard(),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ).toList(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final id = ruleGroups[index].id;
            await addRule(groupId: id, ref: ref);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void ruleGroupListener(
    List<RuleGroup>? previous,
    List<RuleGroup> next,
  ) async {
    if (previous != null) {
      final preLength = previous.length;
      final nextLength = next.length;
      final action = ref.read(ruleGroupStatusProvider);
      final index = ref.read(ruleGroupIndexNotifierProvider);
      final indexNotifier = ref.read(ruleGroupIndexNotifierProvider.notifier);
      switch (action) {
        case RuleGroupAction.add:
          // added a new group
          _updateTabController(preLength, nextLength);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            indexNotifier.setIndex(preLength);
            _tabController.animateTo(preLength);
          });
          break;
        case RuleGroupAction.edit:
          break;
        case RuleGroupAction.delete:
          // deleted a group
          if (index == nextLength) {
            // if the last group is deleted
            indexNotifier.setIndex(index - 1);
            _updateTabController(index - 1, nextLength);
            _tabController.animateTo(index - 1);
          } else {
            indexNotifier.setIndex(index);
            _updateTabController(index, nextLength);
            final id = next[index].id;
            await _updateRules(id);
          }
          break;
        case RuleGroupAction.reorder:
          final id = next[index].id;
          await _updateRules(id);
          break;
        case RuleGroupAction.reset:
          _updateTabController(0, nextLength);
          final id = next[0].id;
          await _updateRules(id);
          _tabController.animateTo(0);
          break;
        default:
          break;
      }
      final actionNotifier = ref.read(ruleGroupStatusProvider.notifier);
      actionNotifier.reset();
    }
  }

  Future<void> _updateRules(int id) async {
    final rules = await ruleDao.getOrderedRuleModelsByGroupId(id);
    final notifier = ref.read(ruleNotifierProvider.notifier);
    notifier.setRules(rules);
  }

  void _updateTabController(int index, int length, {bool init = false}) {
    if (!init) {
      _tabController.removeListener(() {
        final indexNotifier = ref.read(ruleGroupIndexNotifierProvider.notifier);
        indexNotifier.setIndex(_tabController.index);
      });
      _tabController.dispose();
    }
    _tabController = TabController(
      initialIndex: index,
      length: length,
      vsync: this,
    );
    _tabController.addListener(() async {
      final indexNotifier = ref.read(ruleGroupIndexNotifierProvider.notifier);
      indexNotifier.setIndex(_tabController.index);
    });
  }
}
