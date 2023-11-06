import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:sphia/app/controller.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/version_config.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/util/network.dart';
import 'package:sphia/util/system.dart';

const String singBoxUrl = 'https://github.com/SagerNet/sing-box';
const String xrayCoreRepoUrl = 'https://github.com/xtls/xray-core';
const String shadowsocksRustUrl =
    'https://github.com/shadowsocks/shadowsocks-rust';
const String hysteriaUrl = 'https://github.com/apernet/hysteria';
const String singBoxRulesRepoUrl = 'https://github.com/lyc8503/sing-box-rules';
const String geositeDBUrl =
    'https://github.com/lyc8503/sing-box-rules/releases/latest/download/geosite.db';
const String geoipDBUrl =
    'https://github.com/lyc8503/sing-box-rules/releases/latest/download/geoip.db';
const String v2rayRulesDatRepoUrl =
    'https://github.com/Loyalsoldier/v2ray-rules-dat';
const String geositeDatUrl =
    'https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat';
const String geoipDatUrl =
    'https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat';
const String sphiaRepoUrl = 'https://github.com/YukidouSatoru/sphia';

final coreRepositories = {
  'sing-box': singBoxUrl,
  'xray-core': xrayCoreRepoUrl,
  'shadowsocks-rust': shadowsocksRustUrl,
  'hysteria': hysteriaUrl,
  'sing-box-rules': singBoxRulesRepoUrl,
  'v2ray-rules-dat': v2rayRulesDatRepoUrl,
  'sphia': sphiaRepoUrl,
  // Add new core here
};

const hysteriaLatestVersion = 'v1.3.5';

class UpdateAgent {
  Future<void> updateCore(String coreName, String latestVersion,
      void Function(String) showSnackBar) async {
    showSnackBar('${S.current.updating}: $coreName');
    if (coreName == 'v2ray-rules-dat' || coreName == 'sing-box-rules') {
      try {
        await updateGeoFiles(coreName);
      } on Exception catch (e) {
        logger.e('Failed to update: $coreName\n$e');
        showSnackBar('${S.current.updateFailed}: $coreName\n$e');
        throw Exception('Failed to update: $coreName\n$e');
      }
      logger.i('Updated $coreName to $latestVersion successfully');
      showSnackBar(S.current.updatedSuccessfully(coreName, latestVersion));
      final versionConfigProvider = GetIt.I.get<VersionConfigProvider>();
      versionConfigProvider.updateVersion(coreName, latestVersion);
    } else {
      try {
        final coreArchiveFileName =
            SystemUtil.getCoreArchiveFileName(coreName, latestVersion);
        final coreFileName = SystemUtil.getCoreFileName(coreName);
        final downloadUrl =
            '${coreRepositories[coreName]!}/releases/download/$latestVersion/$coreArchiveFileName';
        final bytes = await NetworkUtil.downloadFile(downloadUrl);

        // Stop all cores
        await SphiaController.stopCores();
        showSnackBar('${S.current.replacingCore}: $coreName');
        // Replace core
        await replaceCore(coreArchiveFileName, coreFileName, bytes);

        if (!SystemUtil.fileExists(coreFileName)) {
          logger.e('Core not found: $coreName');
          showSnackBar('${S.current.coreNotFound} $coreName');
          return;
        }
      } on Exception catch (e) {
        logger.e('Failed to update: $coreName\n$e');
        showSnackBar('${S.current.updateFailed}: $coreName\n$e');
        throw Exception('Failed to update: $coreName\n$e');
      }
      logger.i('Updated $coreName to $latestVersion successfully');
      showSnackBar(S.current.updatedSuccessfully(coreName, latestVersion));
      final versionConfigProvider = GetIt.I.get<VersionConfigProvider>();
      versionConfigProvider.updateVersion(coreName, latestVersion);
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
    try {
      final geositeDatBytes = await NetworkUtil.downloadFile(geositeFileUrl);
      final geoipDatBytes = await NetworkUtil.downloadFile(geoipFileUrl);
      await SphiaController.stopCores();
      await geositeDatFile.writeAsBytes(geositeDatBytes);
      await geoipDatFile.writeAsBytes(geoipDatBytes);
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<void> replaceCore(
      String coreFileArchiveName, String coreFileName, Uint8List bytes) async {
    final tempFile = File(p.join(tempPath, coreFileArchiveName));
    late final Archive archive;
    bool flag = false;

    await tempFile.writeAsBytes(bytes);
    if (coreFileArchiveName.endsWith('zip')) {
      archive = ZipDecoder().decodeBytes(bytes);
    } else if (coreFileArchiveName.endsWith('tar.xz')) {
      archive = TarDecoder().decodeBytes(XZDecoder().decodeBytes(bytes));
    } else if (coreFileArchiveName.endsWith('tar.gz')) {
      archive = TarDecoder().decodeBytes(GZipDecoder().decodeBytes(bytes));
    } else {
      if (coreFileArchiveName.contains('hysteria')) {
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
