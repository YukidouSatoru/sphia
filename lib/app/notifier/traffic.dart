import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/notifier/config/server_config.dart';
import 'package:sphia/app/notifier/config/sphia_config.dart';
import 'package:sphia/app/notifier/core_state.dart';
import 'package:sphia/app/notifier/data/server.dart';
import 'package:sphia/app/notifier/proxy.dart';
import 'package:sphia/app/state/core_state.dart';
import 'package:sphia/app/state/traffic.dart';
import 'package:sphia/util/traffic/traffic.dart';

part 'traffic.g.dart';

@Riverpod(keepAlive: true)
class TrafficNotifier extends _$TrafficNotifier {
  @override
  TrafficState build() => const TrafficState();

  Future<void> start() async {
    final sphiaConfig = ref.read(sphiaConfigNotifierProvider);
    final coreState = ref.read(coreStateNotifierProvider).valueOrNull;
    final routingName = coreState?.routing.name;
    if (routingName == null) {
      logger.e('Core state is null');
      throw Exception('Core state is null');
    }
    if (routingName == 'sing-box') {
      state = TrafficState(traffic: SingBoxTraffic(sphiaConfig.coreApiPort));
    } else {
      state = TrafficState(
        traffic: XrayTraffic(
          sphiaConfig.coreApiPort,
          sphiaConfig.multiOutboundSupport,
        ),
      );
    }

    try {
      await state.traffic!.start();
    } catch (e) {
      state = const TrafficState();
      logger.e('Failed to start/stop traffic: $e');
      return;
    }
    final proxyNotifier = ref.read(proxyNotifierProvider.notifier);
    proxyNotifier.setTrafficRunning(true);
  }

  Future<void> stop() async {
    if (state.traffic != null) {
      await _updateServerTraffic();
      final proxyNotifier = ref.read(proxyNotifierProvider.notifier);
      proxyNotifier.setTrafficRunning(false);
      await state.traffic!.stop();
      state = const TrafficState();
    }
  }

  Future<void> _updateServerTraffic() async {
    final uplink = state.traffic!.uplink;
    final downlink = state.traffic!.downlink;
    if (uplink == 0 && downlink == 0) {
      // no need to update traffic
      return;
    }

    final sphiaConfig = ref.read(sphiaConfigNotifierProvider);
    final coreState = ref.read(coreStateNotifierProvider).valueOrNull;
    final routingName = coreState?.routing.name;

    if (routingName == null) {
      logger.e('Core state is null');
      throw Exception('Core state is null');
    }

    if (sphiaConfig.multiOutboundSupport && routingName == 'sing-box') {
      /*
      sing-box does not support traffic statistics for each outbound
      when multiOutboundSupport is enabled
       */
      return;
    }

    if (sphiaConfig.multiOutboundSupport) {
      final servers = coreState!.routing.servers;
      if (servers.isEmpty) {
        // probably server is deleted
        return;
      }

      for (var server in servers) {
        late final String outboundTag;
        if (server.id == servers.first.id) {
          // serverIds.first is the main server's id,
          // but servers.first is not guaranteed to be the main server
          outboundTag = 'proxy';
        } else {
          outboundTag = 'proxy-${server.id}';
        }

        final proxyLink = await (state.traffic as XrayTraffic)
            .queryProxyLinkByOutboundTag(outboundTag);
        int uplink = proxyLink.item1;
        int downlink = proxyLink.item2;
        if (server.uplink != null) {
          uplink += server.uplink!;
        }
        if (server.downlink != null) {
          downlink += server.downlink!;
        }
        await serverDao.updateTraffic(server.id, uplink, downlink);
      }

      final serverConfig = ref.read(serverConfigNotifierProvider);
      final serverNotifier = ref.read(serverNotifierProvider.notifier);
      // update servers from database
      final id = serverConfig.selectedServerId;
      final newServers = await serverDao.getOrderedServerModelsByGroupId(id);
      serverNotifier.setServers(newServers);
    } else {
      // just one server
      // when multiple cores are running,
      // the first core is the protocol provider
      final server = await ref
          .read(coreStateNotifierProvider.notifier)
          .getRunningServerModel();
      final newUplink =
          server.uplink == null ? uplink : server.uplink! + uplink;
      final newDownlink =
          server.downlink == null ? downlink : server.downlink! + downlink;
      await serverDao.updateTraffic(server.id, newUplink, newDownlink);
      final serverNotifier = ref.read(serverNotifierProvider.notifier);
      serverNotifier.updateServer(
        server
          ..uplink = newUplink
          ..downlink = newDownlink,
        shouldUpdateLite: false,
      );
    }
  }
}
