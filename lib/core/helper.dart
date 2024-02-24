import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sphia/app/database/dao/rule.dart';
import 'package:sphia/app/database/database.dart';
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

const coreRepositories = {
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

const singVerArg = 'version';
const xrayVerArg = 'version';
const ssVerArg = '--version';
const hysteriaVerArg = '--version';

const coreVersionArgs = {
  'sing-box': singVerArg,
  'xray-core': xrayVerArg,
  'shadowsocks-rust': ssVerArg,
  'hysteria': hysteriaVerArg,
};

class CoreHelper {
  static bool fileExists(String fileName) {
    return File(p.join(binPath, fileName)).existsSync();
  }

  static bool coreExists(String coreName) {
    if (coreName == 'sing-box-rules') {
      return fileExists(p.join(binPath, 'geoip.db')) &&
          fileExists(p.join(binPath, 'geosite.db'));
    } else if (coreName == 'v2ray-rules-dat') {
      return fileExists(p.join(binPath, 'geoip.dat')) &&
          fileExists(p.join(binPath, 'geosite.dat'));
    } else {
      return fileExists(p.join(binPath, CoreHelper.getCoreFileName(coreName)));
    }
  }

  static String getCoreFileName(String coreName) {
    final os = SystemUtil.os;
    final architecture = SystemUtil.architecture;
    final ext = os == OS.windows ? '.exe' : '';
    switch (coreName) {
      case 'sing-box':
        return 'sing-box$ext';
      case 'xray-core':
        return 'xray$ext';
      case 'shadowsocks-rust':
        return 'sslocal$ext';
      case 'hysteria':
        final plat = os == OS.macos ? 'darwin' : os.name;
        final arch = architecture == Architecture.arm64 ? 'arm64' : 'amd64';
        return 'hysteria-$plat-$arch$ext';
      case 'sphia':
        return 'sphia$ext';
      default:
        throw Exception('Unsupported core: $coreName');
    }
  }

  static List<String> getCoreFileNames() {
    List<String> fileNames = [];
    coreRepositories.entries
        .toList()
        .sublist(0, coreRepositories.length - 3)
        .forEach((entry) {
      fileNames.add(getCoreFileName(entry.key));
    });
    return fileNames;
  }

  static String getCoreArchiveFileName(String coreName, String latestVersion) {
    final os = SystemUtil.os;
    final architecture = SystemUtil.architecture;
    switch (coreName) {
      case 'sing-box':
        if (latestVersion.startsWith('v')) {
          latestVersion = latestVersion.substring(1);
        }
        final plat = os == OS.macos ? 'darwin' : os.name;
        final arch = architecture == Architecture.arm64 ? 'arm64' : 'amd64';
        final ext = os == OS.windows ? '.zip' : '.tar.gz';
        return 'sing-box-$latestVersion-$plat-$arch$ext';
      case 'xray-core':
        final arch = architecture == Architecture.arm64 ? 'arm64-v8a' : '64';
        return 'Xray-${os.name}-$arch.zip';
      case 'shadowsocks-rust':
        late final String plat;
        switch (os) {
          case OS.windows:
            plat = 'pc-windows-gnu';
            break;
          case OS.linux:
            plat = 'unknown-linux-gnu';
            break;
          case OS.macos:
            plat = 'apple-darwin';
            break;
          default:
            throw Exception('Unsupported OS');
        }
        final arch = architecture == Architecture.arm64 ? 'aarch64' : 'x86_64';
        final ext = os == OS.windows ? '.zip' : '.tar.xz';
        return 'shadowsocks-$latestVersion.$arch-$plat$ext';
      case 'hysteria':
        return getCoreFileName('hysteria');
      case 'sphia':
        late final String arch;
        late final String ext;
        switch (os) {
          case OS.windows:
            arch = architecture == Architecture.arm64 ? 'arm64' : 'amd64';
            ext = '.exe';
            break;
          case OS.linux:
            arch = architecture == Architecture.arm64 ? 'arm64' : 'amd64';
            ext = '.appimage';
            break;
          case OS.macos:
            arch = 'universal';
            ext = '.dmg';
            break;
          default:
            throw Exception('Unsupported OS');
        }
        return 'sphia-${os.name}-$arch$ext';
      default:
        throw Exception('Unsupported core: $coreName');
    }
  }

  static Future<bool> coreIsStillRunning(List<int> ports) async {
    for (var port in ports) {
      if (await SystemUtil.portInUse(port)) {
        return true;
      }
    }
    return false;
  }

  static Future<List<int>> getRuleOutboundTagList(List<Rule> rules) async {
    final outboundTags = <int>[];
    for (final rule in rules) {
      if (rule.outboundTag != outboundProxyId &&
          rule.outboundTag != outboundDirectId &&
          rule.outboundTag != outboundBlockId) {
        outboundTags.add(rule.outboundTag);
      }
    }
    return outboundTags;
  }
}
