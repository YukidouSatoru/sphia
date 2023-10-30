import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quiver/collection.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/server_config.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/theme.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/server/core_base.dart';
import 'package:sphia/server/hysteria/core.dart';
import 'package:sphia/server/hysteria/server.dart';
import 'package:sphia/server/server_base.dart';
import 'package:sphia/server/shadowsocks/server.dart';
import 'package:sphia/server/sing-box/core.dart';
import 'package:sphia/server/trojan/server.dart';
import 'package:sphia/server/xray/core.dart';
import 'package:sphia/server/xray/server.dart';
import 'package:sphia/util/system.dart';
import 'package:sphia/util/uri/uri.dart';
import 'package:sphia/view/dialog/hysteria.dart';
import 'package:sphia/view/dialog/shadowsocks.dart';
import 'package:sphia/view/dialog/trojan.dart';
import 'package:sphia/view/dialog/xray.dart';
import 'package:sphia/view/widget/widget.dart';

class ServerAgent {
  BuildContext context;

  ServerAgent(this.context);

  Future<Server?> addServer(int groupId, String protocol) async {
    late final ServerBase? newServer;
    switch (protocol) {
      case 'vmess':
      case 'vless':
        newServer = await _showEditServerDialog(
          protocol == 'vmess'
              ? '${S.current.add} VMess ${S.current.server}'
              : '${S.current.add} Vless ${S.current.server}',
          XrayServer.defaults()
            ..protocol = protocol
            ..encryption = (protocol == 'vmess' ? 'auto' : 'none'),
        );
        break;
      case 'shadowsocks':
        newServer = await _showEditServerDialog(
          '${S.current.add} Shadowsocks ${S.current.server}',
          ShadowsocksServer.defaults(),
        );
        break;
      case 'trojan':
        newServer = await _showEditServerDialog(
          '${S.current.add} Trojan ${S.current.server}',
          TrojanServer.defaults(),
        );
        break;
      case 'hysteria':
        newServer = await _showEditServerDialog(
          '${S.current.add} Hysteria ${S.current.server}',
          HysteriaServer.defaults(),
        );
        break;
      case 'clipboard':
        List<String> uris = await UriUtil.importUriFromClipboard();
        if (uris.isNotEmpty) {
          List<ServerBase> newServerBase = uris
              .map((e) => UriUtil.parseUri(e))
              .whereType<ServerBase>()
              .toList();
          final serverJsons = newServerBase
              .map((e) => const JsonEncoder().convert(e.toJson()))
              .toList();
          await SphiaDatabase.serverDao.insertServers(groupId, serverJsons);
          await SphiaDatabase.serverDao.refreshServersOrderByGroupId(groupId);
          return const Server(
            id: -1,
            groupId: -1,
            data: '',
          );
        } else {
          return null;
        }
      default:
        return null;
    }
    if (newServer == null) {
      return null;
    }
    logger.i('Adding Server: ${newServer.remark}');
    final newData = const JsonEncoder().convert(newServer.toJson());
    await SphiaDatabase.serverDao.insertServer(groupId, newData);
    await SphiaDatabase.serverDao.refreshServersOrderByGroupId(groupId);
    return Server(
      id: await SphiaDatabase.serverDao.getLastServerId(),
      groupId: groupId,
      data: newData,
    );
  }

  Future<Server?> editServer(Server server) async {
    final serverBase = ServerBase.fromJson(jsonDecode(server.data));
    ServerBase? editedServer = await _getEditedServer(serverBase);
    if (editedServer == null || editedServer == serverBase) {
      return null;
    }
    editedServer
      ..uplink = serverBase.uplink
      ..downlink = serverBase.downlink;
    logger.i('Editing Server: ${server.id}');
    final newData = const JsonEncoder().convert(editedServer.toJson());
    await SphiaDatabase.serverDao.updateServer(server.id, newData);
    return Server(
      id: server.id,
      groupId: server.groupId,
      data: newData,
    );
  }

  Future<ServerBase?> _getEditedServer(ServerBase server) async {
    if (server is XrayServer) {
      switch (server.protocol) {
        case 'vmess':
        case 'vless':
          return await _showEditServerDialog(
            server.protocol == 'vmess'
                ? '${S.current.edit} VMess ${S.current.server}'
                : '${S.current.edit} Vless ${S.current.server}',
            server,
          );
      }
    } else if (server is ShadowsocksServer) {
      return await _showEditServerDialog(
        '${S.current.edit} Shadowsocks ${S.current.server}',
        server,
      );
    } else if (server is TrojanServer) {
      return await _showEditServerDialog(
        '${S.current.edit} Trojan ${S.current.server}',
        server,
      );
    } else if (server is HysteriaServer) {
      return await _showEditServerDialog(
        '${S.current.edit} Hysteria ${S.current.server}',
        server,
      );
    }
    return null;
  }

