import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sphia/app/notifier/config/sphia_config.dart';
import 'package:sphia/app/notifier/traffic.dart';
import 'package:sphia/app/notifier/visible.dart';
import 'package:sphia/app/state/traffic.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/card/dashboard_card/card.dart';
import 'package:sphia/view/card/dashboard_card/chart.dart';

class TrafficCard extends ConsumerStatefulWidget {
  const TrafficCard({
    super.key,
  });

  @override
  ConsumerState<TrafficCard> createState() => _TrafficCardState();
}

class _TrafficCardState extends ConsumerState<TrafficCard> {
  final ValueNotifier<int> uploadLastSecond = ValueNotifier<int>(0);
  final ValueNotifier<int> downloadLastSecond = ValueNotifier<int>(0);
  final ValueNotifier<int> totalUpload = ValueNotifier<int>(0);
  final ValueNotifier<int> totalDownload = ValueNotifier<int>(0);
  StreamSubscription? _trafficSubscription;

  void _trafficListener(TrafficState? previous, TrafficState next) {
    if (previous != null) {
      if (next.traffic != null) {
        _trafficSubscription?.cancel();
        final apiStream = next.traffic!.apiStream;
        _trafficSubscription = apiStream.listen((data) {
          uploadLastSecond.value = data.up;
          downloadLastSecond.value = data.down;
          totalUpload.value = data.uplink;
          totalDownload.value = data.downlink;
        });
      } else {
        _trafficSubscription?.cancel();
        uploadLastSecond.value = 0;
        downloadLastSecond.value = 0;
        totalUpload.value = 0;
        totalDownload.value = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(trafficNotifierProvider, _trafficListener);
    final visible = ref.watch(visibleNotifierProvider);
    final enableStatistics = ref.watch(
        sphiaConfigNotifierProvider.select((value) => value.enableStatistics));
    final cardTraffic = CardData(
      title: Text(S.of(context).traffic),
      icon: Icons.data_usage,
      widget: enableStatistics && visible
          ? ListView(
              children: [
                ListTile(
                  title: Text(S.of(context).upload),
                  subtitle: ValueListenableBuilder<int>(
                    valueListenable: totalUpload,
                    builder: (context, value, child) {
                      final totalUploadIdx = getUnit(totalUpload.value.toInt());
                      final showUpload =
                          totalUpload.value / unitRates[totalUploadIdx];
                      return Text(
                          '${showUpload.toStringAsFixed(1)} ${units[totalUploadIdx]}');
                    },
                  ),
                ),
                ListTile(
                  title: Text(S.of(context).download),
                  subtitle: ValueListenableBuilder<int>(
                    valueListenable: totalDownload,
                    builder: (context, value, child) {
                      final totalDownloadIdx =
                          getUnit(totalDownload.value.toInt());
                      final showDownload =
                          totalDownload.value / unitRates[totalDownloadIdx];
                      return Text(
                        '${showDownload.toStringAsFixed(1)} ${units[totalDownloadIdx]}',
                      );
                    },
                  ),
                ),
                ListTile(
                  title: Text(S.of(context).uploadSpeed),
                  subtitle: ValueListenableBuilder<int>(
                    valueListenable: uploadLastSecond,
                    builder: (context, value, child) {
                      final uploadLastSecondIdx =
                          getUnit(uploadLastSecond.value.toInt());
                      final showUploadSpeed = uploadLastSecond.value /
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
                    valueListenable: downloadLastSecond,
                    builder: (context, value, child) {
                      final downloadLastSecondIdx =
                          getUnit(downloadLastSecond.value.toInt());
                      final showDownloadSpeed = downloadLastSecond.value /
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
              child: IconButton(
                icon: const Icon(
                  Icons.block,
                  color: Colors.grey,
                ),
                tooltip: S.of(context).statisticsIsDisabled,
                onPressed: null,
              ),
            ),
    );
    return buildCard(cardTraffic);
  }
}
