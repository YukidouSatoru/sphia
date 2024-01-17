import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/version_config.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/util/network.dart';
import 'package:sphia/util/system.dart';
import 'package:sphia/view/page/agent/update.dart';
import 'package:sphia/view/page/wrapper.dart';
import 'package:sphia/view/widget/widget.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final Map<String, String> _latestVersions = {};
  final _agent = UpdateAgent();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final versionConfigProvider = Provider.of<VersionConfigProvider>(context);
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).update),
          elevation: 0,
        ),
        body: PageWrapper(
          child: ListView.builder(
            itemCount: coreRepositories.length - 1,
            itemBuilder: (BuildContext context, int index) {
              final coreName = coreRepositories.keys.elementAt(index);
              final repoUrl = coreRepositories.values.elementAt(index);
              final latestVersion = _latestVersions[coreName];
              final currentVersion = versionConfigProvider.getVersion(coreName);
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  title: Text(coreName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: '${S.of(context).repoUrl}: $repoUrl',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              try {
                                await launchUrl(Uri.parse(repoUrl));
                              } on Exception catch (e) {
                                logger.e('Failed to launch url: $e');
                                if (!context.mounted) {
                                  return;
                                }
                                await SphiaWidget.showDialogWithMsg(
                                  context,
                                  '${S.of(context).launchUrlFailed}: $e',
                                );
                              }
                            },
                        ),
                      ),
                      if (currentVersion != null) ...[
                        Text('${S.of(context).currentVersion}: $currentVersion')
                      ],
                      if (latestVersion != null) ...[
                        Text('${S.of(context).latestVersion}: $latestVersion')
                      ],
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () async =>
                            await _checkUpdate(coreName, true),
                        child: Text(S.of(context).checkUpdate),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async =>
                            await _updateCore(coreName, currentVersion),
                        child: Text(S.of(context).update),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _checkUpdate(String coreName, bool shouldShowDialog) async {
    final versionConfigProvider =
        Provider.of<VersionConfigProvider>(context, listen: false);
    final coreExists = SystemUtil.coreExists(coreName);
    if (!coreExists) {
      setState(() {
        versionConfigProvider.removeVersion(coreName);
      });
    }
    if (coreName == 'hysteria') {
      if (versionConfigProvider.getVersion(coreName) == hysteriaLatestVersion &&
          coreExists) {
        await SphiaWidget.showDialogWithMsg(
          context,
          '${S.of(context).alreadyLatestVersion}: $coreName',
        );
        return;
      }
      logger.i('Latest version of hysteria: $hysteriaLatestVersion');
      setState(() {
        _latestVersions['hysteria'] = hysteriaLatestVersion;
      });
      if (shouldShowDialog) {
        await SphiaWidget.showDialogWithMsg(
          context,
          '${S.of(context).latestVersion}: hysteria $hysteriaLatestVersion',
        );
      }
      return;
    }
    logger.i('Checking update: $coreName');
    try {
      try {
        // check github connection
        await NetworkUtil.getHttpResponse('https://github.com').timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw Exception('Connection timed out'));
      } on Exception catch (e) {
        logger.e('Failed to connect to Github: $e');
        if (!context.mounted) {
          return;
        }
        await SphiaWidget.showDialogWithMsg(
          context,
          '${S.of(context).connectToGithubFailed}: $e',
        );
        return;
      }
      final latestVersion = await NetworkUtil.getLatestVersion(coreName);
      if (!context.mounted) {
        return;
      }
      logger.i('Latest version of $coreName: $latestVersion');
      if (versionConfigProvider.getVersion(coreName) == latestVersion &&
          coreExists) {
        await SphiaWidget.showDialogWithMsg(
          context,
          '${S.of(context).alreadyLatestVersion}: $coreName',
        );
      } else {
        setState(() {
          _latestVersions[coreName] = latestVersion;
        });
        if (shouldShowDialog) {
          await SphiaWidget.showDialogWithMsg(
            context,
            '${S.of(context).latestVersion}: $coreName $latestVersion',
          );
        }
      }
    } on Exception catch (e) {
      logger.e('Failed to check update: $e');
      if (!context.mounted) {
        return;
      }
      await SphiaWidget.showDialogWithMsg(
        context,
        '${S.of(context).checkUpdateFailed}: $e',
      );
      return;
    }
  }

  Future<void> _updateCore(String coreName, String? currentVersion) async {
    if (!_latestVersions.containsKey(coreName) ||
        _latestVersions[coreName] == null) {
      await _checkUpdate(coreName, false);
    }
    final latestVersion = _latestVersions[coreName];
    if (latestVersion != null) {
      if (latestVersion == currentVersion) {
        return;
      }
      try {
        await _agent.updateCore(coreName, latestVersion);
      } on Exception catch (e) {
        if (!context.mounted) {
          return;
        }
        await SphiaWidget.showDialogWithMsg(
          context,
          '${S.of(context).updateFailed}: $e',
        );
      }
      if (!context.mounted) {
        return;
      }
      _latestVersions.remove(coreName);
      final versionConfigProvider =
          Provider.of<VersionConfigProvider>(context, listen: false);
      versionConfigProvider.updateVersion(coreName, latestVersion);
      await SphiaWidget.showDialogWithMsg(
        context,
        S.of(context).updatedSuccessfully(coreName, latestVersion),
      );
    }
  }
}
