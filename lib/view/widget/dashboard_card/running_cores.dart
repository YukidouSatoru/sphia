import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sphia/app/provider/core.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/theme.dart';
import 'package:sphia/core/helper.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/widget/dashboard_card/card.dart';
import 'package:url_launcher/url_launcher.dart';

class RunningCoresCard extends StatefulWidget {
  const RunningCoresCard({
    super.key,
  });

  @override
  State<RunningCoresCard> createState() => _RunningCoresCardState();
}

class _RunningCoresCardState extends State<RunningCoresCard> {
  @override
  Widget build(BuildContext context) {
    final sphiaConfigProvider = Provider.of<SphiaConfigProvider>(context);
    final sphiaConfig = sphiaConfigProvider.config;
    final coreProvider = Provider.of<CoreProvider>(context);
    final runningCoresCard = CardData(
      title: Row(
        children: [
          Text(S.of(context).runningCores),
          const Spacer(),
          Align(
            heightFactor: 0.5,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                children: [
                  const Text('Tun  '),
                  CircleAvatar(
                    radius: 5,
                    backgroundColor:
                        coreProvider.tunMode ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      icon: Icons.memory,
      widget: coreProvider.coreRunning
          ? ListView.builder(
              itemCount: coreProvider.cores.length,
              itemBuilder: (BuildContext context, int index) {
                final coreName = coreProvider.cores[index].name;
                return ListTile(
                  shape: SphiaTheme.listTileShape(sphiaConfig.useMaterial3),
                  title: Text(coreName),
                  onTap: () async {
                    final servers = coreProvider.cores[index].servers;
                    final serverRemarks = servers.map((e) => e.remark).toList();
                    if (!context.mounted) {
                      return;
                    }
                    await showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        String repoUrl = coreRepositories[coreName]!;
                        return AlertDialog(
                          scrollable: true,
                          title: Text(coreName),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Expanded(child: Divider()),
                                  Text(S.of(context).repoUrl),
                                  const Expanded(child: Divider()),
                                ],
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: repoUrl,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          await launchUrl(Uri.parse(repoUrl));
                                        },
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  const Expanded(child: Divider()),
                                  Text(S.of(context).runningServer),
                                  const Expanded(child: Divider()),
                                ],
                              ),
                              // all running servers
                              for (var remark in serverRemarks) Text(remark),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            )
          : Center(
              child: Text(
                S.of(context).noRunningCores,
              ),
            ),
    );

    return buildCard(runningCoresCard);
  }
}
