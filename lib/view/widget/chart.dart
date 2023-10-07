import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sphia/app/provider/core.dart';
import 'package:sphia/app/provider/sphia_config.dart';

const List<String> unit = [' B', 'KB', 'MB', 'GB', 'TB', 'EB'];
const List<int> unitRate = [
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
    Key? key,
  }) : super(key: key);

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
    // just keep lastest 60s
    _timer = Timer.periodic(const Duration(milliseconds: 25), (timer) {
      final nowStamp = DateTime.now().millisecondsSinceEpoch;
      setState(() {
        double axisY = [
          ...widget.uploadSpots,
          ...widget.downloadSpots,
        ].fold(0, (maxY, spot) => max(maxY, spot.y));
        _maxY = axisY;
        _unitIndex = 0;
        while (axisY > 1024) {
          axisY /= 1024;
          _unitIndex += 1;
        }
        widget.uploadSpots
            .removeWhere((element) => nowStamp - element.x > 60000);
        widget.downloadSpots
            .removeWhere((element) => nowStamp - element.x > 60000);
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    widget.uploadSpots.clear();
    widget.downloadSpots.clear();
  }

  void _shouldStartTimer() {
    if (_sphiaConfigProvider.config.enableStatistics &&
        _coreProvider.coreRunning &&
        _sphiaConfigProvider.config.enableSpeedChart &&
        _timer == null) {
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
                      '${(value / unitRate[_unitIndex]).toStringAsFixed(1)} ${unit[_unitIndex]}'),
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
                      '${(value / unitRate[_unitIndex]).toStringAsFixed(1)} ${unit[_unitIndex]}'),
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
