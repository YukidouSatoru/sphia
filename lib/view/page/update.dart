import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
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
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
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
      key: _scaffoldMessengerKey,
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
                                _scaffoldMessengerKey.currentState!
                                    .showSnackBar(
                                  WidgetBuild.snackBar(
                                      '${S.current.launchUrlFailed}: $e'),
                                );
                              }
                            },
                        ),
                      ),
                      currentVersion == null
                          ? const SizedBox.shrink()
                          : Text(
                              '${S.of(context).currentVersion}: $currentVersion',
                            ),
                      latestVersion == null
                          ? const SizedBox.shrink()
                          : Text(
                              '${S.of(context).latestVersion}: $latestVersion',
                            ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () async => await _checkUpdate(coreName),
                        child: Text(S.of(context).checkUpdate),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          if (!_latestVersions.containsKey(coreName) ||
                              _latestVersions[coreName] == null) {
                            await _checkUpdate(coreName);
                          }
                          try {
                            await _agent.updateCore(
                                coreName, _latestVersions[coreName]!,
                                (message) {
                              _scaffoldMessengerKey.currentState!.showSnackBar(
                                WidgetBuild.snackBar(message),
                              );
                            });
                            _latestVersions.remove(coreName);
                          } on Exception catch (_) {}
                        },
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

  Future<void> _checkUpdate(String coreName) async {
    final versionConfigProvider =
        Provider.of<VersionConfigProvider>(context, listen: false);
    final coreExists =
        File(p.join(binPath, SystemUtil.getCoreFileName(coreName)))
            .existsSync();
    if (!coreExists) {
      setState(() {
        versionConfigProvider.removeVersion(coreName);
      });
    }
    if (coreName == 'hysteria') {
      if (versionConfigProvider.getVersion(coreName) == hysteriaLatestVersion &&
          coreExists) {
        _scaffoldMessengerKey.currentState?.showSnackBar(
          WidgetBuild.snackBar(
              '${S.of(context).alreadyLatestVersion}: $coreName'),
        );
        return;
      }
      setState(() {
        _latestVersions['hysteria'] = hysteriaLatestVersion;
      });
      return;
    }
    logger.i('Checking update: $coreName');
    _scaffoldMessengerKey.currentState?.showSnackBar(
      WidgetBuild.snackBar('${S.of(context).checkingUpdate}: $coreName'),
    );
    try {
      // check github connection
      try {
        await NetworkUtil.getHttpResponse('https://github.com').timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw Exception('Connection timed out'));
      } on Exception catch (e) {
        logger.e('Failed to connect to Github: $e');
        _scaffoldMessengerKey.currentState!.showSnackBar(
          WidgetBuild.snackBar('${S.current.connectToGithubFailed}: $e'),
        );
        return;
      }
      final latestVersion = await NetworkUtil.getLatestVersion(coreName);
      if (context.mounted) {
        if (versionConfigProvider.getVersion(coreName) == latestVersion &&
            coreExists) {
          _scaffoldMessengerKey.currentState?.showSnackBar(
            WidgetBuild.snackBar(
                '${S.of(context).alreadyLatestVersion}: $coreName'),
          );
          return;
        }
      }
      setState(() {
        _latestVersions[coreName] = latestVersion;
      });
    } on Exception catch (e) {
      logger.e('Failed to check update: $e');
      _scaffoldMessengerKey.currentState!.showSnackBar(
        WidgetBuild.snackBar('${S.current.checkUpdateFailed} $e'),
      );
      return;
    }
  }
}
