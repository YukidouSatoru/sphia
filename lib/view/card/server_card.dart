import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/notifier/config/server_config.dart';
import 'package:sphia/app/notifier/config/sphia_config.dart';
import 'package:sphia/app/notifier/data/server.dart';
import 'package:sphia/app/provider/core.dart';
import 'package:sphia/app/theme.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/server/hysteria/server.dart';
import 'package:sphia/server/server_model.dart';
import 'package:sphia/server/shadowsocks/server.dart';
import 'package:sphia/server/trojan/server.dart';
import 'package:sphia/server/xray/server.dart';
import 'package:sphia/util/latency.dart';
import 'package:sphia/util/system.dart';
import 'package:sphia/util/uri/uri.dart';
import 'package:sphia/view/card/dashboard_card/chart.dart';
import 'package:sphia/view/page/agent/server.dart';
import 'package:sphia/view/widget/widget.dart';

part 'server_card.g.dart';

@riverpod
ServerModel currentServer(Ref ref) => throw UnimplementedError();

class ServerCard extends ConsumerWidget with ServerAgent {
  const ServerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref
        .watch(sphiaConfigNotifierProvider.select((value) => value.darkMode));
    final useMaterial3 = ref.watch(
        sphiaConfigNotifierProvider.select((value) => value.useMaterial3));
    final themeColor = Color(ref.watch(
        sphiaConfigNotifierProvider.select((value) => value.themeColor)));
    final showTransport = ref.watch(
        sphiaConfigNotifierProvider.select((value) => value.showTransport));
    final showAddress = ref.watch(
        sphiaConfigNotifierProvider.select((value) => value.showAddress));
    final server = ref.watch(currentServerProvider);
    final isSelected = ref.watch(serverConfigNotifierProvider
        .select((value) => value.selectedServerId == server.id));
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
                                color: darkMode ? Colors.white : Colors.black)),
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
                    if ((newServer = await editServer(
                          server: server,
                          ref: ref,
                        )) !=
                        null) {
                      final notifier =
                          ref.read(serverNotifierProvider.notifier);
                      notifier.updateServer(newServer!);
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
                    if (await shareServer(
                      option: value,
                      server: server,
                      ref: ref,
                    )) {
                      if (value == 'Configuration') {
                        if (!context.mounted) {
                          return;
                        }
                        await SphiaWidget.showDialogWithMsg(
                          context: context,
                          message:
                              '${S.of(context).exportToFile}: ${p.join(tempPath, 'export.json')}',
                        );
                      } else if (value == 'ExportToClipboard') {
                        if (!context.mounted) {
                          return;
                        }
                        await SphiaWidget.showDialogWithMsg(
                          context: context,
                          message: S.of(context).exportToClipboard,
                        );
                      }
                    } else {
                      if (value == 'Configuration') {
                        if (!context.mounted) {
                          return;
                        }
                        await SphiaWidget.showDialogWithMsg(
                          context: context,
                          message: S.of(context).noConfigurationFileGenerated,
                        );
                      }
                    }
                  },
                ),
                SphiaWidget.iconButton(
                  icon: Icons.delete,
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(S.of(context).deleteServer),
                        content: Text(
                            S.of(context).deleteServerConfirm(server.remark)),
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
                    logger.i('Deleting Server: ${server.id}');
                    await serverDao.deleteServer(server.id);
                    await serverDao.refreshServersOrder(server.groupId);
                    final serverNotifier =
                        ref.read(serverNotifierProvider.notifier);
                    serverNotifier.removeServer(server);
                  },
                )
              ],
            ),
            onTap: () {
              final serverConfig = ref.read(serverConfigNotifierProvider);
              final notifier = ref.read(serverConfigNotifierProvider.notifier);
              if (server.id == serverConfig.selectedServerId) {
                notifier.updateValue('selectedServerId', 0);
              } else {
                notifier.updateValue('selectedServerId', server.id);
              }
            },
          ),
        ),
      ],
    );
  }

  String _getServerTraffic(double uplink, double downlink) {
    if (uplink == 0 && downlink == 0) {
      return '';
    }
    int uplinkUnitIndex = uplink > 0 ? getUnit(uplink.toInt()) : 0;
    int downlinkUnitIndex = downlink > 0 ? getUnit(downlink.toInt()) : 0;

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

  Future<ServerModel?> editServer({
    required ServerModel server,
    required WidgetRef ref,
  }) async {
    final context = ref.context;
    final ServerModel? editedServer = await getEditedServer(
      server: server,
      context: context,
    );
    if (editedServer == null || editedServer == server) {
      return null;
    }
    logger.i('Editing Server: ${server.id}');
    await serverDao.updateServer(editedServer);
    return editedServer;
  }

  Future<bool> shareServer({
    required String option,
    required ServerModel server,
    required WidgetRef ref,
  }) async {
    switch (option) {
      case 'QRCode':
        String? uri = UriUtil.getUri(server);
        final context = ref.context;
        if (uri != null && context.mounted) {
          _shareQRCode(uri: uri, context: context);
        }
        return true;
      case 'ExportToClipboard':
        String? uri = UriUtil.getUri(server);
        if (uri != null) {
          UriUtil.exportUriToClipboard(uri);
        }
        return true;
      case 'Configuration':
        return _shareConfiguration(
          server: server,
          ref: ref,
        );
      default:
        return false;
    }
  }

  void _shareQRCode({
    required String uri,
    required BuildContext context,
  }) async {
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

  Future<bool> _shareConfiguration({
    required ServerModel server,
    required WidgetRef ref,
  }) async {
    const exportFileName = 'export.json';

    final protocol = server.protocol;
    final protocolToCore = {
      'vmess': (ServerModel selectedServer, SphiaConfig sphiaConfig) =>
          (selectedServer.protocolProvider ?? sphiaConfig.vmessProvider) ==
                  VmessProvider.xray.index
              ? ref.read(xrayCoreProvider)
              : ref.read(singBoxCoreProvider),
      'vless': (ServerModel selectedServer, SphiaConfig sphiaConfig) =>
          (selectedServer.protocolProvider ?? sphiaConfig.vlessProvider) ==
                  VlessProvider.xray.index
              ? ref.read(xrayCoreProvider)
              : ref.read(singBoxCoreProvider),
      'shadowsocks': (ServerModel selectedServer, SphiaConfig sphiaConfig) {
        final protocolProvider =
            selectedServer.protocolProvider ?? sphiaConfig.shadowsocksProvider;
        if (protocolProvider == ShadowsocksProvider.xray.index) {
          return ref.read(xrayCoreProvider);
        } else if (protocolProvider == ShadowsocksProvider.sing.index) {
          return ref.read(singBoxCoreProvider);
        } else {
          return null;
        }
      },
      'trojan': (ServerModel selectedServer, SphiaConfig sphiaConfig) =>
          (selectedServer.protocolProvider ?? sphiaConfig.trojanProvider) ==
                  TrojanProvider.xray.index
              ? ref.read(xrayCoreProvider)
              : ref.read(singBoxCoreProvider),
      'hysteria': (ServerModel selectedServer, SphiaConfig sphiaConfig) =>
          (selectedServer.protocolProvider ?? sphiaConfig.hysteriaProvider) ==
                  HysteriaProvider.sing.index
              ? ref.read(singBoxCoreProvider)
              : ref.read(hysteriaCoreProvider),
    };
    final sphiaConfig = ref.read(sphiaConfigNotifierProvider);
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
}