  Future<bool> deleteServer(int serverId) async {
    final server = await SphiaDatabase.serverDao.getServerById(serverId);
    if (server == null) {
      return false;
    }
    logger.i('Deleting Server: ${server.id}');
    await SphiaDatabase.serverDao.deleteServer(server);
    await SphiaDatabase.serverDao.refreshServersOrderByGroupId(server.groupId);
    return true;
  }

  // TODO: Fix the position of snackbar
  Future<void> shareServer(
      String option, int serverId, void Function(String) showSnackBar) async {
    final serverBase =
        await SphiaDatabase.serverDao.getServerBaseById(serverId);
    if (serverBase == null) {
      return;
    }
    switch (option) {
      case 'QRCode':
        String? uri = UriUtil.getUri(serverBase);
        if (uri != null) {
          _shareQRCode(uri);
        }
        break;
      case 'ExportToClipboard':
        showSnackBar(S.current.exportToClipboard);
        String? uri = UriUtil.getUri(serverBase);
        if (uri != null) {
          UriUtil.exportUriToClipboard(uri);
        }
        break;
      case 'Configuration':
        _shareConfiguration(serverBase, showSnackBar);
        break;
      default:
        return;
    }
  }

  void _shareQRCode(String uri) async {
    logger.i('Sharing QRCode: $uri');
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 300,
            height: 300,
            child: QrImageView(
              data: uri,
              version: QrVersions.auto,
              backgroundColor: Colors.white,
            ),
          ),
        );
      },
    );
  }

  void _shareConfiguration(
      ServerBase server, void Function(String) showSnackBar) async {
    final sphiaConfigProvider = GetIt.I.get<SphiaConfigProvider>();
    String exportFileName;
    if ((server is XrayServer) ||
        (server is ShadowsocksServer) ||
        (server is TrojanServer) ||
        (server is HysteriaServer)) {
      exportFileName = 'export.json';
      final protocol = server.protocol;
      logger.i('Export to File: ${p.join(tempPath, exportFileName)}');
      showSnackBar(
          '${S.of(context).exportToFile}: ${p.join(tempPath, exportFileName)}');
      late final CoreBase core;
      if ((protocol == 'vless' &&
              sphiaConfigProvider.config.vlessProvider ==
                  VlessProvider.xray.index) ||
          (protocol == 'vmess' &&
              sphiaConfigProvider.config.vmessProvider ==
                  VmessProvider.xray.index) ||
          protocol == 'shadowsocks' &&
              sphiaConfigProvider.config.shadowsocksProvider ==
                  ShadowsocksProvider.xray.index ||
          protocol == 'trojan' &&
              sphiaConfigProvider.config.trojanProvider ==
                  TrojanProvider.xray.index) {
        core = XrayCore()..configFileName = exportFileName;
      } else if ((protocol == 'vless' &&
              sphiaConfigProvider.config.vlessProvider ==
                  VlessProvider.sing.index) ||
          (protocol == 'vmess' &&
              sphiaConfigProvider.config.vmessProvider ==
                  VmessProvider.sing.index) ||
          (protocol == 'shadowsocks' &&
              sphiaConfigProvider.config.shadowsocksProvider ==
                  ShadowsocksProvider.sing.index) ||
          (protocol == 'trojan' &&
              sphiaConfigProvider.config.trojanProvider ==
                  TrojanProvider.sing.index) ||
          (protocol == 'hysteria' &&
              sphiaConfigProvider.config.hysteriaProvider ==
                  HysteriaProvider.sing.index)) {
        core = SingBoxCore()..configFileName = exportFileName;
      } else if (protocol == 'hysteria' &&
          sphiaConfigProvider.config.hysteriaProvider ==
              HysteriaProvider.hysteria.index) {
        core = HysteriaCore()..configFileName = exportFileName;
      }
      await core.configure(server);
    } else {
      showSnackBar(S.of(context).noConfigurationFileGenerated);
    }
  }

  Future<bool> addGroup() async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final groupNameController = TextEditingController();
    final subscribeController = TextEditingController();
    String subscribe = '';
    bool fetchSubscribe = false;
    String? newGroupName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Text(S.of(context).addGroup),
          content: Form(
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
                WidgetBuild.buildTextFormField(
                  subscribeController,
                  S.of(context).subscribe,
                  null,
                ),
                WidgetBuild.buildDropdownButtonFormField(
                  S.of(context).no,
                  S.of(context).fetchSubscribe,
                  [S.of(context).no, S.of(context).yes],
                  (value) {
                    if (value != null) {
                      fetchSubscribe = value == S.of(context).yes;
                    }
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
                  subscribe = subscribeController.text;
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
    logger.i('Adding Server Group: $newGroupName');
    await SphiaDatabase.serverGroupDao
        .insertServerGroup(newGroupName, subscribe);
    await SphiaDatabase.serverGroupDao.refreshServerGroupsOrder();
    final serverConfigProvider = GetIt.I.get<ServerConfigProvider>();
    final id = await SphiaDatabase.serverGroupDao.getLastServerGroupId();
    serverConfigProvider.serverGroups.add(ServerGroup(
      id: id,
      name: newGroupName,
      subscribe: subscribe,
    ));
    if (fetchSubscribe && subscribe.trim().isNotEmpty) {
      await updateGroup('CurrentGroup', id, (value) {});
    }
    serverConfigProvider.notify();
    return true;
  }

  Future<bool> editGroup(ServerGroup serverGroup) async {
    if (serverGroup.name != 'Default') {
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();
      final groupNameController = TextEditingController();
      final subscribeController = TextEditingController();
      String subscribe = serverGroup.subscribe;
      groupNameController.text = serverGroup.name;
      subscribeController.text = subscribe;
      String? newGroupName = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text(S.of(context).editGroup),
            content: Form(
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
                  WidgetBuild.buildTextFormField(
                    subscribeController,
                    S.of(context).subscribe,
                    null,
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
                    subscribe = subscribeController.text;
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
      if (newGroupName == null ||
          (newGroupName == serverGroup.name &&
              subscribe == serverGroup.subscribe)) {
        return false;
      }
      logger.i('Editing Server Group: ${serverGroup.id}');
      await SphiaDatabase.serverGroupDao
          .updateServerGroup(serverGroup.id, newGroupName, subscribe);
      final serverConfigProvider = GetIt.I.get<ServerConfigProvider>();
      serverConfigProvider.serverGroups[serverConfigProvider.serverGroups
          .indexWhere((element) => element.id == serverGroup.id)] = ServerGroup(
        id: serverGroup.id,
        name: newGroupName,
        subscribe: subscribe,
      );
      serverConfigProvider.notify();
      return true;
    }
    await _showErrorDialog(serverGroup.name);
    return false;
  }

  Future<bool> updateGroup(
      String type, int groupId, void Function(String) showSnackBar) async {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    switch (type) {
      case 'CurrentGroup':
        final serverGroup =
            await SphiaDatabase.serverGroupDao.getServerGroupById(groupId);
        if (serverGroup == null) {
          return false;
        }
        final subscribe = serverGroup.subscribe;
        if (subscribe.isEmpty) {
          showSnackBar(S.current.groupHasNoSubscribe);
          return false;
        }
        final groupName = serverGroup.name;
        logger.i('Updating Server Group: $groupName');
        showSnackBar('${S.current.updatingGroup}: $groupName');
        try {
          List<String> uris;
          uris = await UriUtil.importUriFromSubscribe(subscribe,
              userAgents[UserAgent.values[sphiaConfig.userAgent].name]!);
          final newServer = uris
              .map((e) => UriUtil.parseUri(e))
              .whereType<ServerBase>()
              .toList();
          await SphiaDatabase.serverDao.deleteServerByGroupId(groupId);
          final serverJsons = newServer
              .map((e) => const JsonEncoder().convert(e.toJson()))
              .toList();
          await SphiaDatabase.serverDao.insertServers(groupId, serverJsons);
          await SphiaDatabase.serverDao.refreshServersOrderByGroupId(groupId);
          logger.i('Updated group successfully: $groupName');
          showSnackBar('${S.current.updatedGroupSuccessfully}: $groupName');
          return true;
        } on Exception catch (e) {
          logger.e('Failed to update group: $groupName\n$e');
          showSnackBar('${S.current.updateGroupFailed}: $groupName\n$e');
          return false;
        }
      case 'AllGroups':
        logger.i('Updating All Server Groups');
        bool flag = false;
        showSnackBar(S.current.updatingAllGroups);
        final serverGroups =
            await SphiaDatabase.serverGroupDao.getOrderedServerGroups();
        for (var serverGroup in serverGroups) {
          final subscribe = serverGroup.subscribe;
          if (subscribe.isEmpty) {
            continue;
          }
          final groupName = serverGroup.name;
          try {
            List<String> uris;
            uris = await UriUtil.importUriFromSubscribe(subscribe,
                userAgents[UserAgent.values[sphiaConfig.userAgent].name]!);
            final newServer = uris
                .map((e) => UriUtil.parseUri(e))
                .whereType<ServerBase>()
                .toList();
            await SphiaDatabase.serverDao.deleteServerByGroupId(serverGroup.id);
            final serverJsons = newServer
                .map((e) => const JsonEncoder().convert(e.toJson()))
                .toList();
            await SphiaDatabase.serverDao
                .insertServers(serverGroup.id, serverJsons);
            await SphiaDatabase.serverDao
                .refreshServersOrderByGroupId(serverGroup.id);
            logger.i('Updated group successfully: $groupName');
            showSnackBar('${S.current.updatedGroupSuccessfully}: $groupName');
            flag = true;
          } on Exception catch (e) {
            logger.e('Failed to update group: $groupName\n$e');
            showSnackBar('${S.current.updateGroupFailed}: $groupName\n$e');
            continue;
          }
        }
        return flag;
      default:
        return false;
    }
  }

  Future<bool> deleteGroup(int groupId) async {
    final groupName =
        await SphiaDatabase.serverGroupDao.getServerGroupNameById(groupId);
    if (groupName == null) {
      return false;
    }
    if (groupName == 'Default') {
      await _showErrorDialog(groupName);
      return false;
    }
    logger.i('Deleting Server Group: $groupId');
    await SphiaDatabase.serverGroupDao.deleteServerGroup(groupId);
    await SphiaDatabase.serverGroupDao.refreshServerGroupsOrder();
    final serverConfigProvider = GetIt.I.get<ServerConfigProvider>();
    serverConfigProvider.serverGroups
        .removeWhere((element) => element.id == groupId);
    if (serverConfigProvider.config.selectedServerGroupId == groupId) {
      serverConfigProvider.config.selectedServerGroupId = 1;
      serverConfigProvider.saveConfig();
    }
    return true;
  }

  Future<bool> reorderGroup() async {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    final serverConfigProvider = GetIt.I.get<ServerConfigProvider>();
    final serverGroups = serverConfigProvider.serverGroups;
    final oldOrder = serverGroups.map((e) => e.id).toList();
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
              itemCount: serverGroups.length,
              itemBuilder: (context, index) {
                final group = serverGroups[index];
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
              onReorder: (int oldIndex, int newIndex) {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final group = serverGroups.removeAt(oldIndex);
                serverGroups.insert(newIndex, group);
              },
            ),
          ),
        );
      },
    );
    final newOrder = serverGroups.map((e) => e.id).toList();
    if (listsEqual(oldOrder, newOrder)) {
      return false;
    }

    logger.i('Reordered Server Groups');
    await SphiaDatabase.serverGroupDao.updateServerGroupsOrder(newOrder);
    serverConfigProvider.notify();
    return true;
  }

  Future<bool> clearTraffic(String option) async {
    final serverConfigProvider = GetIt.I.get<ServerConfigProvider>();
    if (option == 'SelectedServer') {
      final server = await SphiaDatabase.serverDao
          .getServerById(serverConfigProvider.config.selectedServerId);
      if (server == null) {
        return false;
      }
      final serverBase = ServerBase.fromJson(jsonDecode(server.data));
      serverBase.uplink = null;
      serverBase.downlink = null;
      await SphiaDatabase.serverDao.updateServer(
        server.id,
        jsonEncode(serverBase),
      );
      final newServer = Server(
        id: server.id,
        groupId: server.groupId,
        data: const JsonEncoder().convert(serverBase.toJson()),
      );
      final index = serverConfigProvider.servers
          .indexWhere((element) => element.id == server.id);
      if (index != -1) {
        serverConfigProvider.servers[index] = newServer;
      }
      return true;
    } else if (option == 'CurrentGroup') {
      for (var i = 0; i < serverConfigProvider.servers.length; i++) {
        final server = serverConfigProvider.servers[i];
        final serverBase = ServerBase.fromJson(jsonDecode(server.data));
        serverBase.uplink = null;
        serverBase.downlink = null;
        await SphiaDatabase.serverDao.updateServer(
          server.id,
          jsonEncode(serverBase),
        );
        serverConfigProvider.servers[i] = Server(
          id: server.id,
          groupId: server.groupId,
          data: const JsonEncoder().convert(serverBase.toJson()),
        );
      }
      return true;
    }
    return false;
  }

  Future<ServerBase?> _showEditServerDialog(
      String title, ServerBase server) async {
    if (server is XrayServer) {
      return showDialog<XrayServer>(
        context: context,
        builder: (context) => XrayServerDialog(title: title, server: server),
      );
    } else if (server is ShadowsocksServer) {
      return showDialog<ShadowsocksServer>(
        context: context,
        builder: (context) =>
            ShadowsocksServerDialog(title: title, server: server),
      );
    } else if (server is TrojanServer) {
      return showDialog<TrojanServer>(
        context: context,
        builder: (context) => TrojanServerDialog(title: title, server: server),
      );
    } else if (server is HysteriaServer) {
      return showDialog<HysteriaServer>(
        context: context,
        builder: (context) =>
            HysteriaServerDialog(title: title, server: server),
      );
    }
    return null;
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
