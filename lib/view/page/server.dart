import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiver/collection.dart';
import 'package:sphia/app/controller.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/core.dart';
import 'package:sphia/app/provider/server_config.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/task/subscription.dart';
import 'package:sphia/app/task/task.dart';
import 'package:sphia/app/theme.dart';
import 'package:sphia/app/tray.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/util/system.dart';
import 'package:sphia/view/page/agent/server.dart';
import 'package:sphia/view/page/wrapper.dart';
import 'package:sphia/view/widget/chart.dart';
import 'package:sphia/view/widget/widget.dart';
import 'package:path/path.dart' as p;

class ServerPage extends StatefulWidget {
  const ServerPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> with TickerProviderStateMixin {
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
    final serverConfig = serverConfigProvider.config;
    _index = serverConfigProvider.serverGroups.indexWhere(
        (element) => element.id == serverConfig.selectedServerGroupId);
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
      final sphiaConfig = sphiaConfigProvider.config;
      if (sphiaConfig.autoRunServer) {
        _toggleServer();
      }
      if (sphiaConfig.updateSubscriptionInterval != -1) {
        SphiaTask.addTask(SubscriptionTask.generate());
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadServers() async {
    final serverConfigProvider =
        Provider.of<ServerConfigProvider>(context, listen: false);
    serverConfigProvider.servers = await serverDao.getOrderedServersByGroupId(
        serverConfigProvider.serverGroups[_index].id);
  }

  void _updateTabController() {
    _tabController?.removeListener(() {});
    _tabController?.dispose();
    final serverConfigProvider =
        Provider.of<ServerConfigProvider>(context, listen: false);
    final serverConfig = serverConfigProvider.config;
    if (_index == serverConfigProvider.serverGroups.length) {
      _index -= 1;
      serverConfig.selectedServerGroupId =
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
        serverConfig.selectedServerGroupId =
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
    final sphiaConfig = Provider.of<SphiaConfigProvider>(context).config;
    final coreProvider = Provider.of<CoreProvider>(context);
    final serverConfigProvider = Provider.of<ServerConfigProvider>(context);
    final serverConfig = serverConfigProvider.config;
    final appBar = AppBar(
      title: Text(
        S.of(context).servers,
      ),
      elevation: 0,
      actions: [
        SphiaWidget.popupMenuButton(
          context: context,
          items: [
            SphiaWidget.popupMenuItem(
              value: 'AddServer',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).addServer),
                  const Icon(Icons.arrow_left),
                ],
              ),
            ),
            SphiaWidget.popupMenuItem(
              value: 'AddGroup',
              child: Text(S.of(context).addGroup),
            ),
            SphiaWidget.popupMenuItem(
              value: 'EditGroup',
              child: Text(S.of(context).editGroup),
            ),
            SphiaWidget.popupMenuItem(
              value: 'UpdateGroup',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).updateGroup),
                  const Icon(Icons.arrow_left),
                ],
              ),
            ),
            SphiaWidget.popupMenuItem(
              value: 'DeleteGroup',
              child: Text(S.of(context).deleteGroup),
            ),
            SphiaWidget.popupMenuItem(
              value: 'ReorderGroup',
              child: Text(S.of(context).reorderGroup),
            ),
            SphiaWidget.popupMenuItem(
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
                final position = RelativeRect.fromLTRB(
                  MediaQuery.of(context).size.width,
                  0,
                  0,
                  0,
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
                    final Server? newServer = await _agent.addServer(
                        serverConfigProvider.serverGroups[_index].id, value);
                    if (newServer != null) {
                      serverConfigProvider.servers.add(newServer);
                      SphiaTray.addServerItem(newServer);
                      setState(() {});
                    } else {
                      if (value == 'clipboard') {
                        await _loadServers();
                        SphiaTray.generateServerItems();
                        SphiaTray.setMenu();
                        setState(() {});
                      }
                    }
                  }
                });
                break;
              case 'AddGroup':
                if (await _agent.addGroup()) {
                  _index = serverConfigProvider.serverGroups.length - 1;
                  serverConfig.selectedServerGroupId =
                      serverConfigProvider.serverGroups[_index].id;
                  serverConfigProvider.saveConfigWithoutNotify();
                  _updateTabController();
                  await _loadServers();
                  SphiaTray.generateServerItems();
                  SphiaTray.setMenu();
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
                if (!context.mounted) {
                  return;
                }
                final position = RelativeRect.fromLTRB(
                  MediaQuery.of(context).size.width,
                  0,
                  0,
                  0,
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
                      value,
                      serverConfigProvider.serverGroups[_index].id,
                    )) {
                      await _loadServers();
                      SphiaTray.generateServerItems();
                      SphiaTray.setMenu();
                      setState(() {});
                    }
                  }
                });
                break;
              case 'DeleteGroup':
                if (await _agent.deleteGroup(
                    serverConfigProvider.serverGroups[_index].id)) {
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
                if (!context.mounted) {
                  return;
                }
                final position = RelativeRect.fromLTRB(
                  MediaQuery.of(context).size.width,
                  0,
                  0,
                  0,
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
        child: Scaffold(
          appBar: appBar,
          body: PageWrapper(
            child: TabBarView(
              controller: _tabController,
              children:
                  serverConfigProvider.serverGroups.map<Widget>((serverGroup) {
                if (_index ==
                    serverConfigProvider.serverGroups.indexOf(serverGroup)) {
                  return ReorderableListView.builder(
                    buildDefaultDragHandles: false,
                    proxyDecorator: (child, index, animation) => child,
                    // https://github.com/flutter/flutter/issues/63527
                    onReorder: (int oldIndex, int newIndex) async {
                      final oldOrder = serverConfigProvider.servers
                          .map((e) => e.id)
                          .toList();
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final server =
                            serverConfigProvider.servers.removeAt(oldIndex);
                        serverConfigProvider.servers.insert(newIndex, server);
                      });
                      final newOrder = serverConfigProvider.servers
                          .map((e) => e.id)
                          .toList();
                      if (listsEqual(oldOrder, newOrder)) {
                        return;
                      }
                      await serverDao.updateServersOrder(
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
                      if (_scrollToLastSelectServer) {
                        _scrollToLastSelectServer = false;
                        final targetId = serverConfig.selectedServerId;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollToServer(
                            serverConfigProvider.servers.indexWhere(
                              (element) => element.id == targetId,
                            ),
                          );
                        });
                      }
                      return RepaintBoundary(
                        key: Key('${serverGroup.id}-$index'),
                        child: ReorderableDragStartListener(
                          index: index,
                          child: _buildCard(
                            server,
                            index,
                            sphiaConfig.useMaterial3,
                            sphiaConfig.themeColor,
                            sphiaConfig.showTransport,
                            sphiaConfig.showAddress,
                            server.id == serverConfig.selectedServerId,
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

  Widget _buildCard(
    Server server,
    int index,
    bool useMaterial3,
    int themeColorInt,
    bool showTransport,
    bool showAddress,
    bool isSelected,
  ) {
    final themeColor = Color(themeColorInt);
    String serverInfo = server.protocol;
    if (showTransport) {
      if ((server.protocol == 'vmess' || server.protocol == 'vless') &&
          server.transport != null) {
        serverInfo += ' - ${server.transport}';
        if (server.tls != null && server.tls != 'none') {
          serverInfo += ' + ${server.tls}';
        }
      } else if (server.protocol == 'shadowsocks' && server.plugin != null) {
        if (server.plugin == 'obfs-local' || server.plugin == 'simple-obfs') {
          serverInfo += ' - http';
        } else if (server.plugin == 'simple-obfs-tls') {
          serverInfo += ' - tls';
        }
      } else if (server.protocol == 'trojan') {
        serverInfo += ' - tcp';
      } else if (server.protocol == 'hysteria' &&
          server.hysteriaProtocol != null) {
        serverInfo += ' - ${server.hysteriaProtocol}';
      }
    }
    return Column(
      children: [
        Card(
          key: index == 0 ? _cardKey : null,
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          color: isSelected ? themeColor : null,
          child: ListTile(
            shape: SphiaTheme.listTileShape(useMaterial3),
            title: Text(server.remark),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(serverInfo),
                if (showAddress) Text('${server.address}:${server.port}')
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (server.uplink != null && server.downlink != null)
                  Text(
                    _getServerTraffic(
                      server.uplink!.toDouble(),
                      server.downlink!.toDouble(),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    late final Server? newServer;
                    if ((newServer = await _agent.editServer(server)) != null) {
                      if (!context.mounted) {
                        return;
                      }
                      final serverConfigProvider =
                          Provider.of<ServerConfigProvider>(context,
                              listen: false);
                      serverConfigProvider.servers[index] = newServer!;
                      SphiaTray.modifyServerItemLabel(
                          server.id, newServer.remark);
                      setState(() {});
                    }
                  },
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.share),
                  onSelected: (value) async {
                    if (await _agent.shareServer(value, server.id)) {
                      if (value == 'Configuration') {
                        if (!context.mounted) {
                          return;
                        }
                        await SphiaWidget.showDialogWithMsg(
                          context,
                          '${S.of(context).exportToFile}: ${p.join(tempPath, 'export.json')}',
                        );
                      } else if (value == 'ExportToClipboard') {
                        if (!context.mounted) {
                          return;
                        }
                        await SphiaWidget.showDialogWithMsg(
                          context,
                          S.of(context).exportToClipboard,
                        );
                      }
                    } else {
                      if (value == 'Configuration') {
                        if (!context.mounted) {
                          return;
                        }
                        await SphiaWidget.showDialogWithMsg(
                          context,
                          S.of(context).noConfigurationFileGenerated,
                        );
                      }
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: 'QRCode',
                        child: Text(S.of(context).qrCode),
                      ),
                      PopupMenuItem(
                        value: 'ExportToClipboard',
                        child: Text(S.of(context).exportToClipboard),
                      ),
                      PopupMenuItem(
                        value: 'Configuration',
                        child: Text(S.of(context).configuration),
                      ),
                    ];
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    if (await _agent.deleteServer(server.id)) {
                      if (!context.mounted) {
                        return;
                      }
                      final serverConfigProvider =
                          Provider.of<ServerConfigProvider>(context,
                              listen: false);
                      serverConfigProvider.servers.removeAt(index);
                      SphiaTray.removeServerItem(server.id);
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
            onTap: () {
              setState(
                () {
                  final serverConfigProvider =
                      Provider.of<ServerConfigProvider>(context, listen: false);
                  if (server.id ==
                      serverConfigProvider.config.selectedServerId) {
                    SphiaTray.setMenuItem('server-${server.id}', false);
                    serverConfigProvider.config.selectedServerId = 0;
                    serverConfigProvider.saveConfig();
                  } else {
                    SphiaTray.setMenuItem(
                        'server-${serverConfigProvider.config.selectedServerId}',
                        false);
                    serverConfigProvider.config.selectedServerId = server.id;
                    SphiaTray.setMenuItem('server-${server.id}', true);
                    serverConfigProvider.saveConfig();
                  }
                },
              );
            },
          ),
        ),
      ],
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
    final coreProvider = Provider.of<CoreProvider>(context, listen: false);
    final server = await serverDao.getSelectedServer();
    if (server == null) {
      if (coreProvider.coreRunning) {
        await SphiaController.stopCores();
      } else {
        if (!context.mounted) {
          return;
        }
        await SphiaWidget.showDialogWithMsg(
          context,
          S.of(context).noServerSelected,
        );
        logger.w('No server selected');
        setState(() {});
      }
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      await SphiaController.toggleCores();
    } on Exception catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!context.mounted) {
        return;
      }
      await SphiaWidget.showDialogWithMsg(
        context,
        '${S.current.coreStartFailed}: $e',
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  String _getServerTraffic(double uplink, double downlink) {
    if (uplink == 0 && downlink == 0) {
      return '';
    }
    int uplinkUnitIndex = uplink > 0 ? (log(uplink) / log(1024)).floor() : 0;
    int downlinkUnitIndex =
        downlink > 0 ? (log(downlink) / log(1024)).floor() : 0;

    uplink = uplink / unitRates[uplinkUnitIndex];
    downlink = downlink / unitRates[downlinkUnitIndex];

    return '${uplink.toStringAsFixed(2)}${units[uplinkUnitIndex]}↑ ${downlink.toStringAsFixed(2)}${units[downlinkUnitIndex]}↓';
  }
}
