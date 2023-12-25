import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sphia/app/controller.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/core.dart';
import 'package:sphia/app/provider/rule_config.dart';
import 'package:sphia/app/provider/server_config.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/theme.dart';
import 'package:sphia/app/tray.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/server/server_base.dart';
import 'package:sphia/util/network.dart';
import 'package:sphia/util/traffic/traffic.dart';
import 'package:sphia/view/page/agent/update.dart';
import 'package:sphia/view/page/wrapper.dart';
import 'package:sphia/view/widget/chart.dart';
import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _previousCoreRunning = false;
  String _currentIp = '';
  Traffic? _traffic;
  final _networkChart = NetworkChart();
  int _serverId = 0;
  final _uploadLastSecond = ValueNotifier<int>(0);
  final _downloadLastSecond = ValueNotifier<int>(0);
  final _totalUpload = ValueNotifier<int>(0);
  final _totalDownload = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final configProvider =
          Provider.of<SphiaConfigProvider>(context, listen: false);
      if (configProvider.config.autoGetIp) {
        setState(() {
          _currentIp = S.of(context).gettingIp;
        });
        final ip = await NetworkUtil.getIp();
        setState(() {
          _currentIp = ip;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sphiaConfigProvider = Provider.of<SphiaConfigProvider>(context);
    final coreProvider = Provider.of<CoreProvider>(context);
    final sphiaConfig = sphiaConfigProvider.config;

    final runningCoresCard = CardData(
      title: Text(S.of(context).runningCores),
      icon: Icons.memory,
      widget: coreProvider.coreRunning
          ? ListView.builder(
              itemCount: coreProvider.cores.length,
              itemBuilder: (BuildContext context, int index) {
                final coreName = coreProvider.cores[index].coreName;
                final String runningServerName = jsonDecode(
                    coreProvider.cores[index].runningServer.data)['remark'];
                return ListTile(
                  shape: SphiaTheme.listTileShape(sphiaConfig.useMaterial3),
                  title: Text(coreName),
                  onTap: () async {
                    await showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        String repoUrl = coreRepositories[coreName]!;
                        return AlertDialog(
                          title: Text(coreName),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Expanded(child: Divider()),
                                  Text(S.of(context).repoUrl),
                                  const Expanded(child: Divider()),
                                ],
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: repoUrl,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          await launchUrl(Uri.parse(repoUrl));
                                        },
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  const Expanded(child: Divider()),
                                  Text(S.of(context).runningServer),
                                  const Expanded(child: Divider()),
                                ],
                              ),
                              Text(
                                runningServerName,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            )
          : Center(
              child: Text(
                S.of(context).noRunningCores,
              ),
            ),
    );
    final rulesCard = CardData(
        title: Text(S.of(context).rules),
        icon: Icons.alt_route,
        widget: Consumer<RuleConfigProvider>(
          builder: (context, ruleConfigProvider, child) {
            return ListView.builder(
              itemCount: ruleConfigProvider.ruleGroups.length,
              itemBuilder: (BuildContext context, int index) {
                final ruleGroup = ruleConfigProvider.ruleGroups[index];
                return ListTile(
                  shape: SphiaTheme.listTileShape(sphiaConfig.useMaterial3),
                  title: Text(
                    ruleConfigProvider.ruleGroups[index].name,
                  ),
                  trailing: Icon(
                    ruleGroup.id ==
                            ruleConfigProvider.config.selectedRuleGroupId
                        ? Icons.check
                        : null,
                  ),
                  onTap: () async {
                    if (ruleGroup.id !=
                        ruleConfigProvider.config.selectedRuleGroupId) {
                      logger.i('Switching to rule group $index');
                      SphiaTray.setMenuItem(
                          'rule-${ruleConfigProvider.config.selectedRuleGroupId}',
                          false);
                      SphiaTray.setMenuItem('rule-${ruleGroup.id}', true);
                      ruleConfigProvider.config.selectedRuleGroupId =
                          ruleGroup.id;
                      ruleConfigProvider.saveConfig();
                      await SphiaController.restartCores();
                    }
                  },
                );
              },
            );
          },
        ));
    final dnsCard = CardData(
      title: Text(S.of(context).dns),
      icon: Icons.dns,
      widget: sphiaConfig.configureDns
          ? ListView(
              children: [
                ListTile(
                  shape: SphiaTheme.listTileShape(sphiaConfig.useMaterial3),
                  title: Text(S.of(context).remoteDns),
                  subtitle: Text(sphiaConfig.remoteDns),
                  onTap: () async {
                    TextEditingController remoteDnsController =
                        TextEditingController();
                    remoteDnsController.text = sphiaConfig.remoteDns;
                    await showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(S.of(context).remoteDns),
                          content: TextFormField(
                            controller: remoteDnsController,
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
                                logger.i(
                                    'Updating remoteDNS from ${sphiaConfig.remoteDns} to ${remoteDnsController.text}');
                                sphiaConfig.remoteDns =
                                    remoteDnsController.text;
                                sphiaConfigProvider.saveConfig();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  shape: SphiaTheme.listTileShape(sphiaConfig.useMaterial3),
                  title: Text(S.of(context).directDns),
                  subtitle: Text(sphiaConfig.directDns),
                  onTap: () async {
                    TextEditingController directDnsController =
                        TextEditingController();
                    directDnsController.text = sphiaConfig.directDns;
                    await showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(S.of(context).directDns),
                          content: TextFormField(
                            controller: directDnsController,
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
                                logger.i(
                                    'Updating directDNS from ${sphiaConfig.directDns} to ${directDnsController.text}');
                                sphiaConfig.directDns =
                                    directDnsController.text;
                                sphiaConfigProvider.saveConfig();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            )
          : Center(
              child: Text(
                S.of(context).dnsIsNotConfigured,
              ),
            ),
    );

    final cardNet = CardData(
      title: Row(
        children: [
          Text(
            sphiaConfig.autoGetIp
                ? '${S.of(context).currentIp}: ${_currentIp.isNotEmpty ? _currentIp : S.of(context).getIpFailed}'
                : S.of(context).speed,
          ),
          const Spacer(),
          sphiaConfig.autoGetIp
              ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentIp = S.of(context).gettingIp;
                    });
                    (() async {
                      late final String ip;
                      ip = await NetworkUtil.getIp();
                      setState(() {
                        _currentIp = ip;
                      });
                    })();
                  },
                  child: Text(S.of(context).refresh),
                )
              : const SizedBox.shrink(),
        ],
      ),
      icon: Icons.near_me,
      widget: Column(
        children: [
          Expanded(
            child: Center(
              child: ClipRect(child: _networkChart),
            ),
          ),
        ],
      ),
    );

    int getUnit(int byte) {
      int ret = 0;
      for (int idx = 0; idx < 5; idx++) {
        if (byte > unitRates[idx]) {
          ret = idx;
        }
      }
      return ret;
    }

    final cardTraffic = CardData(
      title: Text(S.of(context).traffic),
      icon: Icons.data_usage,
      widget: sphiaConfig.enableStatistics
          ? ListView(
              children: [
                ListTile(
                  title: Text(S.of(context).upload),
                  subtitle: ValueListenableBuilder<int>(
                    valueListenable: _totalUpload,
                    builder: (context, value, child) {
                      final totalUploadIdx =
                          getUnit(_totalUpload.value.toInt());
                      final showUpload =
                          _totalUpload.value / unitRates[totalUploadIdx];
                      return Text(
                          '${showUpload.toStringAsFixed(1)} ${units[totalUploadIdx]}');
                    },
                  ),
                ),
                ListTile(
                  title: Text(S.of(context).download),
                  subtitle: ValueListenableBuilder<int>(
                    valueListenable: _totalDownload,
                    builder: (context, value, child) {
                      final totalDownloadIdx =
                          getUnit(_totalDownload.value.toInt());
                      final showDownload =
                          _totalDownload.value / unitRates[totalDownloadIdx];
                      return Text(
                        '${showDownload.toStringAsFixed(1)} ${units[totalDownloadIdx]}',
                      );
                    },
                  ),
                ),
                ListTile(
                  title: Text(S.of(context).uploadSpeed),
                  subtitle: ValueListenableBuilder<int>(
                    valueListenable: _uploadLastSecond,
                    builder: (context, value, child) {
                      final uploadLastSecondIdx =
                          getUnit(_uploadLastSecond.value.toInt());
                      final showUploadSpeed = _uploadLastSecond.value /
                          unitRates[uploadLastSecondIdx];
                      return Text(
                        '${showUploadSpeed.toStringAsFixed(1)} ${units[uploadLastSecondIdx]}/s',
                      );
                    },
                  ),
                ),
                ListTile(
                  title: Text(S.of(context).downloadSpeed),
                  subtitle: ValueListenableBuilder<int>(
                    valueListenable: _downloadLastSecond,
                    builder: (context, value, child) {
                      final downloadLastSecondIdx =
                          getUnit(_downloadLastSecond.value.toInt());
                      final showDownloadSpeed = _downloadLastSecond.value /
                          unitRates[downloadLastSecondIdx];
                      return Text(
                        '${showDownloadSpeed.toStringAsFixed(1)} ${units[downloadLastSecondIdx]}/s',
                      );
                    },
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                S.of(context).statisticsIsDisabled,
              ),
            ),
    );

    if (coreProvider.coreRunning != _previousCoreRunning) {
      _trafficStats();
      if (sphiaConfig.autoGetIp) {
        setState(() {
          _currentIp = S.of(context).gettingIp;
        });
        (() async {
          late final String ip;
          ip = await NetworkUtil.getIp();
          setState(() {
            _currentIp = ip;
          });
        })();
      }
      _previousCoreRunning = coreProvider.coreRunning;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).dashboard),
        elevation: 0,
      ),
      body: PageWrapper(
        padding: dashboardPadding,
        child: Column(
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 3,
                    child: Row(
                      children: [
                        const SizedBox(width: edgehorizontalSpacing),
                        Flexible(child: _buildCard(runningCoresCard)),
                        const SizedBox(width: cardhorizontalSpacing),
                        Flexible(child: _buildCard(rulesCard)),
                        const SizedBox(width: cardhorizontalSpacing),
                        Flexible(child: _buildCard(dnsCard)),
                        const SizedBox(width: edgehorizontalSpacing),
                      ],
                    ),
                  ),
                  const SizedBox(height: cardVerticalSpacing),
                  Flexible(
                    flex: 4,
                    child: Row(
                      children: [
                        const SizedBox(width: edgehorizontalSpacing),
                        Flexible(flex: 2, child: _buildCard(cardTraffic)),
                        const SizedBox(width: cardhorizontalSpacing),
                        Flexible(flex: 7, child: _buildCard(cardNet)),
                        const SizedBox(width: edgehorizontalSpacing),
                      ],
                    ),
                  ),
                  const SizedBox(height: edgeVerticalSpacing),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(CardData cardData) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(cardData.icon),
                ),
                Flexible(
                  child: cardData.title,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(child: cardData.widget),
          ],
        ),
      ),
    );
  }

  void _trafficStats() async {
    final sphiaConfigProvider = GetIt.I.get<SphiaConfigProvider>();
    final coreProvider = GetIt.I.get<CoreProvider>();
    final sphiaConfig = sphiaConfigProvider.config;
    if (coreProvider.coreRunning && sphiaConfig.enableStatistics) {
      _serverId = coreProvider.cores.first.runningServer.id;
      if (coreProvider.cores.last.coreName == 'sing-box') {
        _traffic = SingBoxTraffic(sphiaConfig.coreApiPort);
      } else {
        _traffic = XrayTraffic(sphiaConfig.coreApiPort);
      }
      _totalUpload.value = 0;
      _totalDownload.value = 0;
      try {
        await _traffic!.start();
      } on Exception catch (_) {
        _traffic = null;
        rethrow;
      }
      final stream = _traffic!.apiStreamController.stream;
      await for (var dataJson in stream) {
        final data = json.decode(dataJson.toString());
        final nowStamp = DateTime.now().millisecondsSinceEpoch;

        _totalUpload.value = data['uplink'];
        _totalDownload.value = data['downlink'];
        // for speed
        _uploadLastSecond.value = data['up'];
        _downloadLastSecond.value = data['down'];

        // for chart
        _networkChart.uploadSpots
            .add(FlSpot(nowStamp.toDouble(), data['up'].toDouble()));
        _networkChart.downloadSpots
            .add(FlSpot(nowStamp.toDouble(), data['down'].toDouble()));
      }
    } else {
      if (_traffic != null) {
        await _traffic!.stop();
        _traffic = null;
        if (_totalUpload.value != 0 || _totalDownload.value != 0) {
          final server = await SphiaDatabase.serverDao.getServerById(_serverId);
          if (server == null) {
            return;
          }
          final serverBase = ServerBase.fromJson(jsonDecode(server.data));
          serverBase.uplink = serverBase.uplink == null
              ? _totalUpload.value
              : serverBase.uplink! + _totalUpload.value;
          serverBase.downlink = serverBase.downlink == null
              ? _totalDownload.value
              : serverBase.downlink! + _totalDownload.value;
          await SphiaDatabase.serverDao.updateServer(
              _serverId, const JsonEncoder().convert(serverBase.toJson()));
          _totalUpload.value = 0;
          _totalDownload.value = 0;
          _uploadLastSecond.value = 0;
          _downloadLastSecond.value = 0;
          final newServer = Server(
            id: server.id,
            groupId: server.groupId,
            data: const JsonEncoder().convert(serverBase.toJson()),
          );
          final serverConfigProvider = GetIt.I.get<ServerConfigProvider>();
          final index = serverConfigProvider.servers
              .indexWhere((element) => element.id == newServer.id);
          if (index != -1) {
            serverConfigProvider.servers[index] = newServer;
            // serverConfigProvider.notify();
          }
        }
      }
    }
  }
}

class CardData {
  Widget title;
  IconData icon;
  Widget widget;

  CardData({
    required this.title,
    required this.icon,
    required this.widget,
  });
}
