import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/util/network.dart';
import 'package:sphia/util/system.dart';
import 'package:sphia/view/page/about.dart';
import 'package:sphia/core/helper.dart';
import 'package:updat/updat.dart';

class SphiaUpdatWidget {
  Widget updatWidget() {
    return UpdatWidget(
      updateChipBuilder: updatChip,
      currentVersion: sphiaFullVersion,
      getLatestVersion: () async {
        return await NetworkUtil.getLatestVersion('sphia');
      },
      getBinaryUrl: (version) async {
        final coreArchiveFileName =
            CoreHelper.getCoreArchiveFileName('sphia', version!);
        return 'https://github.com/YukidouSatoru/sphia/releases/download/v$version/$coreArchiveFileName';
      },
      getDownloadFileLocation: (version) async {
        final coreArchiveFileName =
            CoreHelper.getCoreArchiveFileName('sphia', version!);
        final bytes = await NetworkUtil.downloadFile(
            'https://github.com/YukidouSatoru/sphia/releases/download/v$version/$coreArchiveFileName');
        final tempFile = File(p.join(tempPath, coreArchiveFileName));
        await tempFile.writeAsBytes(bytes);
        return tempFile;
      },
      appName: 'Sphia',
      getChangelog: (_, __) async {
        final changelog = await NetworkUtil.getSphiaChangeLog();
        return changelog;
      },
      closeOnInstall: true,
    );
  }

  Widget updatChip({
    required BuildContext context,
    required String? latestVersion,
    required String appVersion,
    required UpdatStatus status,
    required void Function() checkForUpdate,
    required void Function() openDialog,
    required void Function() startUpdate,
    required Future<void> Function() launchInstaller,
    required void Function() dismissUpdate,
  }) {
    if (UpdatStatus.available == status ||
        UpdatStatus.availableWithChangelog == status) {
      return getUpdatWidgetFloatingButton(
        onPressed: openDialog,
        icon: const Icon(Icons.system_update_alt_rounded),
      );
    }

    if (UpdatStatus.downloading == status) {
      return getUpdatWidgetFloatingButton(
        onPressed: () {},
        icon: const SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (UpdatStatus.readyToInstall == status) {
      return getUpdatWidgetFloatingButton(
        onPressed: launchInstaller,
        icon: const Icon(Icons.check_circle),
      );
    }

    if (UpdatStatus.error == status) {
      return getUpdatWidgetFloatingButton(
        onPressed: startUpdate,
        icon: const Icon(Icons.warning),
      );
    }

    return const SizedBox.shrink();
  }

  Widget getUpdatWidgetFloatingButton({
    required Function() onPressed,
    required Widget icon,
  }) {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    return Container(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: FloatingActionButton(
        isExtended: true,
        elevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        disabledElevation: 0,
        foregroundColor: sphiaConfig.darkMode ? Colors.white : Colors.black,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        focusColor: Colors.transparent,
        onPressed: onPressed,
        child: icon,
      ),
    );
  }
}
