import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/version_config.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/util/network.dart';
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
  final Map<String, String> _latestVersions = {'hysteria': 'v1.3.5'};
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
              final latestVersion = _latestVersions[coreName] ??
                  (_latestVersions[coreName] = S.of(context).unknown);
              final currentVersion =
                  versionConfigProvider.getVersion(coreName) ??
                      S.of(context).unknown;
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
                      Text(
                        '${S.of(context).currentVersion}: $currentVersion',
                      ),
                      Text('${S.of(context).latestVersion}: $latestVersion'),
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
                              _latestVersions[coreName] == null ||
                              _latestVersions[coreName] ==
                                  S.of(context).unknown) {
                            await _checkUpdate(coreName);
                          }
                          if (_latestVersions[coreName] ==
                              versionConfigProvider.getVersion(coreName)) {
                            if (context.mounted) {
                              _scaffoldMessengerKey.currentState!.showSnackBar(
                                WidgetBuild.snackBar(
                                    '${S.of(context).alreadyLatestVersion}: $coreName'),
                              );
                            }
                            return;
                          }
                          await _agent.updateCore(
                              coreName, _latestVersions[coreName]!, (message) {
                            _scaffoldMessengerKey.currentState!.showSnackBar(
                              WidgetBuild.snackBar(message),
                            );
                          });
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
    if (coreName == 'hysteria') {
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
