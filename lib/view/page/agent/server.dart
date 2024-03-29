import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quiver/collection.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/server_config.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/task/subscription.dart';
import 'package:sphia/app/theme.dart';
import 'package:sphia/core/hysteria/core.dart';
import 'package:sphia/core/sing/core.dart';
import 'package:sphia/core/xray/core.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/server/hysteria/server.dart';
import 'package:sphia/server/server_model.dart';
import 'package:sphia/server/shadowsocks/server.dart';
import 'package:sphia/server/trojan/server.dart';
import 'package:sphia/server/xray/server.dart';
import 'package:sphia/util/uri/uri.dart';
import 'package:sphia/view/dialog/hysteria.dart';
import 'package:sphia/view/dialog/server_group.dart';
import 'package:sphia/view/dialog/shadowsocks.dart';
import 'package:sphia/view/dialog/trojan.dart';
import 'package:sphia/view/dialog/xray.dart';
import 'package:sphia/view/widget/widget.dart';

class ServerAgent {
  BuildContext context;

  ServerAgent(this.context);

  Future<ServerModel?> addServer(int groupId, String protocol) async {
    late final ServerModel? server;
    switch (protocol) {
      case 'vmess':
      case 'vless':
        server = await _showEditServerDialog(
          protocol == 'vmess'
              ? '${S.current.add} VMess ${S.current.server}'
              : '${S.current.add} Vless ${S.current.server}',
          protocol == 'vmess'
              ? (XrayServer.vmessDefaults()..groupId = groupId)
              : (XrayServer.vlessDefaults()..groupId = groupId),
        );
        break;
      case 'shadowsocks':
        server = await _showEditServerDialog(
          '${S.current.add} Shadowsocks ${S.current.server}',
          ShadowsocksServer.defaults()..groupId = groupId,
        );
        break;
      case 'trojan':
        server = await _showEditServerDialog(
          '${S.current.add} Trojan ${S.current.server}',
          TrojanServer.defaults()..groupId = groupId,
        );
        break;
      case 'hysteria':
        server = await _showEditServerDialog(
          '${S.current.add} Hysteria ${S.current.server}',
          HysteriaServer.defaults()..groupId = groupId,
        );
        break;
      case 'clipboard':
        List<String> uris = await UriUtil.importUriFromClipboard();
        if (uris.isNotEmpty) {
          List<ServerModel> servers = [];
          for (var uri in uris) {
            try {
              final server = UriUtil.parseUri(uri);
              if (server != null) {
                servers.add(server..groupId = groupId);
              }
            } on Exception catch (e) {
              logger.e('Failed to parse uri: $uri\n$e');
            }
          }
          await serverDao.insertServers(servers);
          await serverDao.refreshServersOrder(groupId);
        }
        return null;
      default:
        return null;
    }
    if (server == null) {
      return null;
    }
    logger.i('Adding Server: ${server.remark}');
    final serverId = await serverDao.insertServer(server);
    await serverDao.refreshServersOrder(groupId);
    return server..id = serverId;
  }

  Future<ServerModel?> editServer(ServerModel server) async {
    final ServerModel? editedServer = await _getEditedServer(server);
    if (editedServer == null || editedServer == server) {
      return null;
    }
    logger.i('Editing Server: ${server.id}');
    await serverDao.updateServer(editedServer);
    return editedServer;
  }

  Future<ServerModel?> _getEditedServer(ServerModel server) async {
    if (server.protocol == 'vmess' || server.protocol == 'vless') {
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
    } else if (server.protocol == 'shadowsocks') {
      return await _showEditServerDialog(
        '${S.current.edit} Shadowsocks ${S.current.server}',
        server,
      );
    } else if (server.protocol == 'trojan') {
      return await _showEditServerDialog(
        '${S.current.edit} Trojan ${S.current.server}',
        server,
      );
    } else if (server.protocol == 'hysteria') {
      return await _showEditServerDialog(
        '${S.current.edit} Hysteria ${S.current.server}',
        server,
      );
    }
    return null;
  }

  Future<bool> deleteServer(int serverId) async {
    final server = await serverDao.getServerById(serverId);
    if (server == null) {
      return false;
    }
    logger.i('Deleting Server: ${server.id}');
    await serverDao.deleteServer(serverId);
    await serverDao.refreshServersOrder(server.groupId);
    return true;
  }

