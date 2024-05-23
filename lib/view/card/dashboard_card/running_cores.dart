import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/notifier/config/sphia_config.dart';
import 'package:sphia/app/notifier/core_state.dart';
import 'package:sphia/app/notifier/proxy.dart';
import 'package:sphia/app/theme.dart';
import 'package:sphia/core/helper.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/card/dashboard_card/card.dart';
import 'package:url_launcher/url_launcher.dart';

class RunningCoresCard extends ConsumerWidget {
  const RunningCoresCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useMaterial3 = ref.watch(
        sphiaConfigNotifierProvider.select((value) => value.useMaterial3));
    final cores = ref.watch(coreStateNotifierProvider);
    final tunMode =
        ref.watch(proxyNotifierProvider.select((value) => value.tunMode));
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
                    backgroundColor: tunMode
                        ? const Color.fromARGB(255, 118, 255, 3)
                        : Colors.brown,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      icon: Icons.memory,
      widget: cores.when(
        data: (coreState) {
          final cores = coreState.cores;
          if (cores.isEmpty) {
            return Center(
              child: IconButton(
                icon: const Icon(
                  Icons.block,
                  color: Colors.grey,
                ),
                tooltip: S.of(context).noRunningCores,
                onPressed: null,
              ),
            );
          }
          return ListView.builder(
            itemCount: cores.length,
            itemBuilder: (BuildContext context, int index) {
              final coreName = cores[index].name;
              return ListTile(
                shape: SphiaTheme.listTileShape(useMaterial3),
                title: Text(coreName),
                onTap: () async {
                  final servers = cores[index].servers;
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
          );
        },
        error: (error, stackTrace) {
          logger.e('Failed to get running cores: $error\n$stackTrace');
          return Center(
            child: IconButton(
              icon: const Icon(
                Icons.block,
                color: Colors.grey,
              ),
              tooltip: S.of(context).noRunningCores,
              onPressed: null,
            ),
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );

    return buildCard(runningCoresCard);
  }
}
