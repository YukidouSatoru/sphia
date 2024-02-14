import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:grpc/grpc.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/util/traffic/xray/command.pbgrpc.dart';
import 'package:tuple/tuple.dart';

abstract class Traffic {
  int apiPort;

  Stream<Map<String, int>> get apiStream => apiStreamController.stream;
  final apiStreamController = StreamController<Map<String, int>>.broadcast();

  Traffic(this.apiPort);

  Future<void> start() async {
    await _ensureApiAvailability();
  }

  Future<void> stop();

  Future<void> _ensureApiAvailability() async {
    int tryCount = 0;
    await Future.doWhile(() async {
      final isApiAvailable = await checkAvailability();
      if (!isApiAvailable) {
        await Future.delayed(const Duration(milliseconds: 100));
        tryCount++;
      }
      if (tryCount > 10) {
        throw Exception('API is not available');
      }
      return !isApiAvailable;
    });
  }

  Future<bool> checkAvailability() async {
    try {
      final socket = await Socket.connect('localhost', apiPort);
      socket.destroy();
      return true;
    } on SocketException catch (_) {
      return false;
    }
  }
}

class XrayTraffic extends Traffic {
  late ClientChannel channel;
  late StatsServiceClient client;
  int previousUplink = 0;
  int previousDownlink = 0;
  late Timer timer;
  bool isMultiOutboundSupport;

  XrayTraffic(int apiPort, this.isMultiOutboundSupport) : super(apiPort) {
    channel = ClientChannel(
      'localhost',
      port: apiPort,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    client = StatsServiceClient(channel);
  }

  @override
  Future<void> start() async {
    await super.start();
    logger.i('Starting XrayTraffic');
    timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      try {
        late final int uplink;
        late final int downlink;
        if (!isMultiOutboundSupport) {
          uplink = await queryOutboundUplink('proxy');
          downlink = await queryOutboundDownlink('proxy');
        } else {
          final totalProxyLink = await queryTotalProxyLink();
          uplink = totalProxyLink.item1;
          downlink = totalProxyLink.item2;
        }

        final up = uplink - previousUplink;
        final down = downlink - previousDownlink;

        apiStreamController.add(<String, int>{
          '"uplink"': uplink,
          '"downlink"': downlink,
          '"up"': up,
          '"down"': down,
        });

        previousUplink = uplink;
        previousDownlink = downlink;
      } catch (_) {
        timer.cancel();
        rethrow;
      }
    });
  }

  @override
  Future<void> stop() async {
    logger.i('Stopping XrayTraffic');
    timer.cancel();
    await apiStreamController.close();
    await channel.shutdown();
  }

  Future<Tuple2<int, int>> queryTotalProxyLink() async {
    final uplinkRequest = QueryStatsRequest();
    final response = await client.queryStats(uplinkRequest);
    final stats = response.writeToJsonMap()['1'];
    int totalUplink = 0;
    int totalDownlink = 0;
    for (final stat in stats) {
      final name = stat['1'];
      final value = stat['2'];
      // ignore direct and block
      if (name.contains('direct') || name.contains('block')) {
        continue;
      }
      if (name.contains('uplink')) {
        totalUplink += int.parse(value ?? '0');
      } else if (name.contains('downlink')) {
        totalDownlink += int.parse(value ?? '0');
      }
    }
    return Tuple2(totalUplink, totalDownlink);
  }

  Future<Tuple2<int, int>> queryProxyLinkByOutboundTag(
      String outboundTag) async {
    final uplink = await queryOutboundUplink(outboundTag);
    final downlink = await queryOutboundDownlink(outboundTag);
    return Tuple2(uplink, downlink);
  }

  Future<int> queryOutboundUplink(String outboundTag) {
    final uplinkRequest = QueryStatsRequest()
      ..pattern = 'outbound>>>$outboundTag>>>traffic>>>uplink';
    return client.queryStats(uplinkRequest).then((response) {
      try {
        final uplink = int.tryParse(response.writeToJsonMap()['1'][0]['2']);
        if (uplink == null) {
          return 0;
        }
        return uplink;
      } catch (e) {
        logger.e('Failed to get uplink from $outboundTag: $e');
        return 0;
      }
    });
  }

  Future<int> queryOutboundDownlink(String outboundTag) {
    final downlinkRequest = QueryStatsRequest()
      ..pattern = 'outbound>>>$outboundTag>>>traffic>>>downlink';
    return client.queryStats(downlinkRequest).then((response) {
      try {
        final downlink = int.tryParse(response.writeToJsonMap()['1'][0]['2']);
        if (downlink == null) {
          return 0;
        }
        return downlink;
      } catch (e) {
        logger.e('Failed to get downlink from $outboundTag: $e');
        return 0;
      }
    });
  }
}

class SingBoxTraffic extends Traffic {
  late Uri url;
  final client = http.Client();
  StreamSubscription? subscription;
  int uplink = 0;
  int downlink = 0;

  SingBoxTraffic(int apiPort) : super(apiPort) {
    url = Uri.parse('http://localhost:$apiPort/traffic');
  }

  @override
  Future<void> start() async {
    await super.start();
    logger.i('Starting SingBoxTraffic');
    try {
      final request = http.Request('GET', url);
      final response = await client.send(request);
      if (response.statusCode != 200) {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
      subscription = response.stream.listen((data) async {
        final decoded = utf8.decode(data);
        final json = jsonDecode(decoded);
        final int up = json['up'] ?? 0;
        final int down = json['down'] ?? 0;
        uplink += up;
        downlink += down;
        apiStreamController.add(<String, int>{
          '"uplink"': uplink,
          '"downlink"': downlink,
          '"up"': up,
          '"down"': down,
        });
      }, onError: (e) {
        throw Exception('Failed to get response: $e');
      });
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> stop() async {
    logger.i('Stopping SingBoxTraffic');
    await subscription?.cancel();
    await apiStreamController.close();
    client.close();
  }
}
