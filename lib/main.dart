import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sphia/app/app.dart';
import 'package:sphia/app/config/rule.dart';
import 'package:sphia/app/config/server.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/config/version.dart';
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

const methodCount = 2;
const errorMethodCount = 2;
const debugMethodCount = 5;
const debugErrorMethodCount = 5;

Future<void> getAppPath() async {
  if (Platform.isLinux && Platform.environment.containsKey('APPIMAGE')) {
    execPath = Platform.environment['APPIMAGE']!;
  } else {
    execPath = Platform.resolvedExecutable;
  }
  if (const bool.fromEnvironment('dart.vm.product')) {
    if (Platform.isLinux || Platform.isMacOS) {
      appPath = await getAppPathForUnix();
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

Future<String> getAppPathForUnix() async {
  final rootPath = Platform.isLinux ? '/root/' : '/var/root/';
  final userPath = Platform.isLinux
      ? '/home/${Platform.environment['SUDO_USER']}/'
      : '/Users/${Platform.environment['SUDO_USER']}/';
  final appPath = (await getApplicationSupportDirectory()).path;
  final rootIndex = appPath.indexOf(rootPath);
  if (rootIndex != -1) {
    return appPath.replaceFirst(rootPath, userPath, rootIndex);
  } else {
    return appPath;
  }
}

Future<void> configureApp() async {
  // Get app path
  await getAppPath();

  // Init logger
  if (const bool.fromEnvironment('dart.vm.product')) {
    SphiaLog.initLogger(true, methodCount, errorMethodCount);
  } else {
    SphiaLog.initLogger(false, debugMethodCount, debugErrorMethodCount);
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
  final SphiaConfig sphiaConfig = await sphiaConfigDao.loadConfig();
  final ServerConfig serverConfig = await serverConfigDao.loadConfig();
  final RuleConfig ruleConfig = await ruleConfigDao.loadConfig();
  final VersionConfig versionConfig = await versionConfigDao.loadConfig();

  final sphiaConfigProvider = SphiaConfigProvider(sphiaConfig);
  final coreProvider = CoreProvider();
  final taskProvider = TaskProvider();
  final serverConfigProvider = ServerConfigProvider(
    serverConfig,
    await serverGroupDao.getOrderedServerGroups(),
  );
  final ruleConfigProvider = RuleConfigProvider(
    ruleConfig,
    await ruleGroupDao.getOrderedRuleGroups(),
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
  try {
    await configureApp();
  } catch (e) {
    if (!logger.isClosed()) {
      logger.f(e);
    }
    await showErrorMsg('An error occurred while starting Sphia: $e');
  }
}

Future<void> showErrorMsg(String errorMsg) async {
  await windowManager.ensureInitialized();
  const errorWindowOptions = WindowOptions(
    size: Size(400, 300),
    center: true,
    minimumSize: Size(400, 300),
    titleBarStyle: TitleBarStyle.hidden,
  );
  await windowManager.waitUntilReadyToShow(errorWindowOptions, () async {
    await windowManager.setAlignment(Alignment.center);
    await windowManager.setMinimumSize(const Size(400, 300));
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(errorMsg),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  exit(1);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
