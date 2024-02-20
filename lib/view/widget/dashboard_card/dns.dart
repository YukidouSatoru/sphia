import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/theme.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/widget/dashboard_card/card.dart';

class DnsCard extends StatefulWidget {
  const DnsCard({
    super.key,
  });

  @override
  State<DnsCard> createState() => _DnsCardState();
}

class _DnsCardState extends State<DnsCard> {
  @override
  Widget build(BuildContext context) {
    final sphiaConfigProvider = Provider.of<SphiaConfigProvider>(context);
    final sphiaConfig = sphiaConfigProvider.config;
    final dnsCard = CardData(
      title: Text(S.of(context).dns),
      icon: Icons.dns,
      widget: sphiaConfig.configureDns
          ? ListView(
              children: [
                ListTile(
                  shape: SphiaTheme.listTileShape(sphiaConfig.useMaterial3),
                  title: Text(S.of(context).remoteDns),
                  subtitle: Text(sphiaConfig.remoteDns),
                  onTap: () async {
                    TextEditingController remoteDnsController =
                        TextEditingController();
                    remoteDnsController.text = sphiaConfig.remoteDns;
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
                                sphiaConfig.remoteDns =
                                    remoteDnsController.text;
                                sphiaConfigProvider.saveConfig();
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
                  shape: SphiaTheme.listTileShape(sphiaConfig.useMaterial3),
                  title: Text(S.of(context).directDns),
                  subtitle: Text(sphiaConfig.directDns),
                  onTap: () async {
                    TextEditingController directDnsController =
                        TextEditingController();
                    directDnsController.text = sphiaConfig.directDns;
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
                                sphiaConfig.directDns =
                                    directDnsController.text;
                                sphiaConfigProvider.saveConfig();
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
