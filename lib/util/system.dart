import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:path/path.dart' as p;
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/sphia_config.dart';

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

  static void deleteFileIfExists(String filePath, String logMessage) {
    final file = File(filePath);
    if (file.existsSync()) {
      logger.i(logMessage);
      file.deleteSync();
    }
  }
}

late final String execPath;
late final String appPath;
final binPath = p.join(appPath, 'bin');
final configPath = p.join(appPath, 'config');
final logPath = p.join(appPath, 'log');
final tempPath = p.join(appPath, 'temp');
