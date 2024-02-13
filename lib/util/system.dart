import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:path/path.dart' as p;
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/provider/version_config.dart';
import 'package:sphia/view/page/agent/update.dart';

enum OS { windows, linux, macos }

enum Architecture { x86_64, arm64 }

class SystemUtil {
  static late final OS os;
  static late final Architecture architecture;
  static late final bool isRoot;

  static void init() {
    os = determineOS();
    architecture = determineArchitecture();
    isRoot = determineIsRoot();
  }

  static OS determineOS() {
    if (Platform.isWindows) {
      return OS.windows;
    } else if (Platform.isLinux) {
      return OS.linux;
    } else if (Platform.isMacOS) {
      return OS.macos;
    } else {
      logger.e('Unsupported OS');
      throw Exception('Unsupported OS');
    }
  }

  static Architecture determineArchitecture() {
    if (os == OS.windows) {
      final arch = Platform.environment['PROCESSOR_ARCHITECTURE'];
      // https://learn.microsoft.com/en-us/windows/win32/winprog64/wow64-implementation-details
      if (arch == 'AMD64') {
        return Architecture.x86_64;
      } else if (arch == 'ARM64') {
        return Architecture.arm64;
      } else {
        logger.e('Unsupported Architecture');
        throw Exception('Unsupported Architecture');
      }
    } else {
      final result = Process.runSync('uname', ['-m']);
      if (result.exitCode == 0) {
        final arch = result.stdout.toString().trim();
        if (arch == 'x86_64') {
          return Architecture.x86_64;
        } else if (arch == 'aarch64' || arch == 'arm64') {
          return Architecture.arm64;
        } else {
          logger.e('Unsupported Architecture');
          throw Exception('Unsupported Architecture');
        }
      } else {
        logger.e('Unsupported Architecture');
        throw Exception('Unsupported Architecture');
      }
    }
  }

  static bool determineIsRoot() {
    if (os == OS.windows) {
      final result = Process.runSync('net', ['session']);
      if (result.exitCode == 0) {
        return true;
      } else {
        return false;
      }
    } else {
      final result = Process.runSync('id', ['-u']);
      if (result.exitCode == 0) {
        return result.stdout.toString().trim() == '0';
      } else {
        return false;
      }
    }
  }

  static void configureStartup() async {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    launchAtStartup.setup(
      appName: 'Sphia',
      appPath: execPath,
    );
    if (sphiaConfig.startOnBoot) {
      logger.i('Enabling startup');
      await launchAtStartup.enable();
    } else {
      logger.i('Disabling startup');
      await launchAtStartup.disable();
    }
  }

  static bool getSystemProxy() {
    switch (os) {
      case OS.windows:
        final result = Process.runSync('reg', [
          'query',
          'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings',
          '/v',
          'ProxyEnable',
        ]);
        if (result.exitCode == 0) {
          final regex = RegExp(r'ProxyEnable\s+REG_DWORD\s+(0x\d)');
          final match = regex.firstMatch(result.stdout.toString());
          if (match != null) {
            return match.group(1) == '0x1';
          } else {
            return false;
          }
        } else {
          return false;
        }
      case OS.linux:
        final result = Process.runSync('gsettings', [
          'get',
          'org.gnome.system.proxy',
          'mode',
        ]);
        if (result.exitCode == 0) {
          final value = result.stdout.toString().trim();
          return value == '\'manual\'';
        } else {
          return false;
        }
      case OS.macos:
        final result =
            Process.runSync('networksetup', ['-getwebproxy', 'wi-fi']);
        if (result.exitCode == 0) {
          final value = result.stdout
              .toString()
              .trim()
              .split('\n')[0]
              .split(RegExp(r'\s+'))[1];
          return value == 'Yes';
        } else {
          return false;
        }
    }
  }

  static void enableSystemProxy(
    String listen,
    int socksPort,
    int httpPort,
  ) {
    logger.i('Enabling system proxy');
    switch (os) {
      case OS.windows:
        enableWindowsProxy(listen, httpPort);
        break;
      case OS.linux:
        enableLinuxProxy(listen, socksPort, httpPort);
        break;
      case OS.macos:
        enableMacOSProxy(listen, httpPort);
        break;
    }
  }

