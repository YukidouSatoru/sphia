import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sphia/app/controller.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/core.dart';
import 'package:sphia/app/provider/server_config.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/util/traffic/traffic.dart';
import 'package:sphia/view/page/wrapper.dart';
import 'package:sphia/view/widget/dashboard_card/chart.dart';
import 'package:sphia/view/widget/dashboard_card/dns.dart';
import 'package:sphia/view/widget/dashboard_card/net.dart';
import 'package:sphia/view/widget/dashboard_card/rules.dart';
import 'package:sphia/view/widget/dashboard_card/running_cores.dart';
import 'package:sphia/view/widget/dashboard_card/traffic.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _previousTrafficRunning = false;
  Traffic? _traffic;
  final _cardRunningCores = const RunningCoresCard();
  final _cardRules = const RulesCard();
  final _cardDns = const DnsCard();
  final _cardTraffic = TrafficCard();
  final _networkChart = NetworkChart();
  late final NetCard _cardNet;

  int _totalUpload = 0;
  int _totalDownload = 0;

  @override
  void initState() {
    super.initState();
    _cardNet = NetCard(
      networkChart: _networkChart,
    );
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

    if (coreProvider.trafficRunning != _previousTrafficRunning) {
      _trafficStats(coreProvider.trafficRunning, sphiaConfig.enableStatistics);
      _previousTrafficRunning = coreProvider.trafficRunning;
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
                        Flexible(child: _cardRunningCores),
                        const SizedBox(width: cardhorizontalSpacing),
                        Flexible(child: _cardRules),
                        const SizedBox(width: cardhorizontalSpacing),
                        Flexible(child: _cardDns),
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
                        Flexible(flex: 2, child: _cardTraffic),
                        const SizedBox(width: cardhorizontalSpacing),
                        Flexible(flex: 7, child: _cardNet),
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

  void _trafficStats(bool trafficRunning, bool enableStats) async {
    if (trafficRunning && enableStats) {
      await _startTrafficStats();
    } else {
      await _stopTrafficStats();
    }
  }

  Future<void> _startTrafficStats() async {
    final sphiaConfigProvider = GetIt.I.get<SphiaConfigProvider>();
    final coreProvider = GetIt.I.get<CoreProvider>();
    if (coreProvider.routing.name == 'sing-box') {
      _traffic = SingBoxTraffic(sphiaConfigProvider.config.coreApiPort);
    } else {
      _traffic = XrayTraffic(
        sphiaConfigProvider.config.coreApiPort,
        sphiaConfigProvider.config.multiOutboundSupport,
      );
    }

    _clearTraffic();

    try {
      await _traffic!.start();
    } catch (e) {
      _traffic = null;
      logger.e('Failed to start/stop traffic: $e');
      return;
    }

    final stream = _traffic!.apiStreamController.stream;
    await for (var dataJson in stream) {
      final data = json.decode(dataJson.toString());
      final nowStamp = DateTime.now().millisecondsSinceEpoch;

      _totalUpload = data['uplink'];
      _totalDownload = data['downlink'];

      // for total
      _cardTraffic.totalUpload.value = data['uplink'];
      _cardTraffic.totalDownload.value = data['downlink'];
      // for speed
      _cardTraffic.uploadLastSecond.value = data['up'];
      _cardTraffic.downloadLastSecond.value = data['down'];

      // for chart
      if (sphiaConfigProvider.config.enableSpeedChart) {
        _networkChart.uploadSpots
            .add(FlSpot(nowStamp.toDouble(), data['up'].toDouble()));
        _networkChart.downloadSpots
            .add(FlSpot(nowStamp.toDouble(), data['down'].toDouble()));
      }
    }
  }

  Future<void> _stopTrafficStats() async {
    if (_traffic != null) {
      await _updateServerTraffic();
      await _traffic!.stop();
      _traffic = null;
    }
  }

  Future<void> _updateServerTraffic() async {
    if (_totalUpload == 0 && _totalDownload == 0) {
      // no need to update traffic
      return;
    }

    final sphiaConfigProvider = GetIt.I.get<SphiaConfigProvider>();
    final sphiaConfig = sphiaConfigProvider.config;
    final coreProvider = GetIt.I.get<CoreProvider>();

    if (sphiaConfig.multiOutboundSupport &&
        coreProvider.routing.name == 'sing-box') {
      /*
      sing-box does not support traffic statistics for each outbound
      when multiOutboundSupport is enabled
       */
      return;
    }

    if (sphiaConfig.multiOutboundSupport) {
      final serverIds = coreProvider.routing.serverId;
      final servers = await serverDao.getServersByIdList(serverIds);
      if (servers.isEmpty) {
        // probably server is deleted
        return;
      }

      for (var server in servers) {
        late final String outboundTag;
        if (server.id == serverIds.first) {
          // serverIds.first is the main server's id,
          // but servers.first is not guaranteed to be the main server
          outboundTag = 'proxy';
        } else {
          outboundTag = 'proxy-${server.id}';
        }

        final proxyLink = await (_traffic as XrayTraffic)
            .queryProxyLinkByOutboundTag(outboundTag);
        final newServer = server.copyWith(
          uplink: Value(server.uplink == null
              ? proxyLink.item1
              : server.uplink! + proxyLink.item1),
          downlink: Value(server.downlink == null
              ? proxyLink.item2
              : server.downlink! + proxyLink.item2),
        );
        await serverDao.updateServer(newServer);
      }

      final serverConfigProvider = GetIt.I.get<ServerConfigProvider>();
      serverConfigProvider.servers = await serverDao.getOrderedServersByGroupId(
          serverConfigProvider.config.selectedServerGroupId);
      _clearTraffic();
    } else {
      // just one server
      // when multiple cores are running,
      // the first core is the protocol provider
      final server = await SphiaController.getRunningServer();
      final newServer = server.copyWith(
        uplink: Value(server.uplink == null
            ? _totalUpload
            : server.uplink! + _totalUpload),
        downlink: Value(server.downlink == null
            ? _totalDownload
            : server.downlink! + _totalDownload),
      );
      await serverDao.updateServer(newServer);
      _clearTraffic();
      final serverConfigProvider = GetIt.I.get<ServerConfigProvider>();
      final index = serverConfigProvider.servers
          .indexWhere((element) => element.id == newServer.id);
      if (index != -1) {
        serverConfigProvider.servers[index] = newServer;
        // serverConfigProvider.notify();
      }
    }
  }

  void _clearTraffic() {
    _totalUpload = 0;
    _totalDownload = 0;
    _cardTraffic.totalUpload.value = 0;
    _cardTraffic.totalDownload.value = 0;
    _cardTraffic.uploadLastSecond.value = 0;
    _cardTraffic.downloadLastSecond.value = 0;
  }
}
