import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sphia/app/app.dart';
import 'package:sphia/app/config/rule.dart';
import 'package:sphia/app/config/server.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/config/version.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/config.dart';
import 'package:sphia/app/provider/data.dart';
import 'package:sphia/util/system.dart';
import 'package:sphia/util/tray.dart';
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

  // Check write permission
  try {
    await SystemUtil.checkWritePermission();
  } catch (e) {
    await showErrorMsg('An error occurred while checking write permission: $e');
    return;
  }

  late final SphiaConfig sphiaConfig;
  late final ServerConfig serverConfig;
  late final RuleConfig ruleConfig;
  late final VersionConfig versionConfig;

  // Load config
  try {
    sphiaConfig = await sphiaConfigDao.loadConfig();
    serverConfig = await serverConfigDao.loadConfig();
    ruleConfig = await ruleConfigDao.loadConfig();
    versionConfig = await versionConfigDao.loadConfig();
  } catch (e) {
    await SphiaDatabase.backupDatabase();
    final errorMsg = '''
    An error occurred while loading config: $e
    Current database file has been backuped to ${p.join(tempPath, 'sphia.db.bak')}
    Please restart Sphia to create a new database file''';
    logger.e(errorMsg);
    await showErrorMsg(errorMsg);
    return;
  }

  // Print versions of cores
  final versions = versionConfig.generateLog();
  if (versions.isNotEmpty) {
    logger.i(versions);
  }

  // Load data
  final serverGroups = await serverGroupDao.getOrderedServerGroups();
  final serverGroupId = serverConfig.selectedServerGroupId;
  final servers =
      await serverDao.getOrderedServerModelsByGroupId(serverGroupId);
  final serversLite = servers.map((e) => e.toLite()).toList();
  final ruleGroupId = ruleConfig.selectedRuleGroupId;
  final ruleGroups = await ruleGroupDao.getOrderedRuleGroups();
  final rules = await ruleDao.getOrderedRuleModelsByGroupId(ruleGroupId);

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

  if (SystemUtil.os != OS.linux) {
    // Build tray
    logger.i('Building tray');
    await TrayUtil.setIcon(coreRunning: false);
  }

  // Run app
  runApp(
    ProviderScope(
      overrides: [
        sphiaConfigProvider.overrideWithValue(sphiaConfig),
        serverConfigProvider.overrideWithValue(serverConfig),
        ruleConfigProvider.overrideWithValue(ruleConfig),
        versionConfigProvider.overrideWithValue(versionConfig),
        serverGroupsProvider.overrideWithValue(serverGroups),
        serversProvider.overrideWithValue(servers),
        serversLiteProvider.overrideWithValue(serversLite),
        ruleGroupsProvider.overrideWithValue(ruleGroups),
        rulesProvider.overrideWithValue(rules),
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
    await windowManager.setMinimumSize(const Size(600, 450));
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
