import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sphia/app/provider/core.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/util/network.dart';
import 'package:sphia/view/widget/dashboard_card/card.dart';
import 'package:sphia/view/widget/dashboard_card/chart.dart';

class NetCard extends StatefulWidget {
  final NetworkChart networkChart;

  const NetCard({
    super.key,
    required this.networkChart,
  });

  @override
  State<NetCard> createState() => _NetCardState();
}

class _NetCardState extends State<NetCard> {
  bool _previousCoreRunning = false;
  String _currentIp = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final configProvider =
          Provider.of<SphiaConfigProvider>(context, listen: false);
      if (configProvider.config.autoGetIp) {
        setState(() {
          _currentIp = S.of(context).gettingIp;
        });
        final ip = await NetworkUtil.getIp();
        setState(() {
          _currentIp = ip;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sphiaConfigProvider = Provider.of<SphiaConfigProvider>(context);
    final sphiaConfig = sphiaConfigProvider.config;
    final coreProvider = Provider.of<CoreProvider>(context);

    final cardNet = CardData(
      title: Row(
        children: [
          Text(
            sphiaConfig.autoGetIp
                ? '${S.of(context).currentIp}: ${_currentIp.isNotEmpty ? _currentIp : S.of(context).getIpFailed}'
                : S.of(context).speed,
          ),
          const Spacer(),
          sphiaConfig.autoGetIp
              ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentIp = S.of(context).gettingIp;
                    });
                    (() async {
                      late final String ip;
                      ip = await NetworkUtil.getIp();
                      setState(() {
                        _currentIp = ip;
                      });
                    })();
                  },
                  child: Text(S.of(context).refresh),
                )
              : const SizedBox.shrink(),
        ],
      ),
      icon: Icons.near_me,
      widget: Column(
        children: [
          Expanded(
            child: Center(
              child: ClipRect(child: widget.networkChart),
            ),
          ),
        ],
      ),
    );

    if (coreProvider.coreRunning != _previousCoreRunning) {
      if (sphiaConfig.autoGetIp) {
        setState(() {
          _currentIp = S.of(context).gettingIp;
        });
        (() async {
          late final String ip;
          ip = await NetworkUtil.getIp();
          setState(() {
            _currentIp = ip;
          });
        })();
      }
      _previousCoreRunning = coreProvider.coreRunning;
    }

    return buildCard(cardNet);
  }
}
