import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sphia/app/notifier/config/sphia_config.dart';
import 'package:sphia/app/theme.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/card/dashboard_card/card.dart';

class DnsCard extends ConsumerWidget {
  const DnsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configureDns = ref.watch(
        sphiaConfigNotifierProvider.select((value) => value.configureDns));
    final useMaterial3 = ref.watch(
        sphiaConfigNotifierProvider.select((value) => value.useMaterial3));
    final remoteDns = ref
        .watch(sphiaConfigNotifierProvider.select((value) => value.remoteDns));
    final directDns = ref
        .watch(sphiaConfigNotifierProvider.select((value) => value.directDns));
    final dnsCard = CardData(
      title: Text(S.of(context).dns),
      icon: Icons.dns,
      widget: configureDns
          ? ListView(
              children: [
                ListTile(
                  shape: SphiaTheme.listTileShape(useMaterial3),
                  title: Text(S.of(context).remoteDns),
                  subtitle: Text(remoteDns),
                  onTap: () async {
                    final remoteDnsController = TextEditingController();
                    remoteDnsController.text = remoteDns;
                    await showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(S.of(context).remoteDns),
                          content: TextFormField(
                            controller: remoteDnsController,
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(S.of(context).cancel),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(S.of(context).save),
                              onPressed: () {
                                final notifier = ref
                                    .read(sphiaConfigNotifierProvider.notifier);
                                notifier.updateValue(
                                  'remoteDns',
                                  remoteDnsController.text,
                                );
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  shape: SphiaTheme.listTileShape(useMaterial3),
                  title: Text(S.of(context).directDns),
                  subtitle: Text(directDns),
                  onTap: () async {
                    final directDnsController = TextEditingController();
                    directDnsController.text = directDns;
                    await showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(S.of(context).directDns),
                          content: TextFormField(
                            controller: directDnsController,
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(S.of(context).cancel),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(S.of(context).save),
                              onPressed: () {
                                final notifier = ref
                                    .read(sphiaConfigNotifierProvider.notifier);
                                notifier.updateValue(
                                  'directDns',
                                  directDnsController.text,
                                );
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            )
          : Center(
              child: Text(
                S.of(context).dnsIsNotConfigured,
              ),
            ),
    );

    return buildCard(dnsCard);
  }
}
