import 'package:flutter/material.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/util/network.dart';
import 'package:sphia/util/system.dart';
import 'package:updat/updat.dart';

const sphiaVersion = '0.7.1';
const sphiaBuildNumber = 2;
const sphiaFullVersion = '$sphiaVersion+$sphiaBuildNumber';
const sphiaLastCommitHash = 'SELF_BUILD';

class AboutPage extends StatelessWidget {
  const AboutPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).about),
        elevation: 0,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo_about.png',
            width: 256.0,
            height: 256.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // about - Sphia
              Flexible(
                child: Text(
                  'Sphia - a Proxy Handling Intuitive Application',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 16.0),
              // about - version
              Text(
                'Version: $sphiaVersion',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              // about - build number
              Text(
                'Build number: $sphiaBuildNumber',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              // about - last commit hash
              Text(
                'Last commit hash: $sphiaLastCommitHash',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16.0),
              UpdatWidget(
                currentVersion: sphiaFullVersion,
                getLatestVersion: () async {
                  return await NetworkUtil.getLatestVersion('sphia');
                },
                getBinaryUrl: (version) async {
                  return 'https://github.com/YukidouSatoru/sphia/releases/download/v$version/${SystemUtil.getCoreArchiveFileName('sphia', version!)}';
                },
                appName: 'Sphia',
                getChangelog: (_, __) async {
                  final changelog = await NetworkUtil.getSphiaChangeLog();
                  return changelog;
                },
                closeOnInstall: true,
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ],
      ),
    );
  }
}
