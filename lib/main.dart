import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sphia/app/app.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/core.dart';
import 'package:sphia/app/provider/rule_config.dart';
import 'package:sphia/app/provider/server_config.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/provider/task.dart';
import 'package:sphia/app/provider/version_config.dart';
import 'package:sphia/app/tray.dart';
import 'package:sphia/util/system.dart';
import 'package:sphia/view/page/about.dart';
import 'package:window_manager/window_manager.dart';

Future<void> getAppPath() async {
  if (Platform.isLinux && Platform.environment.containsKey('APPIMAGE')) {
    execPath = Platform.environment['APPIMAGE']!;
  } else {
    execPath = Platform.resolvedExecutable;
  }
  if (const bool.fromEnvironment('dart.vm.product')) {
    if (Platform.isLinux) {
      final linuxAppPath = (await getApplicationSupportDirectory()).path;
      final int firstIndex = linuxAppPath.indexOf('/root/');
      if (firstIndex != -1) {
        appPath = linuxAppPath.replaceFirst('/root/',
            '/home/${Platform.environment['SUDO_USER']}/', firstIndex);
      } else {
        appPath = linuxAppPath;
      }
    } else if (Platform.isMacOS) {
      final macAppPath = (await getApplicationSupportDirectory()).path;
      final int firstIndex = macAppPath.indexOf('/var/root/');
      if (firstIndex != -1) {
        appPath = macAppPath.replaceFirst('/var/root/',
            '/Users/${Platform.environment['SUDO_USER']}/', firstIndex);
      } else {
        appPath = macAppPath;
      }
    } else {
      appPath =
          execPath.substring(0, execPath.lastIndexOf(Platform.pathSeparator));
    }
  } else {
    if (Platform.isMacOS) {
      // For debug
      appPath = execPath.substring(0, execPath.lastIndexOf('/Sphia.app'));
    } else {
      appPath =
          execPath.substring(0, execPath.lastIndexOf(Platform.pathSeparator));
    }
  }
}

Future<void> configureApp() async {
  // Get app path
  await getAppPath();

  // Init logger
  if (const bool.fromEnvironment('dart.vm.product')) {
    SphiaLog.initLogger(true, 2, 2);
  } else {
    SphiaLog.initLogger(false, 5, 5);
  }

  // Check dir exists
  SystemUtil.createDirectory(binPath);
  SystemUtil.createDirectory(configPath);
  SystemUtil.createDirectory(logPath);
  SystemUtil.createDirectory(tempPath);

  // Init SystemUtil
  SystemUtil.init();

  final sphiaInfo = '''
  Sphia - a Proxy Handling Intuitive Application
  Full version: $sphiaFullVersion
  Last commit hash: $sphiaLastCommitHash
  OS: ${SystemUtil.os.name}
  Architecture: ${SystemUtil.architecture.name}
  App Path: $appPath
  Exec Path: $execPath
  Bin path: $binPath
  Config path: $configPath
  Log path: $logPath
  Temp path: $tempPath''';

  logger.i(sphiaInfo);

  // Init database
  await SphiaDatabase.init();

  // Load config
  final sphiaConfig = await SphiaDatabase.sphiaConfigDao.loadConfig();
  final serverConfig = await SphiaDatabase.serverConfigDao.loadConfig();
  final ruleConfig = await SphiaDatabase.ruleConfigDao.loadConfig();
  final versionConfig = await SphiaDatabase.versionConfigDao.loadConfig();

  final sphiaConfigProvider = SphiaConfigProvider(sphiaConfig);
  final coreProvider = CoreProvider();
  final taskProvider = TaskProvider();
  final serverConfigProvider = ServerConfigProvider(
    serverConfig,
    await SphiaDatabase.serverGroupDao.getOrderedServerGroups(),
  );
  final ruleConfigProvider = RuleConfigProvider(
    ruleConfig,
    await SphiaDatabase.ruleGroupDao.getOrderedRuleGroups(),
  );
  final versionConfigProvider = VersionConfigProvider(versionConfig);

  // Register providers
  final getIt = GetIt.I;
  getIt.registerSingleton<SphiaConfigProvider>(sphiaConfigProvider);
  getIt.registerSingleton<CoreProvider>(coreProvider);
  getIt.registerSingleton<TaskProvider>(taskProvider);
  getIt.registerSingleton<ServerConfigProvider>(serverConfigProvider);
  getIt.registerSingleton<RuleConfigProvider>(ruleConfigProvider);
  getIt.registerSingleton<VersionConfigProvider>(versionConfigProvider);

  // Print versions of cores
  final versions = versionConfigProvider.generateLog();
  if (versions.isNotEmpty) {
    logger.i(versions);
  }

  // Init tray
  SphiaTray.init();

  // Configure system proxy and startup
  // SystemUtil.configureSystemProxy();
  // SystemUtil.configureStartup();

  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(1152, 720),
    center: true,
    minimumSize: Size(980, 720),
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setAlignment(Alignment.center);
    await windowManager.setMinimumSize(const Size(980, 720));
    await windowManager.show();
    await windowManager.focus();
  });

  // Run app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => getIt.get<SphiaConfigProvider>(),
        ),
        ChangeNotifierProvider(
          create: (context) => getIt.get<CoreProvider>(),
        ),
        ChangeNotifierProvider(
          create: (context) => getIt.get<TaskProvider>(),
        ),
        ChangeNotifierProvider(
          create: (context) => getIt.get<ServerConfigProvider>(),
        ),
        ChangeNotifierProvider(
          create: (context) => getIt.get<RuleConfigProvider>(),
        ),
        ChangeNotifierProvider(
          create: (context) => getIt.get<VersionConfigProvider>(),
        ),
      ],
      child: const SphiaApp(),
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureApp();
}