  static void disableSystemProxy() {
    logger.i('Disabling system proxy');
    switch (os) {
      case OS.windows:
        disableWindowsProxy();
        break;
      case OS.linux:
        disableLinuxProxy();
        break;
      case OS.macos:
        disableMacOSProxy();
        break;
    }
  }

  static void enableWindowsProxy(String listen, int httpPort) async {
    await runCommand('reg', [
      'add',
      'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings',
      '/v',
      'ProxyEnable',
      '/t',
      'REG_DWORD',
      '/d',
      '1',
      '/f'
    ]);
    await runCommand('reg', [
      'add',
      'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings',
      '/v',
      'ProxyServer',
      '/d',
      '$listen:$httpPort',
      '/f'
    ]);
    await runCommand('reg', [
      'add',
      'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings',
      '/v',
      'ProxyOverride',
      '/d',
      '127.*;10.*;172.16.*;172.17.*;172.18.*;172.19.*;172.20.*;172.21.*;172.22.*;172.23.*;172.24.*;172.25.*;172.26.*;172.27.*;172.28.*;172.29.*;172.30.*;172.31.*;192.168.*',
      '/f'
    ]);
  }

  static void disableWindowsProxy() async {
    await runCommand('reg', [
      'add',
      'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings',
      '/v',
      'ProxyEnable',
      '/t',
      'REG_DWORD',
      '/d',
      '0',
      '/f'
    ]);
  }

  static void enableLinuxProxy(
    String listen,
    int socksPort,
    int httpPort,
  ) async {
    await runCommand('gsettings', [
      'set',
      'org.gnome.system.proxy.http',
      'host',
      listen,
    ]);
    await runCommand('gsettings', [
      'set',
      'org.gnome.system.proxy.http',
      'port',
      httpPort.toString(),
    ]);
    await runCommand('gsettings', [
      'set',
      'org.gnome.system.proxy.https',
      'host',
      listen,
    ]);
    await runCommand('gsettings', [
      'set',
      'org.gnome.system.proxy.https',
      'port',
      httpPort.toString(),
    ]);
    await runCommand('gsettings', [
      'set',
      'org.gnome.system.proxy.ftp',
      'host',
      listen,
    ]);
    await runCommand('gsettings', [
      'set',
      'org.gnome.system.proxy.ftp',
      'port',
      socksPort.toString(),
    ]);
    await runCommand('gsettings', [
      'set',
      'org.gnome.system.proxy.socks',
      'host',
      listen,
    ]);
    await runCommand('gsettings', [
      'set',
      'org.gnome.system.proxy.socks',
      'port',
      socksPort.toString(),
    ]);
    await runCommand('gsettings', [
      'set',
      'org.gnome.system.proxy',
      'use-same-proxy',
      'true',
    ]);
    await runCommand('gsettings', [
      'set',
      'org.gnome.system.proxy',
      'mode',
      'manual',
    ]);
  }

  static void disableLinuxProxy() async {
    await runCommand('gsettings', [
      'set',
      'org.gnome.system.proxy',
      'mode',
      'none',
    ]);
  }

  static void enableMacOSProxy(String listen, int httpPort) async {
    await runCommand(
        'networksetup', ['-setwebproxy', 'wi-fi', listen, httpPort.toString()]);
    await runCommand('networksetup',
        ['-setsecurewebproxy', 'wi-fi', listen, httpPort.toString()]);
    await runCommand('networksetup', ['-setwebproxystate', 'wi-fi', 'on']);
    await runCommand(
        'networksetup', ['-setsecurewebproxystate', 'wi-fi', 'on']);
  }

  static void disableMacOSProxy() async {
    await runCommand('networksetup', ['-setwebproxystate', 'wi-fi', 'off']);
    await runCommand(
        'networksetup', ['-setsecurewebproxystate', 'wi-fi', 'off']);
  }

  static Future<void> runCommand(
      String executable, List<String> arguments) async {
    final result = await Process.run(executable, arguments, runInShell: true);
    if (result.exitCode != 0) {
      logger.e('Failed to run command: $executable $arguments');
      throw Exception('Failed to run command: $executable $arguments');
    }
  }

