import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/notifier/config/version_config.dart';
import 'package:sphia/app/notifier/core_state.dart';
import 'package:sphia/core/helper.dart';
import 'package:sphia/util/network.dart';
import 'package:sphia/util/system.dart';

part 'updater.g.dart';

@riverpod
class CoreUpdater extends _$CoreUpdater {
  @override
  void build() {}

  Future<void> scanCores() async {
    final executableMap = {
      'sing-box': p.join(binPath, CoreHelper.getCoreFileName('sing-box')),
      'xray-core': p.join(binPath, CoreHelper.getCoreFileName('xray-core')),
      'shadowsocks-rust':
          p.join(binPath, CoreHelper.getCoreFileName('shadowsocks-rust')),
      'hysteria': p.join(binPath, CoreHelper.getCoreFileName('hysteria')),
    };

    logger.i('Scanning cores');
    final notifier = ref.read(versionConfigNotifierProvider.notifier);
    for (var entry in executableMap.entries) {
      final coreName = entry.key;
      // if core is not found, remove it from version config
      if (!CoreHelper.coreExists(coreName)) {
        logger.i('Core not found: $coreName');
        notifier.removeVersion(coreName);
        continue;
      }
      final executable = entry.value;
      final arguments = coreVersionArgs[coreName]!;
      late final ProcessResult result;
      try {
        result = await Process.run(executable, [arguments]);
      } on Exception catch (_) {
        logger.e('Failed to run command: $executable $arguments');
        continue;
      }
      if (result.exitCode == 0) {
        final version =
            parseVersionInfo(result.stdout.toString(), coreName, true);
        if (version != null) {
          logger.i('Found $coreName: $version');
          notifier.updateVersion(coreName, version);
        }
      }
    }
    // for rules dat
    if (!CoreHelper.coreExists('sing-box-rules')) {
      notifier.removeVersion('sing-box-rules');
    }
    if (!CoreHelper.coreExists('v2ray-rules-dat')) {
      notifier.removeVersion('v2ray-rules-dat');
    }
  }

