import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiver/collection.dart';
import 'package:sphia/app/controller.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/core.dart';
import 'package:sphia/app/provider/server_config.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/task/subscribe.dart';
import 'package:sphia/app/task/task.dart';
import 'package:sphia/app/theme.dart';
import 'package:sphia/app/tray.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/server/server_base.dart';
import 'package:sphia/view/page/agent/server.dart';
import 'package:sphia/view/widget/chart.dart';
import 'package:sphia/view/widget/widget.dart';

class ServerPage extends StatefulWidget {
  const ServerPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  late int _index;
  bool _isLoading = false;
  late final ServerAgent _agent;
  bool _scrollToLastSelectServer = true;
  final _cardKey = GlobalKey();
  final _scrollController = ScrollController();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    final serverConfigProvider =
        Provider.of<ServerConfigProvider>(context, listen: false);
    _index = serverConfigProvider.serverGroups.indexWhere((element) =>
        element.id == serverConfigProvider.config.selectedServerGroupId);
    _updateTabController();
    _loadServers().then((_) {
      SphiaTray.generateRuleItems();
      SphiaTray.generateServerItems();
      SphiaTray.initTray();
      SphiaTray.setMenu();
      setState(() {});
    });
    _agent = ServerAgent(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sphiaConfigProvider =
          Provider.of<SphiaConfigProvider>(context, listen: false);
      if (sphiaConfigProvider.config.autoRunServer) {
        _toggleServer();
      }
      if (sphiaConfigProvider.config.updateSubscribeInterval != -1) {
        SphiaTask.addTask(SubscribeTask.generate());
      }
    });
  }

  @override
  void dispose() {
    SphiaController.stopCores();
    _tabController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadServers() async {
    final serverConfigProvider =
        Provider.of<ServerConfigProvider>(context, listen: false);
    serverConfigProvider.servers = await SphiaDatabase.serverDao
        .getOrderedServersByGroupId(
            serverConfigProvider.serverGroups[_index].id);
  }

  void _updateTabController() {
    _tabController?.removeListener(() {});
    _tabController?.dispose();
    final serverConfigProvider =
        Provider.of<ServerConfigProvider>(context, listen: false);
    if (_index == serverConfigProvider.serverGroups.length) {
      _index -= 1;
      serverConfigProvider.config.selectedServerGroupId =
          serverConfigProvider.serverGroups[_index].id;
    } else if (_index > serverConfigProvider.serverGroups.length) {
      _index = 0;
      serverConfigProvider.config.selectedServerGroupId =
          serverConfigProvider.serverGroups[_index].id;
    } else if (_index == -1) {
      _index = 0;
      serverConfigProvider.config.selectedServerGroupId =
          serverConfigProvider.serverGroups[_index].id;
    }
    serverConfigProvider.saveConfigWithoutNotify();
    _tabController = TabController(
      initialIndex: _index,
      length: serverConfigProvider.serverGroups.length,
      vsync: this,
    );
    _tabController!.addListener(() async {
      switchTab() async {
        _index = _tabController!.index;
        await _loadServers();
        serverConfigProvider.config.selectedServerGroupId =
            serverConfigProvider.serverGroups[_index].id;
        serverConfigProvider.saveConfig();
        _scrollToLastSelectServer = true;
        SphiaTray.generateServerItems();
        SphiaTray.setMenu();
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
    final coreProvider = Provider.of<CoreProvider>(context);
    final serverConfigProvider = Provider.of<ServerConfigProvider>(context);
    final appBar = AppBar(
      title: Text(
        S.of(context).servers,
      ),
      elevation: 0,
      actions: [
        WidgetBuild.buildPopupMenuButton(
          context: context,
          items: [
            WidgetBuild.buildPopupMenuItem(
              value: 'AddServer',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).addServer),
                  const Icon(Icons.arrow_left),
                ],
              ),
            ),
            WidgetBuild.buildPopupMenuItem(
              value: 'AddGroup',
              child: Text(S.of(context).addGroup),
            ),
            WidgetBuild.buildPopupMenuItem(
              value: 'EditGroup',
              child: Text(S.of(context).editGroup),
            ),
            WidgetBuild.buildPopupMenuItem(
              value: 'UpdateGroup',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).updateGroup),
                  const Icon(Icons.arrow_left),
                ],
              ),
            ),
            WidgetBuild.buildPopupMenuItem(
              value: 'DeleteGroup',
              child: Text(S.of(context).deleteGroup),
            ),
            WidgetBuild.buildPopupMenuItem(
              value: 'ReorderGroup',
              child: Text(S.of(context).reorderGroup),
            ),
            WidgetBuild.buildPopupMenuItem(
              value: 'ClearTraffic',
              child: Text(S.of(context).clearTraffic),
            ),
          ],
          onItemSelected: (value) async {
            switch (value) {
              case 'AddServer':
                final RenderBox button =
                    context.findRenderObject() as RenderBox;
                final RenderBox overlay =
                    Overlay.of(context).context.findRenderObject() as RenderBox;
                final RelativeRect position = RelativeRect.fromRect(
                  Rect.fromPoints(
                    button.localToGlobal(Offset.zero, ancestor: overlay),
                    button.localToGlobal(button.size.bottomRight(Offset.zero),
                        ancestor: overlay),
                  ),
                  Offset.zero & overlay.size,
                );
                showMenu(
                  context: context,
                  position: position,
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
                    late final Server? newServer;
                    if ((newServer = await _agent.addServer(
                            serverConfigProvider.serverGroups[_index].id,
                            value)) !=
                        null) {
                      if (value == 'clipboard') {
                        await _loadServers();
                        SphiaTray.generateServerItems();
                        SphiaTray.setMenu();
                      } else {
                        serverConfigProvider.servers.add(newServer!);
                        SphiaTray.addServerItem(newServer);
                      }
                      setState(() {});
                    }
                  }
                });
                break;
              case 'AddGroup':
                if (await _agent.addGroup()) {
                  _updateTabController();
                  setState(() {});
                }
                break;
              case 'EditGroup':
                if (await _agent
                    .editGroup(serverConfigProvider.serverGroups[_index])) {
                  setState(() {});
                }
                break;
              case 'UpdateGroup':
                if (context.mounted) {
                  final RenderBox button =
                      context.findRenderObject() as RenderBox;
                  final RenderBox overlay = Overlay.of(context)
                      .context
                      .findRenderObject() as RenderBox;
                  final RelativeRect position = RelativeRect.fromRect(
                    Rect.fromPoints(
                      button.localToGlobal(Offset.zero, ancestor: overlay),
                      button.localToGlobal(button.size.bottomRight(Offset.zero),
                          ancestor: overlay),
                    ),
                    Offset.zero & overlay.size,
                  );
                  showMenu(
                    context: context,
                    position: position,
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
                    if (value != null) {
                      if (await _agent.updateGroup(
                          value, serverConfigProvider.serverGroups[_index].id,
                          (message) {
                        _scaffoldMessengerKey.currentState!
                            .showSnackBar(WidgetBuild.snackBar(message));
                      })) {
                        await _loadServers();
                        SphiaTray.generateServerItems();
                        SphiaTray.setMenu();
                        setState(() {});
                      }
                    }
                  });
                }
                break;
              case 'DeleteGroup':
                if (await _agent.deleteGroup(
                    serverConfigProvider.serverGroups[_index].id)) {
                  if (_index == serverConfigProvider.serverGroups.length) {
                    _index -= 1;
                  } else if (_index >
                      serverConfigProvider.serverGroups.length) {
                    _index = 0;
                  }
                  _updateTabController();
                  await _loadServers();
                  SphiaTray.generateServerItems();
                  SphiaTray.setMenu();
                  setState(() {});
                }
                break;
              case 'ReorderGroup':
                if (await _agent.reorderGroup()) {
                  await _loadServers();
                  SphiaTray.generateServerItems();
                  SphiaTray.setMenu();
                  setState(() {});
                }
                break;
              case 'ClearTraffic':
                if (context.mounted) {
                  final RenderBox button =
                      context.findRenderObject() as RenderBox;
                  final RenderBox overlay = Overlay.of(context)
                      .context
                      .findRenderObject() as RenderBox;
                  final RelativeRect position = RelativeRect.fromRect(
                    Rect.fromPoints(
                      button.localToGlobal(Offset.zero, ancestor: overlay),
                      button.localToGlobal(button.size.bottomRight(Offset.zero),
                          ancestor: overlay),
                    ),
                    Offset.zero & overlay.size,
                  );
                  showMenu(
                    context: context,
                    position: position,
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
                  ).then((value) async {
                    if (value != null) {
                      if (await _agent.clearTraffic(
                        value,
                      )) {
                        setState(() {});
                      }
                    }
                  });
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
        tabs: serverConfigProvider.serverGroups
            .map((group) => Tab(
                  text: group.name,
                ))
            .toList(),
      ),
    );
    return DefaultTabController(
      initialIndex: _index,
      length: serverConfigProvider.serverGroups.length,
      child: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          appBar: appBar,
          body: TabBarView(
            controller: _tabController,
            children:
                serverConfigProvider.serverGroups.map<Widget>((serverGroup) {
              if (_index ==
                  serverConfigProvider.serverGroups.indexOf(serverGroup)) {
                return ReorderableListView.builder(
                  proxyDecorator: (child, index, animation) => child,
                  // https://github.com/flutter/flutter/issues/63527
                  onReorder: (int oldIndex, int newIndex) async {
                    final oldOrder =
                        serverConfigProvider.servers.map((e) => e.id).toList();
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final server =
                          serverConfigProvider.servers.removeAt(oldIndex);
                      serverConfigProvider.servers.insert(newIndex, server);
                    });
                    final newOrder =
                        serverConfigProvider.servers.map((e) => e.id).toList();
                    if (listsEqual(oldOrder, newOrder)) {
                      return;
                    }
                    await SphiaDatabase.serverDao.updateServersOrderByGroupId(
                      serverGroup.id,
                      newOrder,
                    );
                    SphiaTray.generateServerItems();
                    SphiaTray.setMenu();
                  },
                  scrollController: _scrollController,
                  itemCount: serverConfigProvider.servers.length,
                  itemBuilder: (context, index) {
                    final server = serverConfigProvider.servers[index];
                    final serverBase = ServerBase.fromJson(
                        jsonDecode(serverConfigProvider.servers[index].data));
                    if (_scrollToLastSelectServer) {
                      _scrollToLastSelectServer = false;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToServer(serverConfigProvider.servers.indexWhere(
                            (element) =>
                                element.id ==
                                serverConfigProvider.config.selectedServerId));
                      });
                    }
                    return Consumer<SphiaConfigProvider>(
                      key: Key('${serverGroup.id}-$index'),
                      builder: (context, sphiaConfigProvider, child) {
                        return Column(
                          // key: Key('${serverGroup.id}-$index'),
                          children: [
                            Card(
                              key: index == 0 ? _cardKey : null,
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              color: server.id ==
                                      serverConfigProvider
                                          .config.selectedServerId
                                  ? SphiaTheme.getThemeColor(
                                      sphiaConfigProvider.config.themeColor)
                                  : null,
                              child: ListTile(
                                title: Text(serverBase.remark),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(serverBase.protocol),
                                    if (sphiaConfigProvider.config.showAddress)
                                      Text(
                                          '${serverBase.address}:${serverBase.port}')
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (serverBase.uplink != null &&
                                        serverBase.downlink != null)
                                      Text(
                                        _getServerTraffic(
                                          serverBase.uplink!.toDouble(),
                                          serverBase.downlink!.toDouble(),
                                        ),
                                      ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () async {
                                        late final Server? newServer;
                                        if ((newServer = await _agent
                                                .editServer(server)) !=
                                            null) {
                                          serverConfigProvider.servers[index] =
                                              newServer!;
                                          SphiaTray.replaceServerItem(
                                              newServer);
                                          SphiaTray.setMenu();
                                          setState(() {});
                                        }
                                      },
                                    ),
                                    PopupMenuButton(
                                      icon: const Icon(Icons.share),
                                      onSelected: (value) async =>
                                          await _agent.shareServer(
                                        value,
                                        server.id,
                                        (message) {
                                          _scaffoldMessengerKey.currentState!
                                              .showSnackBar(
                                            WidgetBuild.snackBar(message),
                                          );
                                        },
                                      ),
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          PopupMenuItem(
                                            value: 'QRCode',
                                            child: Text(S.of(context).qrCode),
                                          ),
                                          PopupMenuItem(
                                            value: 'ExportToClipboard',
                                            child: Text(S
                                                .of(context)
                                                .exportToClipboard),
                                          ),
                                          PopupMenuItem(
                                            value: 'Configuration',
                                            child: Text(
                                                S.of(context).configuration),
                                          ),
                                        ];
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        if (await _agent
                                            .deleteServer(server.id)) {
                                          serverConfigProvider.servers
                                              .removeAt(index);
                                          SphiaTray.removeServerItem(server.id);
                                          SphiaTray.setMenu();
                                          setState(() {});
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 16),
                                  ],
                                ),
                                onTap: () {
                                  setState(
                                    () {
                                      SphiaTray.setMenuItem(
                                          'server-${serverConfigProvider.config.selectedServerId}',
                                          false);
                                      serverConfigProvider
                                          .config.selectedServerId = server.id;
                                      SphiaTray.setMenuItem(
                                          'server-${server.id}', true);
                                      serverConfigProvider.saveConfig();
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            }).toList(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _toggleServer,
            child: _isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Icon(
                    coreProvider.coreRunning ? Icons.flash_on : Icons.flash_off,
                  ),
          ),
        ),
      ),
    );
  }

  void _scrollToServer(int index) {
    if (_cardKey.currentContext == null) {
      return;
    }
    if (index == -1) {
      return;
    }
    logger.i('Scrolling to server $index');
    final RenderBox renderBox =
        _cardKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final height = size.height;
    _scrollController.animateTo(
      height * index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _toggleServer() async {
    final serverConfigProvider =
        Provider.of<ServerConfigProvider>(context, listen: false);
    final coreProvider = Provider.of<CoreProvider>(context, listen: false);
    final server = await SphiaDatabase.serverDao
        .getServerById(serverConfigProvider.config.selectedServerId);
    if (server == null) {
      if (coreProvider.coreRunning) {
        await SphiaController.stopCores();
      } else {
        _scaffoldMessengerKey.currentState!
            .showSnackBar(WidgetBuild.snackBar(S.current.noServerSelected));
        logger.w('No server selected');
        setState(() {});
      }
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      await SphiaController.toggleCores(server);
      SphiaTray.setMenuItem('server-${server.id}', coreProvider.coreRunning);
    } on Exception catch (e) {
      setState(() {
        _isLoading = false;
      });
      _scaffoldMessengerKey.currentState!.showSnackBar(
          WidgetBuild.snackBar('${S.current.coreStartFailed}: $e'));
    }
    setState(() {
      _isLoading = false;
    });
  }

  String _getServerTraffic(double uplink, double downlink) {
    if (uplink == 0 && downlink == 0) {
      return '';
    }
    int uplinkUnitIndex = 0, downlinkUnitIndex = 0;
    while (uplink > 1024) {
      uplink /= 1024;
      uplinkUnitIndex += 1;
    }
    while (downlink > 1024) {
      downlink /= 1024;
      downlinkUnitIndex += 1;
    }
    return '${uplink.toStringAsFixed(2)}${unit[uplinkUnitIndex]}↑ ${downlink.toStringAsFixed(2)}${unit[downlinkUnitIndex]}↓';
  }
}
