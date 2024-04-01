import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/config/version.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/notifier/config/version_config.dart';
import 'package:sphia/app/notifier/proxy.dart';
import 'package:sphia/app/state/core_info.dart';
import 'package:sphia/core/helper.dart';
import 'package:sphia/core/updater.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/util/network.dart';
import 'package:sphia/view/widget/widget.dart';

part 'update.g.dart';

@riverpod
class CoreInfoList extends _$CoreInfoList {
  @override
  List<CoreInfo> build() {
    final coreNames = coreRepositories.keys.toList();
    coreNames.remove('sphia');
    return coreNames.map((coreName) {
      final repoUrl = coreRepositories[coreName]!;
      return CoreInfo(
        coreName: coreName,
        repoUrl: repoUrl,
        latestVersion: null,
      );
    }).toList();
  }

  void updateLatestVersion(String coreName, String version) {
    state = state.map((info) {
      if (info.coreName == coreName) {
        return info.copyWith(latestVersion: version);
      }
      return info;
    }).toList();
  }

  void removeLatestVersion(String coreName) {
    state = state.map((info) {
      if (info.coreName == coreName) {
        return info.copyWith(latestVersion: null);
      }
      return info;
    }).toList();
  }
}

mixin UpdateAgent {
  Future<void> checkUpdate({
    required String coreName,
    required bool showDialog,
    required WidgetRef ref,
  }) async {
    final context = ref.context;
    final config = ref.read(versionConfigNotifierProvider);
    final coreExists = CoreHelper.coreExists(coreName);
    if (!coreExists) {
      final notifier = ref.read(versionConfigNotifierProvider.notifier);
      notifier.removeVersion(coreName);
    }
    final coreInfoNotifier = ref.read(coreInfoListProvider.notifier);
    if (coreName == 'hysteria') {
      if (config.getVersion(coreName) == hysteriaLatestVersion && coreExists) {
        await SphiaWidget.showDialogWithMsg(
          context: context,
          message:
              '${S.of(context).alreadyLatestVersion}: hysteria $hysteriaLatestVersion',
        );
        return;
      }
      logger.i('Latest version of hysteria: $hysteriaLatestVersion');
      coreInfoNotifier.updateLatestVersion('hysteria', hysteriaLatestVersion);
      if (showDialog) {
        await SphiaWidget.showDialogWithMsg(
          context: context,
          message:
              '${S.of(context).latestVersion}: hysteria $hysteriaLatestVersion',
        );
      }
      return;
    }
    logger.i('Checking update: $coreName');
    final networkUtil = ref.read(networkUtilProvider.notifier);
    try {
      try {
        // check github connection
        await networkUtil.getHttpResponse('https://github.com').timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw Exception('Connection timed out'));
      } on Exception catch (e) {
        logger.e('Failed to connect to Github: $e');
        if (!context.mounted) {
          return;
        }
        await SphiaWidget.showDialogWithMsg(
          context: context,
          message: '${S.of(context).connectToGithubFailed}: $e',
        );
        return;
      }
      final latestVersion = await networkUtil.getLatestVersion(coreName);
      logger.i('Latest version of $coreName: $latestVersion');
      if (config.getVersion(coreName) == latestVersion && coreExists) {
        if (!context.mounted) {
          return;
        }
        await SphiaWidget.showDialogWithMsg(
          context: context,
          message:
              '${S.of(context).alreadyLatestVersion}: $coreName $latestVersion',
        );
      } else {
        coreInfoNotifier.updateLatestVersion(coreName, latestVersion);
        if (showDialog && context.mounted) {
          await SphiaWidget.showDialogWithMsg(
            context: context,
            message: '${S.of(context).latestVersion}: $coreName $latestVersion',
          );
        }
      }
    } on Exception catch (e) {
      logger.e('Failed to check update: $e');
      if (!context.mounted) {
        return;
      }
      await SphiaWidget.showDialogWithMsg(
        context: context,
        message: '${S.of(context).checkUpdateFailed}: $e',
      );
      return;
    }
  }

  Future<void> updateCore({
    required CoreInfo coreInfo,
    required String? currentVersion,
    required WidgetRef ref,
  }) async {
    final context = ref.context;
    if (coreInfo.latestVersion == null) {
      await checkUpdate(
        coreName: coreInfo.coreName,
        showDialog: false,
        ref: ref,
      );
    }
    final newCoreInfo = ref
        .read(coreInfoListProvider)
        .firstWhere((info) => info.coreName == coreInfo.coreName);
    final latestVersion = newCoreInfo.latestVersion;
    if (latestVersion != null) {
      if (latestVersion == currentVersion) {
        return;
      }
      try {
        await ref.read(coreUpdaterProvider.notifier).updateCore(
            coreName: coreInfo.coreName, latestVersion: latestVersion);
      } on Exception catch (e) {
        if (!context.mounted) {
          return;
        }
        await SphiaWidget.showDialogWithMsg(
            context: context, message: '${S.of(context).updateFailed}: $e');
      }
      final coreInfoListNotifier = ref.read(coreInfoListProvider.notifier);
      coreInfoListNotifier.removeLatestVersion(coreInfo.coreName);
      final versionConfigNotifier =
          ref.read(versionConfigNotifierProvider.notifier);
      versionConfigNotifier.updateVersion(coreInfo.coreName, latestVersion);
      if (!context.mounted) {
        return;
      }
      await SphiaWidget.showDialogWithMsg(
        context: context,
        message:
            S.of(context).updatedSuccessfully(coreInfo.coreName, latestVersion),
      );
    }
  }

  Future<void> deleteCore(
      {required String coreName, required WidgetRef ref}) async {
    final context = ref.context;
    final notifier = ref.read(versionConfigNotifierProvider.notifier);
    // check if core exists
    if (!CoreHelper.coreExists(coreName)) {
      await SphiaWidget.showDialogWithMsg(
        context: context,
        message: S.of(context).coreNotFound(coreName),
      );
      notifier.removeVersion(coreName);
      return;
    }
    // check if core is running
    final proxyState = ref.read(proxyNotifierProvider);
    if (proxyState.coreRunning) {
      await SphiaWidget.showDialogWithMsg(
        context: context,
        message: S.of(context).stopCoreBeforeDelete,
      );
      return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).deleteCore),
        content: Text(S.of(context).deleteCoreConfirm(coreName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(S.of(context).delete),
          ),
        ],
      ),
    );
    if (confirm == null || !confirm) {
      return;
    }
    try {
      ref.read(coreUpdaterProvider.notifier).deleteCore(coreName);
    } on Exception catch (e) {
      if (!context.mounted) {
        return;
      }
      await SphiaWidget.showDialogWithMsg(
        context: context,
        message: '${S.of(context).deleteCoreFailed}: $e',
      );
    }
    notifier.removeVersion(coreName);
    if (!context.mounted) {
      return;
    }
    await SphiaWidget.showDialogWithMsg(
      context: context,
      message: S.of(context).deletedCoreSuccessfully(coreName),
    );
  }
}
