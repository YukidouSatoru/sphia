import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/core.dart';
import 'package:sphia/app/provider/sphia_config.dart';

const List<String> units = [' B', 'KB', 'MB', 'GB', 'TB', 'EB'];
const List<int> unitRates = [
  1,
  1024,
  1048576,
  1073741824,
  1099511627776,
  1125899906842624
];

class NetworkChart extends StatefulWidget {
  final uploadSpots = <FlSpot>[];
  final downloadSpots = <FlSpot>[];

  NetworkChart({
    super.key,
  });

  @override
  State<NetworkChart> createState() => _NetworkChartState();
}

class _NetworkChartState extends State<NetworkChart> {
  late SphiaConfigProvider _sphiaConfigProvider;
  late CoreProvider _coreProvider;
  Timer? _timer;
  double _maxY = 0;
  int _unitIndex = 0;

  @override
  void initState() {
    super.initState();
    _sphiaConfigProvider =
        Provider.of<SphiaConfigProvider>(context, listen: false);
    _coreProvider = Provider.of<CoreProvider>(context, listen: false);
    _sphiaConfigProvider.addListener(_shouldStartTimer);
    _coreProvider.addListener(_shouldStartTimer);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_timer != null) {
      return;
    }
    logger.i('Start speed chart timer');
    // just keep lastest 60s
    _timer = Timer.periodic(const Duration(milliseconds: 25), (timer) {
      final nowStamp = DateTime.now().millisecondsSinceEpoch;
      setState(() {
        final double maxUploadY =
            widget.uploadSpots.fold(0, (maxY, spot) => max(maxY, spot.y));
        final double maxDownloadY =
            widget.downloadSpots.fold(0, (maxY, spot) => max(maxY, spot.y));
        final double axisY = max(maxUploadY, maxDownloadY);
        _maxY = axisY;
        _unitIndex = axisY > 1024 ? (log(axisY) / log(1024)).floor() : 0;
        widget.uploadSpots
            .removeWhere((element) => nowStamp - element.x > 60000);
        widget.downloadSpots
            .removeWhere((element) => nowStamp - element.x > 60000);
      });
    });
  }

  void _stopTimer() {
    if (_timer == null) {
      return;
    }
    logger.i('Stop speed chart timer');
    _timer?.cancel();
    _timer = null;
    setState(() {
      widget.uploadSpots.clear();
      widget.downloadSpots.clear();
      _maxY = 0;
    });
  }

  void _shouldStartTimer() {
    if (_coreProvider.coreRunning &&
        _sphiaConfigProvider.config.enableStatistics &&
        _sphiaConfigProvider.config.enableSpeedChart) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  // TODO: ugly
  @override
  Widget build(BuildContext context) {
    final nowStamp = DateTime.now().millisecondsSinceEpoch;
    return LineChart(
      LineChartData(
        lineTouchData: const LineTouchData(enabled: false),
        maxX: nowStamp.toDouble() + 100,
        minX: nowStamp.toDouble() - 60100,
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
                  child: const Text(""), // TODO: fix?
                  // Text('${(nowStamp - value) ~/ 1000}s'),
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
            show: widget.uploadSpots.isNotEmpty,
            dotData: const FlDotData(show: false),
            color: Colors.green,
            spots: widget.uploadSpots,
          ),
          LineChartBarData(
            show: widget.downloadSpots.isNotEmpty,
            dotData: const FlDotData(show: false),
            color: Colors.blue,
            spots: widget.downloadSpots,
          ),
        ],
      ),
      duration: const Duration(milliseconds: 16),
    );
  }
}
