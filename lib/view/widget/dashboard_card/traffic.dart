import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/widget/dashboard_card/card.dart';
import 'package:sphia/view/widget/dashboard_card/chart.dart';
import 'package:window_manager/window_manager.dart';

class TrafficCard extends StatefulWidget {
  final ValueNotifier<int> uploadLastSecond = ValueNotifier<int>(0);
  final ValueNotifier<int> downloadLastSecond = ValueNotifier<int>(0);
  final ValueNotifier<int> totalUpload = ValueNotifier<int>(0);
  final ValueNotifier<int> totalDownload = ValueNotifier<int>(0);

  TrafficCard({
    super.key,
  });

  @override
  State<TrafficCard> createState() => _TrafficCardState();
}

class _TrafficCardState extends State<TrafficCard> with WindowListener {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sphiaConfigProvider = Provider.of<SphiaConfigProvider>(context);
    final sphiaConfig = sphiaConfigProvider.config;
    final cardTraffic = CardData(
      title: Text(S.of(context).traffic),
      icon: Icons.data_usage,
      widget: sphiaConfig.enableStatistics && _isVisible
          ? ListView(
              children: [
                ListTile(
                  title: Text(S.of(context).upload),
                  subtitle: ValueListenableBuilder<int>(
                    valueListenable: widget.totalUpload,
                    builder: (context, value, child) {
                      final totalUploadIdx =
                          _getUnit(widget.totalUpload.value.toInt());
                      final showUpload =
                          widget.totalUpload.value / unitRates[totalUploadIdx];
                      return Text(
                          '${showUpload.toStringAsFixed(1)} ${units[totalUploadIdx]}');
                    },
                  ),
                ),
                ListTile(
                  title: Text(S.of(context).download),
                  subtitle: ValueListenableBuilder<int>(
                    valueListenable: widget.totalDownload,
                    builder: (context, value, child) {
                      final totalDownloadIdx =
                          _getUnit(widget.totalDownload.value.toInt());
                      final showDownload = widget.totalDownload.value /
                          unitRates[totalDownloadIdx];
                      return Text(
                        '${showDownload.toStringAsFixed(1)} ${units[totalDownloadIdx]}',
                      );
                    },
                  ),
                ),
                ListTile(
                  title: Text(S.of(context).uploadSpeed),
                  subtitle: ValueListenableBuilder<int>(
                    valueListenable: widget.uploadLastSecond,
                    builder: (context, value, child) {
                      final uploadLastSecondIdx =
                          _getUnit(widget.uploadLastSecond.value.toInt());
                      final showUploadSpeed = widget.uploadLastSecond.value /
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
                    valueListenable: widget.downloadLastSecond,
                    builder: (context, value, child) {
                      final downloadLastSecondIdx =
                          _getUnit(widget.downloadLastSecond.value.toInt());
                      final showDownloadSpeed =
                          widget.downloadLastSecond.value /
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
    return buildCard(cardTraffic);
  }

  int _getUnit(int byte) {
    int ret = 0;
    for (int idx = 0; idx < 5; idx++) {
      if (byte > unitRates[idx]) {
        ret = idx;
      }
    }
    return ret;
  }

  @override
  void onWindowFocus() {
    setState(() {
      _isVisible = true;
    });
  }

  @override
  void onWindowClose() {
    setState(() {
      _isVisible = false;
    });
  }
}
