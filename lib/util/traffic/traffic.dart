import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:http/http.dart' as http;
import 'package:sphia/app/log.dart';
import 'package:sphia/util/traffic/xray/command.pbgrpc.dart';
import 'package:tuple/tuple.dart';

class TrafficData {
  final int uplink;
  final int downlink;
  final int up;
  final int down;

  TrafficData(this.uplink, this.downlink, this.up, this.down);
}

abstract class Traffic {
  int apiPort;
  int uplink = 0;
  int downlink = 0;

  final _apiStreamController = StreamController<TrafficData>.broadcast();

  Stream<TrafficData> get apiStream => _apiStreamController.stream;

  Traffic(this.apiPort);

  Future<void> start() async {
    await _ensureApiAvailability();
  }

  Future<void> stop();

  Future<void> _ensureApiAvailability() async {
    int tryCount = 0;
    await Future.doWhile(() async {
      final isApiAvailable = await _checkAvailability();
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

  Future<bool> _checkAvailability() async {
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
  late ClientChannel _channel;
  late StatsServiceClient _client;
  late Timer _timer;
  final bool _isMultiOutboundSupport;

  XrayTraffic(int apiPort, this._isMultiOutboundSupport) : super(apiPort) {
    _channel = ClientChannel(
      'localhost',
      port: apiPort,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    _client = StatsServiceClient(_channel);
  }

  @override
  Future<void> start() async {
    await super.start();
    logger.i('Starting XrayTraffic');
    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      try {
        late final int curUplink;
        late final int curDownlink;
        if (!_isMultiOutboundSupport) {
          curUplink = await queryOutboundUplink('proxy');
          curDownlink = await queryOutboundDownlink('proxy');
        } else {
          final totalProxyLink = await queryTotalProxyLink();
          curUplink = totalProxyLink.item1;
          curDownlink = totalProxyLink.item2;
        }

        final up = curUplink - uplink;
        final down = curDownlink - downlink;

        _apiStreamController.add(TrafficData(uplink, downlink, up, down));

        uplink = curUplink;
        downlink = curDownlink;
      } catch (_) {
        _timer.cancel();
        rethrow;
      }
    });
  }

  @override
  Future<void> stop() async {
    logger.i('Stopping XrayTraffic');
    _timer.cancel();
    await _apiStreamController.close();
    await _channel.shutdown();
  }

  Future<Tuple2<int, int>> queryTotalProxyLink() async {
    final uplinkRequest = QueryStatsRequest();
    final response = await _client.queryStats(uplinkRequest);
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
    return _client.queryStats(uplinkRequest).then((response) {
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
    return _client.queryStats(downlinkRequest).then((response) {
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
  late Uri _url;
  final _client = http.Client();
  late StreamSubscription _subscription;

  SingBoxTraffic(int apiPort) : super(apiPort) {
    _url = Uri.parse('http://localhost:$apiPort/traffic');
  }

  @override
  Future<void> start() async {
    await super.start();
    logger.i('Starting SingBoxTraffic');
    try {
      final request = http.Request('GET', _url);
      final response = await _client.send(request);
      if (response.statusCode != 200) {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
      _subscription = response.stream.listen((data) async {
        final decoded = utf8.decode(data);
        final json = jsonDecode(decoded);
        final int up = json['up'] ?? 0;
        final int down = json['down'] ?? 0;
        uplink += up;
        downlink += down;
        _apiStreamController.add(TrafficData(uplink, downlink, up, down));
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
    await _subscription.cancel();
    await _apiStreamController.close();
    _client.close();
  }
}
