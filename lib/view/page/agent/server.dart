import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiver/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/notifier/config/server_config.dart';
import 'package:sphia/app/notifier/config/sphia_config.dart';
import 'package:sphia/app/notifier/data/server.dart';
import 'package:sphia/app/notifier/data/server_group.dart';
import 'package:sphia/app/theme.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/server/hysteria/server.dart';
import 'package:sphia/server/server_model.dart';
import 'package:sphia/server/shadowsocks/server.dart';
import 'package:sphia/server/trojan/server.dart';
import 'package:sphia/server/xray/server.dart';
import 'package:sphia/util/subscription.dart';
import 'package:sphia/util/uri/uri.dart';
import 'package:sphia/view/dialog/hysteria.dart';
import 'package:sphia/view/dialog/server_group.dart';
import 'package:sphia/view/dialog/shadowsocks.dart';
import 'package:sphia/view/dialog/trojan.dart';
import 'package:sphia/view/dialog/xray.dart';
import 'package:sphia/view/widget/widget.dart';

part 'server.g.dart';

@riverpod
class ServerGroupIndexNotifier extends _$ServerGroupIndexNotifier {
  @override
  int build() {
    final serverConfig = ref.read(serverConfigNotifierProvider);
    final serverGroups = ref.read(serverGroupNotifierProvider);
    final index = serverGroups.indexWhere(
        (element) => element.id == serverConfig.selectedServerGroupId);
    return index == -1 ? 0 : index;
  }

  void setIndex(int index) => state = index;
}

enum ServerGroupAction {
  add,
  edit,
  delete,
  reorder,
  none,
}

@riverpod
class ServerGroupStatus extends _$ServerGroupStatus {
  @override
  ServerGroupAction build() {
    return ServerGroupAction.none;
  }

  void set(ServerGroupAction action) {
    state = action;
  }

  void reset() {
    state = ServerGroupAction.none;
  }
}

