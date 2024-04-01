import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/card/dashboard_card/dns.dart';
import 'package:sphia/view/card/dashboard_card/net.dart';
import 'package:sphia/view/card/dashboard_card/rule_group.dart';
import 'package:sphia/view/card/dashboard_card/running_cores.dart';
import 'package:sphia/view/card/dashboard_card/traffic.dart';
import 'package:sphia/view/wrapper/page.dart';

class Dashboard extends ConsumerWidget {
  final _cardRunningCores = const RunningCoresCard();
  final _cardRuleGroup = const RuleGroupCard();
  final _cardDns = const DnsCard();
  final _cardTraffic = const TrafficCard();
  final _cardNet = const NetCard();

  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).dashboard),
        elevation: 0,
      ),
      body: PageWrapper(
        padding: dashboardPadding,
        child: Column(
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 3,
                    child: Row(
                      children: [
                        const SizedBox(width: edgehorizontalSpacing),
                        Flexible(child: _cardRunningCores),
                        const SizedBox(width: cardhorizontalSpacing),
                        Flexible(child: _cardRuleGroup),
                        const SizedBox(width: cardhorizontalSpacing),
                        Flexible(child: _cardDns),
                        const SizedBox(width: edgehorizontalSpacing),
                      ],
                    ),
                  ),
                  const SizedBox(height: cardVerticalSpacing),
                  Flexible(
                    flex: 4,
                    child: Row(
                      children: [
                        const SizedBox(width: edgehorizontalSpacing),
                        Flexible(flex: 2, child: _cardTraffic),
                        const SizedBox(width: cardhorizontalSpacing),
                        Flexible(flex: 7, child: _cardNet),
                        const SizedBox(width: edgehorizontalSpacing),
                      ],
                    ),
                  ),
                  const SizedBox(height: edgeVerticalSpacing),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
