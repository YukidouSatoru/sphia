import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/util/traffic/xray/command.pbgrpc.dart';

abstract class Traffic {
  int apiPort;

  Stream<Map<String, int>> get apiStream => apiStreamController.stream;
  final apiStreamController = StreamController<Map<String, int>>.broadcast();

  Traffic(this.apiPort);

  Future<void> start();

  Future<void> stop();

  Future<bool> isApiPortOpen() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final socket = await Socket.connect('localhost', apiPort,
          timeout: const Duration(seconds: 2));
      await socket.close();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}

class XrayTraffic extends Traffic {
  late ClientChannel channel;
  late StatsServiceClient client;
  final uplinkRequest = QueryStatsRequest()
    ..pattern = 'outbound>>>proxy>>>traffic>>>uplink';
  final downlinkRequest = QueryStatsRequest()
    ..pattern = 'outbound>>>proxy>>>traffic>>>downlink';
  int previousUplink = 0;
  int previousDownlink = 0;
  late Timer timer;

  XrayTraffic(apiPort) : super(apiPort) {
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
    logger.i('Starting XrayTraffic');
    if (!await isApiPortOpen()) {
      logger.e('Failed to get traffic: API port is not open');
      throw Exception('Failed to get traffic: API port is not open');
    }
    timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      try {
        final uplinkResponse = await client.queryStats(uplinkRequest);
        final downlinkResponse = await client.queryStats(downlinkRequest);

        final uplink =
            int.parse(uplinkResponse.writeToJsonMap()['1'][0]['2'] ?? '0');
        final downlink =
            int.parse(downlinkResponse.writeToJsonMap()['1'][0]['2'] ?? '0');

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
      } on Exception catch (e) {
        logger.e('Failed to get traffic: $e');
        timer.cancel();
        throw Exception('Failed to get traffic: $e');
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
}

class SingBoxTraffic extends Traffic {
  late Uri url;
  final client = HttpClient();
  int uplink = 0;
  int downlink = 0;
  late StreamSubscription<String> subscription;

  SingBoxTraffic(apiPort) : super(apiPort) {
    url = Uri.parse('http://localhost:$apiPort/traffic');
  }

  @override
  Future<void> start() async {
    logger.i('Starting SingBoxTraffic');
    if (!await isApiPortOpen()) {
      logger.e('Failed to get traffic: API port is not open');
      throw Exception('Failed to get traffic: API port is not open');
    }
    try {
      final request = await client.getUrl(url);
      final response = await request.close();
      if (response.statusCode != 200) {
        throw Exception('Failed to get traffic: ${response.statusCode}');
      }
      subscription = response.transform(utf8.decoder).listen((data) {
        final json = jsonDecode(data);
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
      });
    } on TimeoutException catch (_) {
      logger.e('Failed to get traffic: Timeout');
      throw Exception('Failed to get traffic: Timeout');
    } on SocketException catch (_) {
      logger.e('Failed to get traffic: SocketException');
      throw Exception('Failed to get traffic: SocketException');
    } on Exception catch (e) {
      logger.e('Failed to get traffic: $e');
      throw Exception('Failed to get traffic: $e');
    }
  }

  @override
  Future<void> stop() async {
    logger.i('Stopping SingBoxTraffic');
    await subscription.cancel();
    await apiStreamController.close();
    client.close();
  }
}