mixin ServerAgent {
  Future<void> addServer({
    required int groupId,
    required String protocol,
    required WidgetRef ref,
  }) async {
    final context = ref.context;
    late final ServerModel? server;
    switch (protocol) {
      case 'vmess':
      case 'vless':
        server = await _showEditServerDialog(
          title: protocol == 'vmess'
              ? '${S.of(context).add} VMess ${S.of(context).server}'
              : '${S.of(context).add} Vless ${S.of(context).server}',
          server: protocol == 'vmess'
              ? (XrayServer.vmessDefaults()..groupId = groupId)
              : (XrayServer.vlessDefaults()..groupId = groupId),
          context: context,
        );
        break;
      case 'shadowsocks':
        server = await _showEditServerDialog(
          title: '${S.of(context).add} Shadowsocks ${S.of(context).server}',
          server: ShadowsocksServer.defaults()..groupId = groupId,
          context: context,
        );
        break;
      case 'trojan':
        server = await _showEditServerDialog(
          title: '${S.of(context).add} Trojan ${S.of(context).server}',
          server: TrojanServer.defaults()..groupId = groupId,
          context: context,
        );
        break;
      case 'hysteria':
        server = await _showEditServerDialog(
          title: '${S.of(context).add} Hysteria ${S.of(context).server}',
          server: HysteriaServer.defaults()..groupId = groupId,
          context: context,
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
          if (servers.isEmpty) {
            return;
          }
          logger.i('Adding Servers from Clipboard');
          final idList = await serverDao.insertServers(servers);
          await serverDao.refreshServersOrder(groupId);
          final notifier = ref.read(serverNotifierProvider.notifier);
          notifier.addServers(servers
            ..asMap().forEach((index, server) {
              server.id = idList[index];
            }));
        }
        return;
      default:
        break;
    }
    if (server == null) {
      return;
    }
    logger.i('Adding Server: ${server.remark}');
    final serverId = await serverDao.insertServer(server);
    await serverDao.refreshServersOrder(groupId);
    final notifier = ref.read(serverNotifierProvider.notifier);
    notifier.addServer(server..id = serverId);
  }

  Future<ServerModel?> getEditedServer({
    required ServerModel server,
    required BuildContext context,
  }) async {
    if (server.protocol == 'vmess' || server.protocol == 'vless') {
      switch (server.protocol) {
        case 'vmess':
        case 'vless':
          return await _showEditServerDialog(
            title: server.protocol == 'vmess'
                ? '${S.of(context).edit} VMess ${S.of(context).server}'
                : '${S.of(context).edit} Vless ${S.of(context).server}',
            server: server,
            context: context,
          );
      }
    } else if (server.protocol == 'shadowsocks') {
      return await _showEditServerDialog(
        title: '${S.of(context).edit} Shadowsocks ${S.of(context).server}',
        server: server,
        context: context,
      );
    } else if (server.protocol == 'trojan') {
      return await _showEditServerDialog(
        title: '${S.of(context).edit} Trojan ${S.of(context).server}',
        server: server,
        context: context,
      );
    } else if (server.protocol == 'hysteria') {
      return await _showEditServerDialog(
        title: '${S.of(context).edit} Hysteria ${S.of(context).server}',
        server: server,
        context: context,
      );
    }
    return null;
  }

  Future<void> addGroup(WidgetRef ref) async {
    final context = ref.context;
    final serverGroupMap = await _showEditServerGroupDialog(
      title: S.of(context).addGroup,
      groupName: '',
      subscription: '',
      context: context,
    );
    if (serverGroupMap == null) {
      return;
    }
    final newGroupName = serverGroupMap['groupName'];
    final subscription = serverGroupMap['subscription'];
    final fetchSubscription = serverGroupMap['fetchSubscription'];
    logger.i('Adding Server Group: $newGroupName');
    final groupId =
        await serverGroupDao.insertServerGroup(newGroupName, subscription);
    await serverGroupDao.refreshServerGroupsOrder();
    final actionNotifier = ref.read(serverGroupStatusProvider.notifier);
    actionNotifier.set(ServerGroupAction.add);
    final serverGroupNotifier = ref.read(serverGroupNotifierProvider.notifier);
    serverGroupNotifier.addGroup(ServerGroup(
      id: groupId,
      name: newGroupName,
      subscription: subscription,
    ));
    if (fetchSubscription && subscription.isNotEmpty) {
      try {
        await updateGroup(type: 'CurrentGroup', groupId: groupId, ref: ref);
      } on Exception catch (e) {
        if (context.mounted) {
          await SphiaWidget.showDialogWithMsg(
            context: context,
            message: '${S.of(context).updateGroupFailed}: $e',
          );
        }
      }
    }
    return;
  }

  Future<void> editGroup({
    required ServerGroup serverGroup,
    required WidgetRef ref,
  }) async {
    final context = ref.context;
    if (serverGroup.name == 'Default') {
      await _showErrorDialog(groupName: serverGroup.name, context: context);
      return;
    }
    final serverGroupMap = await _showEditServerGroupDialog(
        title: S.of(context).editGroup,
        groupName: serverGroup.name,
        subscription: serverGroup.subscription,
        context: context);
    if (serverGroupMap == null) {
      return;
    }
    final newGroupName = serverGroupMap['groupName'];
    final subscription = serverGroupMap['subscription'];
    if ((newGroupName == serverGroup.name &&
        subscription == serverGroup.subscription)) {
      return;
    }
    logger.i('Editing Server Group: ${serverGroup.id}');
    await serverGroupDao.updateServerGroup(
        serverGroup.id, newGroupName, subscription);
    final actionNotifier = ref.read(serverGroupStatusProvider.notifier);
    actionNotifier.set(ServerGroupAction.edit);
    final notifier = ref.read(serverGroupNotifierProvider.notifier);
    notifier.updateGroup(ServerGroup(
      id: serverGroup.id,
      name: newGroupName,
      subscription: subscription,
    ));
    return;
  }

  Future<void> updateGroup({
    required String type,
    int? groupId,
    required WidgetRef ref,
  }) async {
    final serverConfig = ref.read(serverConfigNotifierProvider);
    final subscriptionUtil = ref.read(subscriptionUtilProvider.notifier);
    switch (type) {
      case 'CurrentGroup':
        final id = groupId ?? serverConfig.selectedServerGroupId;
        final serverGroup = await serverGroupDao.getServerGroupById(id);
        if (serverGroup == null) {
          return;
        }
        final subscription = serverGroup.subscription;
        if (subscription.isEmpty) {
          logger.w('Subscription is empty');
          return;
        }
        final groupName = serverGroup.name;
        logger.i('Updating Server Group: $groupName');
        try {
          await subscriptionUtil.updateSingleGroup(
            groupId: id,
            subscription: subscription,
          );
        } on Exception catch (e) {
          logger.e('Failed to update group: $groupName\n$e');
          rethrow;
        }
        final serverNotifier = ref.read(serverNotifierProvider.notifier);
        final servers = await serverDao.getOrderedServerModelsByGroupId(id);
        final curId = ref.read(serverConfigNotifierProvider
            .select((value) => value.selectedServerGroupId));
        if (curId == id) {
          serverNotifier.setServers(servers);
        }
        final context = ref.context;
        if (context.mounted) {
          SphiaWidget.showDialogWithMsg(
            context: context,
            message: S.of(context).updatedGroupSuccessfully,
          );
        }
        return;
      case 'AllGroups':
        int count = 0;
        bool flag = false;
        final serverGroups = await serverGroupDao.getOrderedServerGroups();
        final subscriptionUtil = ref.read(subscriptionUtilProvider.notifier);
        for (var serverGroup in serverGroups) {
          final subscription = serverGroup.subscription;
          if (subscription.isEmpty) {
            continue;
          }
          logger.i('Updating Server Group: ${serverGroup.name}');
          try {
            await subscriptionUtil.updateSingleGroup(
              groupId: serverGroup.id,
              subscription: subscription,
            );
            flag = true;
            count++;
          } on Exception catch (e) {
            logger.e('Failed to update group: ${serverGroup.name}\n$e');
            continue;
          }
        }
        if (flag) {
          final serverConfig = ref.read(serverConfigNotifierProvider);
          final id = serverConfig.selectedServerGroupId;
          final servers = await serverDao.getOrderedServerModelsByGroupId(id);
          final serverNotifier = ref.read(serverNotifierProvider.notifier);
          serverNotifier.setServers(servers);
        }
        final context = ref.context;
        if (context.mounted) {
          final total = serverGroups.length;
          SphiaWidget.showDialogWithMsg(
            context: context,
            message:
                S.of(context).numSubscriptionsHaveBeenUpdated(count, total),
          );
        }
      default:
        return;
    }
  }

  Future<void> deleteGroup({
    required int groupId,
    required WidgetRef ref,
  }) async {
    final context = ref.context;
    final groupName = await serverGroupDao.getServerGroupNameById(groupId);
    if (groupName == null) {
      return;
    }
    if (groupName == 'Default') {
      if (context.mounted) {
        await _showErrorDialog(groupName: groupName, context: ref.context);
      }
      return;
    }
    logger.i('Deleting Server Group: $groupId');
    await serverGroupDao.deleteServerGroup(groupId);
    await serverGroupDao.refreshServerGroupsOrder();
    final actionNotifier = ref.read(serverGroupStatusProvider.notifier);
    actionNotifier.set(ServerGroupAction.delete);
    final notifier = ref.read(serverGroupNotifierProvider.notifier);
    notifier.removeGroup(groupId);
    if (ref.read(serverConfigNotifierProvider).selectedServerGroupId ==
        groupId) {
      final notifier = ref.read(serverConfigNotifierProvider.notifier);
      notifier.updateValue('selectedServerGroupId', 1);
    }
    return;
  }

  Future<bool> reorderGroup(WidgetRef ref) async {
    final context = ref.context;
    final useMaterial3 = ref.read(
        sphiaConfigNotifierProvider.select((value) => value.useMaterial3));
    final serverGroups = ref.read(serverGroupNotifierProvider);
    final oldOrder = serverGroups.map((e) => e.id).toList();
    final shape = SphiaTheme.listTileShape(useMaterial3);
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
    final actionNotifier = ref.read(serverGroupStatusProvider.notifier);
    actionNotifier.set(ServerGroupAction.reorder);
    final notifier = ref.read(serverGroupNotifierProvider.notifier);
    notifier.setGroups(serverGroups);
    return true;
  }

  Future<ServerModel?> _showEditServerDialog({
    required String title,
    required ServerModel server,
    required BuildContext context,
  }) async {
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

  Future<Map<String, dynamic>?> _showEditServerGroupDialog({
    required String title,
    required String groupName,
    required String subscription,
    required BuildContext context,
  }) async {
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

  Future<void> _showErrorDialog({
    required String groupName,
    required BuildContext context,
  }) async {
    final title = '${S.of(context).cannotEditOrDeleteGroup}: $groupName';
    return SphiaWidget.showDialogWithMsg(context: context, message: title);
  }
}
