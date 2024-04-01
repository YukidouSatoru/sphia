import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/config/version.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/notifier/config/version_config.dart';
import 'package:sphia/app/state/core_info.dart';
import 'package:sphia/core/helper.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/page/agent/update.dart';
import 'package:sphia/view/widget/widget.dart';
import 'package:url_launcher/url_launcher.dart';

part 'core_card.g.dart';

@riverpod
CoreInfo currentCore(Ref ref) => throw UnimplementedError();

class CoreInfoCard extends ConsumerWidget with UpdateAgent {
  const CoreInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(currentCoreProvider);
    final currentVersion = ref.watch(versionConfigNotifierProvider
        .select((value) => value.getVersion(info.coreName)));
    String? displayVersion;
    if (currentVersion != null) {
      displayVersion = currentVersion;
    } else {
      if (CoreHelper.coreExists(info.coreName)) {
        displayVersion = S.of(context).unknown;
      }
    }
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text(info.coreName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: '${S.of(context).repoUrl}: ${info.repoUrl}',
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    try {
                      await launchUrl(Uri.parse(info.repoUrl));
                    } on Exception catch (e) {
                      logger.e('Failed to launch url: $e');
                      if (!context.mounted) {
                        return;
                      }
                      await SphiaWidget.showDialogWithMsg(
                        context: context,
                        message: '${S.of(context).launchUrlFailed}: $e',
                      );
                    }
                  },
              ),
            ),
            if (displayVersion != null) ...[
              Text('${S.of(context).currentVersion}: $displayVersion')
            ],
            if (info.latestVersion != null) ...[
              Text('${S.of(context).latestVersion}: ${info.latestVersion}')
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(
              message: S.of(context).checkUpdate,
              child: SphiaWidget.iconButton(
                icon: Icons.refresh,
                onTap: () async => await checkUpdate(
                  coreName: info.coreName,
                  showDialog: true,
                  ref: ref,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: S.of(context).update,
              child: SphiaWidget.iconButton(
                icon: Icons.update,
                onTap: () async => await updateCore(
                  coreInfo: info,
                  currentVersion: currentVersion,
                  ref: ref,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: S.of(context).delete,
              child: SphiaWidget.iconButton(
                icon: Icons.delete,
                onTap: () async => await deleteCore(
                  coreName: info.coreName,
                  ref: ref,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
