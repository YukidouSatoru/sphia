import 'package:flutter/material.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/wrapper/page.dart';

const sphiaVersion = '0.7.9';
const sphiaBuildNumber = 10;
const sphiaFullVersion = '$sphiaVersion+$sphiaBuildNumber';
const sphiaLastCommitHash = 'SELF_BUILD';

class AboutPage extends StatelessWidget {
  const AboutPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).about),
        elevation: 0,
      ),
      body: PageWrapper(
        child: Card(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Row(
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
