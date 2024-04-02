import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiver/collection.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/notifier/config/server_config.dart';
import 'package:sphia/app/notifier/core_state.dart';
import 'package:sphia/app/notifier/data/server.dart';
import 'package:sphia/app/notifier/data/server_group.dart';
import 'package:sphia/app/notifier/proxy.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/card/server_card.dart';
import 'package:sphia/view/dialog/progress.dart';
import 'package:sphia/view/dialog/traffic.dart';
import 'package:sphia/view/page/agent/server.dart';
import 'package:sphia/view/widget/widget.dart';
import 'package:sphia/view/wrapper/page.dart';

class ServerPage extends ConsumerStatefulWidget {
  const ServerPage({
    super.key,
  });

  @override
  ConsumerState<ServerPage> createState() => _ServerPageState();
}

class _ServerPageState extends ConsumerState<ServerPage>
    with TickerProviderStateMixin, ServerAgent {
  final _scrollController = ScrollController();
  late TabController _tabController;
  final _cardKey = GlobalKey();
  bool _scrollToServerFlag = true;

  @override
  void initState() {
    super.initState();
    final index = ref.read(serverGroupIndexNotifierProvider);
    final length = ref.read(serverGroupNotifierProvider).length;
    _updateTabController(index, length, init: true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serverGroups = ref.watch(serverGroupNotifierProvider);
    final index = ref.watch(serverGroupIndexNotifierProvider);
    void serverGroupIndexListener(int? previous, int next) async {
      if (previous != null) {
        final notifier = ref.read(serverNotifierProvider.notifier);
        notifier.clearServers();
        final groupId = serverGroups[next].id;
        final servers =
            await serverDao.getOrderedServerModelsByGroupId(groupId);
        notifier.setServers(servers);
        _scrollToServerFlag = true;
        final serverConfigNotifier =
            ref.read(serverConfigNotifierProvider.notifier);
        serverConfigNotifier.updateValue('selectedServerGroupId', groupId);
      }
    }

    ref.listen(serverGroupIndexNotifierProvider, serverGroupIndexListener);
    ref.listen(serverGroupNotifierProvider, serverGroupListener);

    final appBar = AppBar(
      title: Text(
        S.of(context).servers,
      ),
      elevation: 0,
      actions: [
        Builder(
          builder: (context) => SphiaWidget.popupMenuButton(
            context: context,
            items: [
              PopupMenuItem(
                value: 'AddServer',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(S.of(context).addServer),
                    const Icon(Icons.arrow_left),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'AddGroup',
                child: Text(S.of(context).addGroup),
              ),
              PopupMenuItem(
                value: 'EditGroup',
                child: Text(S.of(context).editGroup),
              ),
              PopupMenuItem(
                value: 'UpdateGroup',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(S.of(context).updateGroup),
                    const Icon(Icons.arrow_left),
                  ],
                ),
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
                value: 'LatencyTest',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(S.of(context).latencyTest),
                    const Icon(Icons.arrow_left),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'ClearTraffic',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(S.of(context).clearTraffic),
                    const Icon(Icons.arrow_left),
                  ],
                ),
              ),
            ],
            onItemSelected: (value) async {
              switch (value) {
                case 'AddServer':
                  final renderBox = context.findRenderObject() as RenderBox;
                  final position = renderBox.localToGlobal(Offset.zero);
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      position.dx,
                      position.dy,
                      position.dx + renderBox.size.width,
                      position.dy + renderBox.size.height,
                    ),
                    items: [
                      const PopupMenuItem(
                        value: 'vmess',
                        child: Text('VMess'),
                      ),
                      const PopupMenuItem(
                        value: 'vless',
                        child: Text('Vless'),
                      ),
                      const PopupMenuItem(
                        value: 'shadowsocks',
                        child: Text('Shadowsocks'),
                      ),
                      const PopupMenuItem(
                        value: 'trojan',
                        child: Text('Trojan'),
                      ),
                      const PopupMenuItem(
                        value: 'hysteria',
                        child: Text('Hysteria'),
                      ),
                      PopupMenuItem(
                        value: 'clipboard',
                        child: Text(S.of(context).importFromClipboard),
                      ),
                    ],
                    elevation: 8.0,
                  ).then((value) async {
                    if (value != null) {
                      final id = serverGroups[index].id;
                      await addServer(groupId: id, protocol: value, ref: ref);
                    }
                  });
                  break;
                case 'AddGroup':
                  await addGroup(ref);
                  break;
                case 'EditGroup':
                  final serverGroup = serverGroups[index];
                  await editGroup(serverGroup: serverGroup, ref: ref);
                  break;
                case 'UpdateGroup':
                  final renderBox = context.findRenderObject() as RenderBox;
                  final position = renderBox.localToGlobal(Offset.zero);
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      position.dx,
                      position.dy,
                      position.dx + renderBox.size.width,
                      position.dy + renderBox.size.height,
                    ),
                    items: [
                      PopupMenuItem(
                        value: 'CurrentGroup',
                        child: Text(S.of(context).currentGroup),
                      ),
                      PopupMenuItem(
                        value: 'AllGroups',
                        child: Text(S.of(context).allGroups),
                      ),
                    ],
                    elevation: 8.0,
                  ).then((value) async {
                    if (value == null) {
                      return;
                    }
                    final id = serverGroups[index].id;
                    try {
                      await updateGroup(type: value, groupId: id, ref: ref);
                    } on Exception catch (e) {
                      if (!context.mounted) {
                        return;
                      }
                      await SphiaWidget.showDialogWithMsg(
                        context: context,
                        message: '${S.of(context).updateGroupFailed}: $e',
                      );
                    }
                  });
                  break;
                case 'DeleteGroup':
                  final id = serverGroups[index].id;
                  await deleteGroup(groupId: id, ref: ref);
                  break;
                case 'ReorderGroup':
                  await reorderGroup(ref);
                  break;
                case 'LatencyTest':
                  final typeMenu = [
                    const PopupMenuItem(
                      value: 'ICMP',
                      child: Text('ICMP'),
                    ),
                    const PopupMenuItem(
                      value: 'TCP',
                      child: Text('TCP'),
                    ),
                    const PopupMenuItem(
                      value: 'Url',
                      child: Text('Url'),
                    ),
                    PopupMenuItem(
                      value: 'ClearLatency',
                      child: Text(S.of(context).clearLatency),
                    ),
                  ];
                  final renderBox = context.findRenderObject() as RenderBox;
                  final position = renderBox.localToGlobal(Offset.zero);
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      position.dx,
                      position.dy,
                      position.dx + renderBox.size.width,
                      position.dy + renderBox.size.height,
                    ),
                    items: [
                      PopupMenuItem(
                        value: 'SelectedServer',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.of(context).selectedServer),
                            const Icon(Icons.arrow_left),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'CurrentGroup',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.of(context).currentGroup),
                            const Icon(Icons.arrow_left),
                          ],
                        ),
                      ),
                    ],
                    elevation: 8.0,
                  ).then((value) async {
                    if (value != null) {
                      final renderBox = context.findRenderObject() as RenderBox;
                      final position = renderBox.localToGlobal(Offset.zero);
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          position.dx,
                          position.dy,
                          position.dx + renderBox.size.width,
                          position.dy + renderBox.size.height,
                        ),
                        items: typeMenu,
                        elevation: 8.0,
                      ).then((type) async {
                        if (type != null) {
                          final options = <String, String>{};
                          if (type == 'ClearLatency') {
                            options['action'] = 'Clear';
                            options['option'] = value;
                          } else {
                            options['action'] = 'Test';
                            options['option'] = value;
                            options['type'] = type;
                          }
                          await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => ProgressDialog(
                              options: options,
                            ),
                          );
                          if (value == 'CurrentGroup') {
                            final id = serverGroups[index].id;
                            await _updateServers(id);
                          }
                        }
                      });
                    }
                  });
                  break;
                case 'ClearTraffic':
                  final renderBox = context.findRenderObject() as RenderBox;
                  final position = renderBox.localToGlobal(Offset.zero);
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      position.dx,
                      position.dy,
                      position.dx + renderBox.size.width,
                      position.dy + renderBox.size.height,
                    ),
                    items: [
                      PopupMenuItem(
                        value: 'SelectedServer',
                        child: Text(S.of(context).selectedServer),
                      ),
                      PopupMenuItem(
                        value: 'CurrentGroup',
                        child: Text(S.of(context).currentGroup),
                      ),
                    ],
                    elevation: 8.0,
                  ).then((type) async {
                    if (type != null) {
                      await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => TrafficDialog(
                          option: type,
                        ),
                      );
                      if (type == 'CurrentGroup') {
                        final id = serverGroups[index].id;
                        await _updateServers(id);
                      }
                    }
                  });
                  break;
                default:
                  break;
              }
            },
          ),
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
        tabs: serverGroups
            .map((group) => Tab(
                  text: group.name,
                ))
            .toList(),
      ),
    );
    return DefaultTabController(
      initialIndex: index,
      length: serverGroups.length,
      child: ScaffoldMessenger(
        child: Scaffold(
          appBar: appBar,
          body: PageWrapper(
            child: TabBarView(
              controller: _tabController,
              children: serverGroups.map<Widget>((serverGroup) {
                if (index == serverGroups.indexOf(serverGroup)) {
                  final servers = ref.watch(serverNotifierProvider);
                  return ReorderableListView.builder(
                    buildDefaultDragHandles: false,
                    proxyDecorator: (child, index, animation) => child,
                    // https://github.com/flutter/flutter/issues/63527
                    onReorder: (int oldIndex, int newIndex) async {
                      final oldOrder = servers.map((e) => e.id).toList();
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final server = servers.removeAt(oldIndex);
                      servers.insert(newIndex, server);
                      final newOrder = servers.map((e) => e.id).toList();
                      if (listsEqual(oldOrder, newOrder)) {
                        return;
                      }
                      await serverDao.updateServersOrder(
                        serverGroup.id,
                        newOrder,
                      );
                      final notifier =
                          ref.read(serverNotifierProvider.notifier);
                      notifier.setServers(servers);
                    },
                    scrollController: _scrollController,
                    itemCount: servers.length,
                    itemBuilder: (context, index) {
                      final server = servers[index];
                      if (_scrollToServerFlag) {
                        _scrollToServerFlag = false;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          final serverConfig =
                              ref.read(serverConfigNotifierProvider);
                          final targetId = serverConfig.selectedServerId;
                          final index = servers
                              .indexWhere((element) => element.id == targetId);
                          _scrollToServer(index);
                        });
                      }
                      return RepaintBoundary(
                        key: index == 0
                            ? _cardKey
                            : Key('${serverGroup.id} - $index'),
                        child: ReorderableDragStartListener(
                          index: index,
                          child: ProviderScope(
                            overrides: [
                              currentServerProvider.overrideWithValue(server),
                            ],
                            child: const ServerCard(),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }).toList(),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _toggleServer,
            child: ref.watch(coreStateNotifierProvider).when(
              data: (coreState) {
                if (coreState.cores.isEmpty) {
                  return const Icon(Icons.flash_off);
                } else {
                  return const Icon(Icons.flash_on);
                }
              },
              error: (error, _) {
                logger.e('Failed to get core state: $error');
                return const Icon(Icons.flash_off);
              },
              loading: () {
                return const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void serverGroupListener(
    List<ServerGroup>? previous,
    List<ServerGroup> next,
  ) async {
    if (previous != null) {
      final preLength = previous.length;
      final nextLength = next.length;
      final action = ref.read(serverGroupStatusProvider);
      final index = ref.read(serverGroupIndexNotifierProvider);
      final indexNotifier = ref.read(serverGroupIndexNotifierProvider.notifier);
      switch (action) {
        case ServerGroupAction.add:
          // added a new group
          _updateTabController(preLength, nextLength);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            indexNotifier.setIndex(preLength);
          });
          break;
        case ServerGroupAction.edit:
          break;
        case ServerGroupAction.delete:
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
            await _updateServers(id);
          }
          break;
        case ServerGroupAction.reorder:
          final id = next[index].id;
          await _updateServers(id);
          break;
        default:
          break;
      }
      final actionNotifier = ref.read(serverGroupStatusProvider.notifier);
      actionNotifier.reset();
    }
  }

  Future<void> _updateServers(int id) async {
    final servers = await serverDao.getOrderedServerModelsByGroupId(id);
    final notifier = ref.read(serverNotifierProvider.notifier);
    notifier.setServers(servers);
  }

  void _updateTabController(int index, int length, {bool init = false}) {
    if (!init) {
      _tabController.removeListener(() {
        final indexNotifier =
            ref.read(serverGroupIndexNotifierProvider.notifier);
        indexNotifier.setIndex(_tabController.index);
      });
      _tabController.dispose();
    }
    _tabController = TabController(
      initialIndex: index,
      length: length,
      vsync: this,
    );
    _tabController.addListener(() {
      final indexNotifier = ref.read(serverGroupIndexNotifierProvider.notifier);
      indexNotifier.setIndex(_tabController.index);
    });
  }

  void _scrollToServer(int index) {
    if (_cardKey.currentContext == null) {
      return;
    }
    // has rendered
    final renderBox = _cardKey.currentContext!.findRenderObject() as RenderBox;
    final height = renderBox.size.height;
    if (index == -1) {
      return;
    }
    logger.i('Scrolling to server $index');
    _scrollController.animateTo(
      height * index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _toggleServer() async {
    final serverConfig = ref.read(serverConfigNotifierProvider);
    final coreStateNotifier = ref.read(coreStateNotifierProvider.notifier);
    final id = serverConfig.selectedServerId;
    final server = await serverDao.getServerModelById(id);
    if (server == null) {
      final proxyState = ref.read(proxyNotifierProvider);
      if (proxyState.coreRunning) {
        await coreStateNotifier.stopCores();
      } else {
        if (!mounted) {
          return;
        }
        logger.w('No server selected');
        await SphiaWidget.showDialogWithMsg(
          context: context,
          message: S.of(context).noServerSelected,
        );
      }
      return;
    }
    try {
      await coreStateNotifier.toggleCores(server);
    } on Exception catch (e) {
      if (!mounted) {
        return;
      }
      await SphiaWidget.showDialogWithMsg(
        context: context,
        message: '${S.current.coreStartFailed}: $e',
      );
    }
  }
}