  Future<bool?> importCore({required bool isMulti}) async {
    FilePickerResult? result;
    if (SystemUtil.os == OS.windows) {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['exe', "dat", "db"],
        allowMultiple: isMulti,
      );
    } else {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['', "dat", "db"],
        allowMultiple: isMulti,
      );
    }
    if (result != null) {
      if (result.files.isEmpty) {
        return null;
      }
      if (isMulti) {
        for (var platformFile in result.files) {
          if (platformFile.path != null) {
            final file = File(platformFile.path!);
            final destPath = p.join(binPath, p.basename(file.path));
            logger.i('Copying $file to \'$destPath\'');
            file.copySync(destPath);
          }
        }
        return true;
      }
      final file = File(result.files.single.path!);
      final notifier = ref.read(versionConfigNotifierProvider.notifier);
      // check core version
      for (var entry in coreVersionArgs.entries) {
        final coreName = entry.key;
        final arguments = entry.value;
        late final ProcessResult result;
        try {
          result = await Process.run(file.path, [arguments]);
        } on Exception catch (_) {
          logger.e('Failed to run command: ${file.path} $arguments');
          continue;
        }
        if (result.exitCode == 0) {
          final version =
              parseVersionInfo(result.stdout.toString(), coreName, false);
          if (version != null) {
            logger.i('Found $coreName: $version');
            notifier.updateVersion(coreName, version);
            final destPath =
                p.join(binPath, CoreHelper.getCoreFileName(coreName));
            // delete old core
            deleteCore(coreName);
            // copy new core
            logger.i('Copying $file to \'$destPath\'');
            file.copySync(destPath);
            return true;
          }
        }
      }
    } else {
      return null;
    }
    return false;
  }

  void deleteCore(String coreName) {
    if (coreName == 'sing-box-rules') {
      final geoipFilePath = p.join(binPath, 'geoip.db');
      final geositeFilePath = p.join(binPath, 'geosite.db');
      SystemUtil.deleteFileIfExists(
          geoipFilePath, 'Deleting file: $geoipFilePath');
      SystemUtil.deleteFileIfExists(
          geositeFilePath, 'Deleting file: $geositeFilePath');
    } else if (coreName == 'v2ray-rules-dat') {
      final geoipFilePath = p.join(binPath, 'geoip.dat');
      final geositeFilePath = p.join(binPath, 'geosite.dat');
      SystemUtil.deleteFileIfExists(
          geoipFilePath, 'Deleting file: $geoipFilePath');
      SystemUtil.deleteFileIfExists(
          geositeFilePath, 'Deleting file: $geositeFilePath');
    } else {
      final coreFileName = CoreHelper.getCoreFileName(coreName);
      final coreFilePath = p.join(binPath, coreFileName);
      SystemUtil.deleteFileIfExists(
          coreFilePath, 'Deleting file: $coreFilePath');
    }
  }

  Future<void> updateCore({
    required String coreName,
    required String latestVersion,
  }) async {
    final versionConfigNotifier =
        ref.read(versionConfigNotifierProvider.notifier);
    if (coreName == 'v2ray-rules-dat' || coreName == 'sing-box-rules') {
      try {
        await updateGeoFiles(coreName);
      } on Exception catch (e) {
        logger.e('Failed to update: $coreName\n$e');
        throw Exception('Failed to update: $coreName\n$e');
      }
      logger.i('Updated $coreName to $latestVersion successfully');
      versionConfigNotifier.updateVersion(coreName, latestVersion);
    } else {
      try {
        final coreArchiveFileName =
            CoreHelper.getCoreArchiveFileName(coreName, latestVersion);
        final coreFileName = CoreHelper.getCoreFileName(coreName);
        final downloadUrl =
            '${coreRepositories[coreName]!}/releases/download/$latestVersion/$coreArchiveFileName';
        final networkUtil = ref.read(networkUtilProvider.notifier);
        final bytes = await networkUtil.downloadFile(downloadUrl);

        // Stop all cores
        final coreStateNotifier = ref.read(coreStateNotifierProvider.notifier);
        await coreStateNotifier.stopCores();
        // Replace core
        await replaceCore(
          coreArchiveFileName: coreArchiveFileName,
          coreFileName: coreFileName,
          bytes: bytes,
        );

        if (!CoreHelper.coreExists(coreName)) {
          logger.e('Core not found: $coreName');
          throw Exception('Core not found: $coreName');
        }
      } on Exception catch (e) {
        logger.e('Failed to update: $coreName\n$e');
        throw Exception('Failed to update: $coreName\n$e');
      }
      logger.i('Updated $coreName to $latestVersion successfully');
      versionConfigNotifier.updateVersion(coreName, latestVersion);
    }
  }

  Future<void> updateGeoFiles(String coreName) async {
    late final String geositeFilePath;
    late final String geoipFilePath;
    late final String geositeFileUrl;
    late final String geoipFileUrl;

    if (coreName == 'sing-box-rules') {
      geositeFilePath = p.join(binPath, 'geosite.db');
      geoipFilePath = p.join(binPath, 'geoip.db');
      geositeFileUrl = geositeDBUrl;
      geoipFileUrl = geoipDBUrl;
    } else if (coreName == 'v2ray-rules-dat') {
      geositeFilePath = p.join(binPath, 'geosite.dat');
      geoipFilePath = p.join(binPath, 'geoip.dat');
      geositeFileUrl = geositeDatUrl;
      geoipFileUrl = geoipDatUrl;
    } else {
      throw Exception('Unsupported core: $coreName');
    }

    final geositeDatFile = File(geositeFilePath);
    final geoipDatFile = File(geoipFilePath);
    final networkUtil = ref.read(networkUtilProvider.notifier);
    try {
      final geositeDatBytes = await networkUtil.downloadFile(geositeFileUrl);
      final geoipDatBytes = await networkUtil.downloadFile(geoipFileUrl);
      final coreStateNotifier = ref.read(coreStateNotifierProvider.notifier);
      await coreStateNotifier.stopCores();
      await geositeDatFile.writeAsBytes(geositeDatBytes);
      await geoipDatFile.writeAsBytes(geoipDatBytes);
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<void> replaceCore({
    required String coreArchiveFileName,
    required String coreFileName,
    required Uint8List bytes,
  }) async {
    final tempFile = File(p.join(tempPath, coreArchiveFileName));
    late final Archive archive;
    bool flag = false;

    await tempFile.writeAsBytes(bytes);
    if (coreArchiveFileName.endsWith('zip')) {
      archive = ZipDecoder().decodeBytes(bytes);
    } else if (coreArchiveFileName.endsWith('tar.xz')) {
      archive = TarDecoder().decodeBytes(XZDecoder().decodeBytes(bytes));
    } else if (coreArchiveFileName.endsWith('tar.gz')) {
      archive = TarDecoder().decodeBytes(GZipDecoder().decodeBytes(bytes));
    } else {
      if (coreArchiveFileName.contains('hysteria')) {
        final coreBinaryFile = File(p.join(binPath, coreFileName));
        if (await coreBinaryFile.exists()) {
          await coreBinaryFile.delete();
        }
        tempFile.copySync(p.join(binPath, coreFileName));
        SystemUtil.setFilePermission(p.join(binPath, coreFileName));
        await tempFile.delete();
        return;
      } else {
        logger.e('Unsupported archive format');
        throw Exception('Unsupported archive format');
      }
    }

    final coreBinaryFile = File(p.join(binPath, coreFileName));
    if (await coreBinaryFile.exists()) {
      await coreBinaryFile.delete();
    }

    for (var file in archive) {
      final filename = file.name;
      if (file.isFile && filename == coreFileName) {
        final data = file.content as List<int>;
        File(p.join(binPath, coreFileName))
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
        flag = true;
        break;
      }
    }

    final extractDir = Directory(p.join(tempPath, 'extracted'));
    if (!flag) {
      extractArchiveToDisk(archive, extractDir.path);
      final extractedFile = _findFile(extractDir, coreFileName);
      if (extractedFile != null) {
        extractedFile.copySync(p.join(binPath, coreFileName));
        extractDir.deleteSync(recursive: true);
      }
    }

    SystemUtil.setFilePermission(p.join(binPath, coreFileName));
    await tempFile.delete();
  }

  String? parseVersionInfo(String info, String coreName, bool logError) {
    final patterns = {
      'sing-box': RegExp(r'sing-box version (\d+\.\d+\.\d+)'),
      'xray-core': RegExp(r'Xray (\d+\.\d+\.\d+)'),
      'shadowsocks-rust': RegExp(r'shadowsocks (\d+\.\d+\.\d+)'),
      'hysteria': RegExp(r'hysteria version v(\d+\.\d+\.\d+)'),
    };
    String result = '';
    final regex = patterns[coreName];
    if (regex != null) {
      final match = regex.firstMatch(info);
      if (match != null) {
        result = match.group(1)!;
      }
    }
    if (result.isEmpty) {
      if (logError) {
        logger.e('Failed to parse version info for $coreName');
      }
      return null;
    }
    return 'v$result';
  }

  File? _findFile(Directory dir, String fileName) {
    File? file;
    for (FileSystemEntity entity in dir.listSync()) {
      if (entity is File && entity.path.endsWith(fileName)) {
        file = entity;
        break;
      } else if (entity is Directory) {
        file = _findFile(entity, fileName);
        break;
      }
    }
    return file;
  }
}