  Future<bool> shareServer(String option, int serverId) async {
    final server = await serverDao.getServerModelById(serverId);
    if (server == null) {
      return false;
    }
    switch (option) {
      case 'QRCode':
        String? uri = UriUtil.getUri(server);
        if (uri != null) {
          _shareQRCode(uri);
        }
        return true;
      case 'ExportToClipboard':
        String? uri = UriUtil.getUri(server);
        if (uri != null) {
          UriUtil.exportUriToClipboard(uri);
        }
        return true;
      case 'Configuration':
        return _shareConfiguration(server);
      default:
        return false;
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

  Future<bool> _shareConfiguration(ServerModel server) async {
    final sphiaConfigProvider = GetIt.I.get<SphiaConfigProvider>();
    final sphiaConfig = sphiaConfigProvider.config;
    const exportFileName = 'export.json';

    final protocol = server.protocol;
    final protocolToCore = {
      'vmess': (ServerModel selectedServer, SphiaConfig sphiaConfig) =>
          (selectedServer.protocolProvider ?? sphiaConfig.vmessProvider) ==
                  VmessProvider.xray.index
              ? XrayCore()
              : SingBoxCore(),
      'vless': (ServerModel selectedServer, SphiaConfig sphiaConfig) =>
          (selectedServer.protocolProvider ?? sphiaConfig.vlessProvider) ==
                  VlessProvider.xray.index
              ? XrayCore()
              : SingBoxCore(),
      'shadowsocks': (ServerModel selectedServer, SphiaConfig sphiaConfig) {
        final protocolProvider =
            selectedServer.protocolProvider ?? sphiaConfig.shadowsocksProvider;
        if (protocolProvider == ShadowsocksProvider.xray.index) {
          return XrayCore();
        } else if (protocolProvider == ShadowsocksProvider.sing.index) {
          return SingBoxCore();
        } else {
          return null;
        }
      },
      'trojan': (ServerModel selectedServer, SphiaConfig sphiaConfig) =>
          (selectedServer.protocolProvider ?? sphiaConfig.trojanProvider) ==
                  TrojanProvider.xray.index
              ? XrayCore()
              : SingBoxCore(),
      'hysteria': (ServerModel selectedServer, SphiaConfig sphiaConfig) =>
          (selectedServer.protocolProvider ?? sphiaConfig.hysteriaProvider) ==
                  HysteriaProvider.sing.index
              ? SingBoxCore()
              : HysteriaCore(),
    };
    final core = protocolToCore[protocol]?.call(server, sphiaConfig);
    if (core == null) {
      logger.e('No supported core for protocol: $protocol');
      return false;
    }
    core.configFileName = exportFileName;
    core.isRouting = true;
    core.servers = [server];
    logger.i('Sharing Configuration: ${server.id}');
    await core.configure();
    return true;
  }

  Future<bool> addGroup() async {
    final serverGroupMap = await _showEditServerGroupDialog(
      S.of(context).addGroup,
      '',
      '',
    );
    if (serverGroupMap == null) {
      return false;
    }
    final newGroupName = serverGroupMap['groupName'];
    final subscription = serverGroupMap['subscription'];
    final fetchSubscription = serverGroupMap['fetchSubscription'];
    logger.i('Adding Server Group: $newGroupName');
    final groupId =
        await serverGroupDao.insertServerGroup(newGroupName, subscription);
    await serverGroupDao.refreshServerGroupsOrder();
    final serverConfigProvider = GetIt.I.get<ServerConfigProvider>();
    serverConfigProvider.serverGroups.add(ServerGroup(
      id: groupId,
      name: newGroupName,
      subscription: subscription,
    ));
    if (fetchSubscription && subscription.isNotEmpty) {
      try {
        await updateGroup('CurrentGroup', groupId);
      } on Exception catch (e) {
        if (context.mounted) {
          await SphiaWidget.showDialogWithMsg(
            context,
            '${S.current.updateGroupFailed}: $e',
          );
        }
      }
    }
    return true;
  }

  Future<bool> editGroup(ServerGroup serverGroup) async {
    if (serverGroup.name == 'Default') {
      await _showErrorDialog(serverGroup.name);
      return false;
    }
    final serverGroupMap = await _showEditServerGroupDialog(
      S.of(context).editGroup,
      serverGroup.name,
      serverGroup.subscription,
    );
    if (serverGroupMap == null) {
      return false;
    }
    final newGroupName = serverGroupMap['groupName'];
    final subscription = serverGroupMap['subscription'];
    if ((newGroupName == serverGroup.name &&
        subscription == serverGroup.subscription)) {
      return false;
    }
    logger.i('Editing Server Group: ${serverGroup.id}');
    await serverGroupDao.updateServerGroup(
        serverGroup.id, newGroupName, subscription);
    final serverConfigProvider = GetIt.I.get<ServerConfigProvider>();
    serverConfigProvider.serverGroups[serverConfigProvider.serverGroups
        .indexWhere((element) => element.id == serverGroup.id)] = ServerGroup(
      id: serverGroup.id,
      name: newGroupName,
      subscription: subscription,
    );
    return true;
  }

  Future<bool> updateGroup(String type, int groupId) async {
    switch (type) {
      case 'CurrentGroup':
        final serverGroup = await serverGroupDao.getServerGroupById(groupId);
        if (serverGroup == null) {
          return false;
        }
        final subscription = serverGroup.subscription;
        if (subscription.isEmpty) {
          logger.w('Subscription is empty');
          return false;
        }
        final groupName = serverGroup.name;
        logger.i('Updating Server Group: $groupName');
        try {
          await UriUtil.updateSingleGroup(groupId, subscription);
        } on Exception catch (e) {
          logger.e('Failed to update group: $groupName\n$e');
          rethrow;
        }
        if (context.mounted) {
          SphiaWidget.showDialogWithMsg(
            context,
            S.of(context).updatedGroupSuccessfully,
          );
        }
        return true;
      case 'AllGroups':
        return SubscriptionTask.updateSubscriptions(
          showDialog: true,
          context: context,
        );
      default:
        return false;
    }
  }

  Future<bool> deleteGroup(int groupId) async {
    final groupName = await serverGroupDao.getServerGroupNameById(groupId);
    if (groupName == null) {
      return false;
    }
    if (groupName == 'Default') {
      await _showErrorDialog(groupName);
      return false;
    }
    logger.i('Deleting Server Group: $groupId');
    await serverGroupDao.deleteServerGroup(groupId);
    await serverGroupDao.refreshServerGroupsOrder();
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
    final shape = SphiaTheme.listTileShape(sphiaConfig.useMaterial3);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).reorderGroup),
          content: SizedBox(
            width: double.minPositive,
            child: ReorderableListView.builder(
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
                      surfaceTintColor: Colors.transparent,
                      child: ListTile(
                        shape: shape,
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
    await serverGroupDao.updateServerGroupsOrder(newOrder);
    return true;
  }

  Future<ServerModel?> _showEditServerDialog(
      String title, ServerModel server) async {
    if (server.protocol == 'vmess' || server.protocol == 'vless') {
      return showDialog<ServerModel>(
        context: context,
        builder: (context) =>
            XrayServerDialog(title: title, server: server as XrayServer),
      );
    } else if (server.protocol == 'shadowsocks') {
      return showDialog<ServerModel>(
        context: context,
        builder: (context) => ShadowsocksServerDialog(
            title: title, server: server as ShadowsocksServer),
      );
    } else if (server.protocol == 'trojan') {
      return showDialog<ServerModel>(
        context: context,
        builder: (context) =>
            TrojanServerDialog(title: title, server: server as TrojanServer),
      );
    } else if (server.protocol == 'hysteria') {
      return showDialog<ServerModel>(
        context: context,
        builder: (context) => HysteriaServerDialog(
            title: title, server: server as HysteriaServer),
      );
    }
    return null;
  }

  Future<Map<String, dynamic>?> _showEditServerGroupDialog(
      String title, String groupName, String subscription) async {
    final serverGroupMap = {
      'groupName': groupName,
      'subscription': subscription,
    };
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ServerGroupDialog(
        title: title,
        serverGroupMap: serverGroupMap,
      ),
    );
  }

  Future<void> _showErrorDialog(String groupName) async {
    final msg = '${S.current.cannotEditOrDeleteGroup}: $groupName';
    return SphiaWidget.showDialogWithMsg(context, msg);
  }
}
