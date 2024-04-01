import 'dart:async';
import 'dart:math' show max;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/notifier/config/sphia_config.dart';
import 'package:sphia/app/notifier/traffic.dart';
import 'package:sphia/app/notifier/visible.dart';
import 'package:sphia/app/state/traffic.dart';

const List<String> units = [' B', 'KB', 'MB', 'GB', 'TB', 'EB'];
const List<int> unitRates = [
  1,
  1024,
  1048576,
  1073741824,
  1099511627776,
  1125899906842624
];

int getUnit(int byte) {
  if (byte < unitRates[1]) {
    return 0;
  } else if (byte < unitRates[2]) {
    return 1;
  } else if (byte < unitRates[3]) {
    return 2;
  } else if (byte < unitRates[4]) {
    return 3;
  } else {
    return 4;
  }
}

class NetworkChart extends ConsumerStatefulWidget {
  const NetworkChart({super.key});

  @override
  ConsumerState<NetworkChart> createState() => _NetworkChartState();
}

class _NetworkChartState extends ConsumerState<NetworkChart> {
  Timer? _yAxisTimer;

  double _maxY = 0;
  int _unitIndex = 0;
  final _uploadSpots = <FlSpot>[];
  final _downloadSpots = <FlSpot>[];
  int _countFlip = 0;
  double _maxUploadY = 0;
  double _maxDownloadY = 0;

  StreamSubscription? _trafficSubscription;
  double _up = 0.0;
  double _down = 0.0;

  void _startTimer() {
    if (_yAxisTimer != null) {
      return;
    }
    logger.i('Starting speed chart timer');
    // just keep lastest 60s
    _yAxisTimer = Timer.periodic(const Duration(milliseconds: 25), (timer) {
      final nowStamp = DateTime.now().millisecondsSinceEpoch;
      if (_countFlip == 0) {
        _uploadSpots.add(FlSpot(nowStamp.toDouble(), _up.toDouble()));
        _downloadSpots.add(FlSpot(nowStamp.toDouble(), _down.toDouble()));
        if (_downloadSpots.length >= 59) {
          _downloadSpots.removeAt(0);
          _uploadSpots.removeAt(0);
        }
        _maxUploadY = _uploadSpots.fold(0, (maxY, spot) => max(maxY, spot.y));
        _maxDownloadY =
            _downloadSpots.fold(0, (maxY, spot) => max(maxY, spot.y));
      }
      _countFlip = (_countFlip == 40 ? 0 : _countFlip + 1);
      setState(() {
        final double axisY = max(_maxUploadY, _maxDownloadY);
        _maxY = axisY / 4 * 5;
        _unitIndex = getUnit(axisY.toInt());
      });
    });
  }

  void _stopTimer() {
    if (_yAxisTimer == null) {
      return;
    }
    logger.i('Stopping speed chart timer');
    _yAxisTimer?.cancel();
    _yAxisTimer = null;
  }

  void _trafficListener(TrafficState? previous, TrafficState next) {
    if (previous != null) {
      if (next.traffic != null) {
        _trafficSubscription?.cancel();
        final enableStatistics = ref.read(sphiaConfigNotifierProvider
            .select((value) => value.enableStatistics));
        if (!enableStatistics) {
          return;
        }
        final apiStream = next.traffic!.apiStream;
        _trafficSubscription = apiStream.listen((data) {
          _up = data.up.toDouble();
          _down = data.down.toDouble();
        });
        final enableSpeedChart = ref.read(sphiaConfigNotifierProvider
            .select((value) => value.enableSpeedChart));
        if (enableSpeedChart) {
          _startTimer();
        } else {
          _stopTimer();
          _clearSpots();
        }
      } else {
        _stopTimer();
        _clearSpots();
      }
    }
  }

  void _visibleListener(bool? previous, bool next) {
    if (previous != null) {
      final trafficRunning = ref.read(
          trafficNotifierProvider.select((value) => value.traffic != null));
      if (!trafficRunning) {
        return;
      }
      if (!next) {
        _stopTimer();
      } else {
        final enableSpeedChart = ref.read(sphiaConfigNotifierProvider
            .select((value) => value.enableSpeedChart));
        if (enableSpeedChart) {
          _startTimer();
        }
      }
    }
  }

  void _clearSpots() {
    logger.i('Clearing speed chart spots');
    _trafficSubscription?.cancel();
    setState(() {
      _up = 0;
      _down = 0;
      _uploadSpots.clear();
      _downloadSpots.clear();
      _maxY = 0;
      _unitIndex = 0;
      _countFlip = 0;
      _maxUploadY = 0;
      _maxDownloadY = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(trafficNotifierProvider, _trafficListener);
    ref.listen(visibleNotifierProvider, _visibleListener);
    final nowStamp = DateTime.now().millisecondsSinceEpoch;
    return LineChart(
      LineChartData(
        lineTouchData: const LineTouchData(enabled: false),
        maxX: nowStamp.toDouble() + 50,
        minX: nowStamp.toDouble() - 60050,
        maxY: _maxY,
        minY: 0,
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            axisNameWidget: SizedBox(),
          ), // wait for l10n
          // left axis
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: _maxY != 0 ? _maxY / 4 : null,
              showTitles: true,
              reservedSize: 80,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 0,
                  child: Text(
                      '${(value / unitRates[_unitIndex]).toStringAsFixed(1)} ${units[_unitIndex]}/s'),
                );
              },
            ),
          ),
          // right axis
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: _maxY != 0 ? _maxY / 4 : null,
              showTitles: true,
              reservedSize: 80,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 0,
                  child: Text(
                      '${(value / unitRates[_unitIndex]).toStringAsFixed(1)} ${units[_unitIndex]}/s'),
                );
              },
            ),
          ),
          // bottom axis
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 5,
                  child: const Text(""),
                );
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(
          border: const Border(
            bottom: BorderSide(color: Colors.blueGrey),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            show: _uploadSpots.isNotEmpty,
            dotData: const FlDotData(show: false),
            color: Colors.green,
            spots: _uploadSpots,
          ),
          LineChartBarData(
            show: _downloadSpots.isNotEmpty,
            dotData: const FlDotData(show: false),
            color: Colors.blue,
            spots: _downloadSpots,
          ),
        ],
      ),
      duration: const Duration(milliseconds: 16),
    );
  }
}