  static void setFilePermission(String fileName) {
    if (os != OS.windows) {
      Process.runSync('chmod', ['+x', fileName]);
    }
  }

  static String getCoreArchiveFileName(String coreName, String latestVersion) {
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

  static String getCoreFileName(String coreName) {
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

  static void createDirectory(String dirName) {
    final dir = Directory(dirName);
    try {
      if (!dir.existsSync()) {
        logger.i('Creating directory: $dirName');
        dir.createSync();
      }
    } on Exception catch (_) {
      rethrow;
    }
  }

  static bool fileExists(String fileName) {
    return File(p.join(binPath, fileName)).existsSync();
  }

  static void deleteFileIfExists(String filePath, String logMessage) {
    final file = File(filePath);
    if (file.existsSync()) {
      logger.i(logMessage);
      file.deleteSync();
    }
  }

  static bool coreExists(String coreName) {
    if (coreName == 'sing-box-rules') {
      return fileExists(p.join(binPath, 'geoip.db')) &&
          fileExists(p.join(binPath, 'geosite.db'));
    } else if (coreName == 'v2ray-rules-dat') {
      return fileExists(p.join(binPath, 'geoip.dat')) &&
          fileExists(p.join(binPath, 'geosite.dat'));
    } else {
      return fileExists(p.join(binPath, getCoreFileName(coreName)));
    }
  }

  static Future<void> scanCores() async {
    final executableMap = {
      'sing-box': p.join(binPath, getCoreFileName('sing-box')),
      'xray-core': p.join(binPath, getCoreFileName('xray-core')),
      'shadowsocks-rust': p.join(binPath, getCoreFileName('shadowsocks-rust')),
      'hysteria': p.join(binPath, getCoreFileName('hysteria')),
    };
    final versionConfigProvider = GetIt.I.get<VersionConfigProvider>();
    logger.i('Scanning cores');
    for (var entry in executableMap.entries) {
      final coreName = entry.key;
      // if core is not found, remove it from version config
      if (!coreExists(coreName)) {
        logger.i('Core not found: $coreName');
        final versionConfigProvider = GetIt.I.get<VersionConfigProvider>();
        versionConfigProvider.removeVersion(coreName);
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
          versionConfigProvider.updateVersion(coreName, version);
        }
      }
    }
    // for rules dat
    if (!coreExists('sing-box-rules')) {
      versionConfigProvider.removeVersion('sing-box-rules');
    }
    if (!coreExists('v2ray-rules-dat')) {
      versionConfigProvider.removeVersion('v2ray-rules-dat');
    }
  }

  static Future<bool?> importCore(bool isMulti) async {
    FilePickerResult? result;
    if (os == OS.windows) {
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
            final versionConfigProvider = GetIt.I.get<VersionConfigProvider>();
            versionConfigProvider.updateVersion(coreName, version);
            final destPath = p.join(binPath, getCoreFileName(coreName));
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

  static String? parseVersionInfo(String info, String coreName, bool logError) {
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

  static void deleteCore(String coreName) {
    if (coreName == 'sing-box-rules') {
      final geoipFilePath = p.join(binPath, 'geoip.db');
      final geositeFilePath = p.join(binPath, 'geosite.db');
      deleteFileIfExists(geoipFilePath, 'Deleting file: $geoipFilePath');
      deleteFileIfExists(geositeFilePath, 'Deleting file: $geositeFilePath');
    } else if (coreName == 'v2ray-rules-dat') {
      final geoipFilePath = p.join(binPath, 'geoip.dat');
      final geositeFilePath = p.join(binPath, 'geosite.dat');
      deleteFileIfExists(geoipFilePath, 'Deleting file: $geoipFilePath');
      deleteFileIfExists(geositeFilePath, 'Deleting file: $geositeFilePath');
    } else {
      final coreFileName = getCoreFileName(coreName);
      final coreFilePath = p.join(binPath, coreFileName);
      deleteFileIfExists(coreFilePath, 'Deleting file: $coreFilePath');
    }
  }
}

late final String execPath;
late final String appPath;
final binPath = p.join(appPath, 'bin');
final configPath = p.join(appPath, 'config');
final logPath = p.join(appPath, 'log');
final tempPath = p.join(appPath, 'temp');

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
