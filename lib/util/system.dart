import 'dart:async';
import 'dart:io';

import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:path/path.dart' as p;
import 'package:sphia/app/log.dart';

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
      return result.exitCode == 0;
    } else {
      final result = Process.runSync('id', ['-u']);
      return result.exitCode == 0 && result.stdout.toString().trim() == '0';
    }
  }

  static void configureStartup(bool startOnBoot) async {
    launchAtStartup.setup(
      appName: 'Sphia',
      appPath: execPath,
    );
    if (startOnBoot) {
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
          return match?.group(1) == '0x1';
        } else {
          return false;
        }
      case OS.linux:
        final desktop = Platform.environment['XDG_CURRENT_DESKTOP'];
        if (desktop == 'GNOME') {
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
        } else if (desktop == 'KDE') {
          final configPath = p.join(Platform.environment['HOME']!, '.config');
          final result = Process.runSync('kreadconfig5', [
            '--file',
            p.join(configPath, 'kioslaverc'),
            '--group',
            'Proxy Settings',
            '--key',
            'ProxyType',
          ]);
          if (result.exitCode == 0) {
            final value = result.stdout.toString().trim();
            return value == '1';
          } else {
            return false;
          }
        } else {
          logger.w('Unsupported desktop environment');
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
    int httpPort,
  ) {
    logger.i('Enabling system proxy');
    switch (os) {
      case OS.windows:
        enableWindowsProxy(listen, httpPort);
        break;
      case OS.linux:
        enableLinuxProxy(listen, httpPort);
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
    int httpPort,
  ) async {
    final desktop = Platform.environment['XDG_CURRENT_DESKTOP'];
    if (desktop == 'GNOME') {
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
        'org.gnome.system.proxy',
        'mode',
        'manual',
      ]);
    } else if (desktop == 'KDE') {
      final configPath = p.join(Platform.environment['HOME']!, '.config');
      await runCommand('kwriteconfig5', [
        '--file',
        p.join(configPath, 'kioslaverc'),
        '--group',
        'Proxy Settings',
        '--key',
        'httpProxy',
        'http://$listen:$httpPort',
      ]);
      await runCommand('kwriteconfig5', [
        '--file',
        p.join(configPath, 'kioslaverc'),
        '--group',
        'Proxy Settings',
        '--key',
        'ProxyType',
        '1',
      ]);
    } else {
      logger.e('Unsupported desktop environment');
      throw Exception('Unsupported desktop environment');
    }
  }

  static void disableLinuxProxy() async {
    final desktop = Platform.environment['XDG_CURRENT_DESKTOP'];
    if (desktop == 'GNOME') {
      await runCommand('gsettings', [
        'set',
        'org.gnome.system.proxy',
        'mode',
        'none',
      ]);
    } else if (desktop == 'KDE') {
      final configPath = p.join(Platform.environment['HOME']!, '.config');
      await runCommand('kwriteconfig5', [
        '--file',
        p.join(configPath, 'kioslaverc'),
        '--group',
        'Proxy Settings',
        '--key',
        'ProxyType',
        '0',
      ]);
    } else {
      logger.e('Unsupported desktop environment');
      throw Exception('Unsupported desktop environment');
    }
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

  static Future<bool> portInUse(int port) async {
    const timeout = Duration(milliseconds: 10);
    // send a request to the port
    try {
      logger.i('Checking if port $port is in use');
      final socket = await Socket.connect('127.0.0.1', port).timeout(timeout);
      socket.destroy();
      return true;
    } on SocketException catch (_) {
      logger.i('Port $port is not in use');
      return false;
    } on TimeoutException catch (_) {
      logger.i('Port $port is not in use');
      return false;
    }
  }

  static Future<void> killProcess(int pid) async {
    if (os == OS.windows) {
      await Process.run('taskkill', ['/F', '/PID', pid.toString()]);
    } else {
      await Process.run('kill', [pid.toString()]);
    }
  }

  static Future<void> checkWritePermission() async {
    try {
      for (var path in [binPath, configPath, logPath, tempPath]) {
        final file = File(p.join(path, 'test'));
        file.createSync();
        file.deleteSync();
      }
    } catch (e) {
      rethrow;
    }
  }
}

late final String execPath;
late final String appPath;
final binPath = p.join(appPath, 'bin');
final configPath = p.join(appPath, 'config');
final logPath = p.join(appPath, 'log');
final tempPath = p.join(appPath, 'temp');
