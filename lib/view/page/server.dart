import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
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
import 'package:sphia/server/hysteria/server.dart';
import 'package:sphia/server/server_model.dart';
import 'package:sphia/server/shadowsocks/server.dart';
import 'package:sphia/server/trojan/server.dart';
import 'package:sphia/server/xray/server.dart';
import 'package:sphia/util/latency.dart';
import 'package:sphia/util/system.dart';
import 'package:sphia/view/dialog/progress.dart';
import 'package:sphia/view/dialog/traffic.dart';
import 'package:sphia/view/page/agent/server.dart';
import 'package:sphia/view/page/wrapper.dart';
import 'package:sphia/view/widget/dashboard_card/chart.dart';
import 'package:sphia/view/widget/widget.dart';

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
    serverConfigProvider.servers =
        await serverDao.getOrderedServerModelsByGroupId(
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
                      final ServerModel? newServer = await _agent.addServer(
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
                    try {
                      if (await _agent.updateGroup(
                        value,
                        serverConfigProvider.serverGroups[_index].id,
                      )) {
                        await _loadServers();
                        SphiaTray.generateServerItems();
                        SphiaTray.setMenu();
                        setState(() {});
                      }
                    } on Exception catch (e) {
                      if (!context.mounted) {
                        return;
                      }
                      await SphiaWidget.showDialogWithMsg(
                        context,
                        '${S.current.updateGroupFailed}: $e',
                      );
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
                            options['action'] = 'clear';
                            options['option'] = value;
                          } else {
                            options['action'] = 'test';
                            options['option'] = value;
                            options['type'] = type;
                          }
                          await showDialog(
                            context: context,
                            builder: (context) => ProgressDialog(
                              options: options,
                            ),
                          );
                          setState(() {});
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
                          builder: (context) => TrafficDialog(option: type));
                    }
                    setState(() {});
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
                            server: server,
                            index: index,
                            useMaterial3: sphiaConfig.useMaterial3,
                            themeColorInt: sphiaConfig.themeColor,
                            isDarkMode: sphiaConfig.darkMode,
                            showTransport: sphiaConfig.showTransport,
                            showAddress: sphiaConfig.showAddress,
                            isSelected:
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

  Widget _buildCard({
    required ServerModel server,
    required int index,
    required bool useMaterial3,
    required int themeColorInt,
    required bool isDarkMode,
    required bool showTransport,
    required bool showAddress,
    required bool isSelected,
  }) {
    final themeColor = Color(themeColorInt);
    String serverInfo = server.protocol;
    if (showTransport) {
      if (server is XrayServer) {
        serverInfo += ' - ${server.transport}';
        if (server.tls != 'none') {
          serverInfo += ' + ${server.tls}';
        }
      } else if (server is ShadowsocksServer && server.plugin != null) {
        if (server.plugin == 'obfs-local' || server.plugin == 'simple-obfs') {
          serverInfo += ' - http';
        } else if (server.plugin == 'simple-obfs-tls') {
          serverInfo += ' - tls';
        }
      } else if (server is TrojanServer) {
        serverInfo += ' - tcp';
      } else if (server is HysteriaServer) {
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (server.latency != null)
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: server.latency == latencyFailure
                                ? 'timeout'
                                : '${server.latency} ms',
                            style: TextStyle(
                                color:
                                    isDarkMode ? Colors.white : Colors.black)),
                        TextSpan(
                          text: '  ◉',
                          style: TextStyle(
                            color: _getLatencyColor(server.latency!),
                          ),
                        )
                      ])),
                    if (server.uplink != null && server.downlink != null)
                      Text(
                        _getServerTraffic(
                          server.uplink!.toDouble(),
                          server.downlink!.toDouble(),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 8),
                SphiaWidget.iconButton(
                  icon: Icons.edit,
                  onTap: () async {
                    late final ServerModel? newServer;
                    if ((newServer = await _agent.editServer(server)) != null) {
                      if (!mounted) {
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
                SphiaWidget.popupMenuIconButton(
                  icon: Icons.share,
                  items: [
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
                    )
                  ],
                  onItemSelected: (value) async {
                    if (await _agent.shareServer(value, server.id)) {
                      if (value == 'Configuration') {
                        if (!mounted) {
                          return;
                        }
                        await SphiaWidget.showDialogWithMsg(
                          context,
                          '${S.of(context).exportToFile}: ${p.join(tempPath, 'export.json')}',
                        );
                      } else if (value == 'ExportToClipboard') {
                        if (!mounted) {
                          return;
                        }
                        await SphiaWidget.showDialogWithMsg(
                          context,
                          S.of(context).exportToClipboard,
                        );
                      }
                    } else {
                      if (value == 'Configuration') {
                        if (!mounted) {
                          return;
                        }
                        await SphiaWidget.showDialogWithMsg(
                          context,
                          S.of(context).noConfigurationFileGenerated,
                        );
                      }
                    }
                  },
                ),
                SphiaWidget.iconButton(
                  icon: Icons.delete,
                  onTap: () => _deleteServer(index, server),
                )
              ],
            ),
            onTap: () {
              setState(
                () {
                  final serverConfigProvider =
                      Provider.of<ServerConfigProvider>(context, listen: false);
                  if (server.id ==
                      serverConfigProvider.config.selectedServerId) {
                    SphiaTray.setMenuItemCheck('server-${server.id}', false);
                    serverConfigProvider.config.selectedServerId = 0;
                    serverConfigProvider.saveConfig();
                  } else {
                    SphiaTray.setMenuItemCheck(
                        'server-${serverConfigProvider.config.selectedServerId}',
                        false);
                    serverConfigProvider.config.selectedServerId = server.id;
                    SphiaTray.setMenuItemCheck('server-${server.id}', true);
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
    final server = await serverDao.getSelectedServerModel();
    if (server == null) {
      if (coreProvider.coreRunning) {
        await SphiaController.stopCores();
      } else {
        if (!mounted) {
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
      if (!mounted) {
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

  Color _getLatencyColor(int latency) {
    // use A400 color
    const red = Color.fromARGB(255, 255, 61, 0);
    const yellow = Color.fromARGB(255, 255, 234, 0);
    const green = Color.fromARGB(255, 118, 255, 3);
    if (latency == latencyFailure || latency < 0) {
      return red;
    }
    if (latency <= latencyGreen) {
      return green;
    } else if (latency <= latencyYellow) {
      return yellow;
    } else {
      return red;
    }
  }

  Future<void> _deleteServer(int index, ServerModel server) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).deleteServer),
        content: Text(S.of(context).deleteServerConfirm(server.remark)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(S.of(context).delete),
          ),
        ],
      ),
    );
    if (confirm == null || !confirm) {
      return;
    }
    if (await _agent.deleteServer(server.id)) {
      if (!mounted) {
        return;
      }
      final serverConfigProvider =
          Provider.of<ServerConfigProvider>(context, listen: false);
      serverConfigProvider.servers.removeAt(index);
      SphiaTray.removeServerItem(server.id);
      setState(() {});
    }
  }
}
