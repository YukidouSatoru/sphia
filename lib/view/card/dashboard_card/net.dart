import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/notifier/config/sphia_config.dart';
import 'package:sphia/app/notifier/proxy.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/util/network.dart';
import 'package:sphia/view/card/dashboard_card/card.dart';
import 'package:sphia/view/card/dashboard_card/chart.dart';

part 'net.g.dart';

@riverpod
class CurrentIpNotifier extends _$CurrentIpNotifier {
  @override
  Future<String> build() async {
    final networkUtil = ref.read(networkUtilProvider.notifier);
    return await networkUtil.getIp();
  }

  Future<void> refresh() async {
    final networkUtil = ref.read(networkUtilProvider.notifier);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await networkUtil.getIp();
    });
  }
}

class NetCard extends ConsumerWidget {
  const NetCard({
    super.key,
  });

  Widget _buildIpText(BuildContext context, WidgetRef ref) {
    ref.listen(proxyNotifierProvider, (previous, next) {
      if (previous != null) {
        if (previous.coreRunning != next.coreRunning) {
          ref.read(currentIpNotifierProvider.notifier).refresh();
        }
      }
    });
    final currentIp = ref.watch(currentIpNotifierProvider);
    return currentIp.when(
      data: (data) {
        return Text('${S.of(context).currentIp}: $data');
      },
      loading: () {
        return Text(S.of(context).gettingIp);
      },
      error: (error, _) {
        return Text(S.of(context).getIpFailed);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoGetIp = ref
        .watch(sphiaConfigNotifierProvider.select((value) => value.autoGetIp));
    final cardNet = CardData(
      title: Row(
        children: [
          autoGetIp ? _buildIpText(context, ref) : Text(S.of(context).speed),
          const Spacer(),
          autoGetIp
              ? Align(
                  heightFactor: 0.5,
                  child: ElevatedButton(
                    onPressed: () async {
                      await ref
                          .read(currentIpNotifierProvider.notifier)
                          .refresh();
                    },
                    child: Text(S.of(context).refresh),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
      icon: Icons.near_me,
      widget: const Column(
        children: [
          Expanded(
            child: Center(
              child: ClipRect(
                child: NetworkChart(),
              ),
            ),
          ),
        ],
      ),
    );
    return buildCard(cardNet);
  }
}
