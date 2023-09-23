import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/rule_config.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/server/server_base.dart';
import 'package:sphia/util/system.dart';

abstract class CoreBase {
  final sphiaConfigProvider = GetIt.I.get<SphiaConfigProvider>();
  final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
  final ruleConfig = GetIt.I.get<RuleConfigProvider>().config;
  String coreName;
  List<String> coreArgs;
  late String configFileName;
  late File configFile = File(p.join(tempPath, configFileName));
  Process? coreProcess;
  final logStreamController = StreamController<String>.broadcast();
  String? coreLogPath;
  bool _isPreLog = true;
  final List<String> _preLogList = [];
  late final Server runningServer;

  Stream<String> get logStream => logStreamController.stream;

  List<String> get preLogList => _preLogList;

  CoreBase(this.coreName, this.coreArgs, this.configFileName);

  Future<void> start(Server server) async {
    late final ServerBase serverBase;

    runningServer = server;
    serverBase = ServerBase.fromJson(jsonDecode(server.data));

    if (sphiaConfig.saveCoreLog) {
      final String now = SphiaLog.formatter.format(DateTime.now());
      coreLogPath = p.join(logPath, '$coreName-$now.log');
    }

    // logger.i('Generating config');
    await configure(serverBase);

    logger.i('Starting core: $coreName');
    try {
      coreProcess = await Process.start(
          p.join(binPath, SystemUtil.getCoreFileName(coreName)), coreArgs);
    } on ProcessException catch (e) {
      logger.e('Failed to start $coreName: ${e.message}');
      throw Exception('Failed to start $coreName: ${e.message}');
    }

    if (coreProcess == null) {
      throw Exception('Core Process is null');
    }

    coreProcess!.stdout.transform(utf8.decoder).listen((data) {
      if (data.trim().isNotEmpty) {
        logStreamController.add(data);
        if (_isPreLog) {
          _preLogList.add(data);
        }
      }
    });

    coreProcess!.stderr.transform(utf8.decoder).listen((data) {
      if (data.trim().isNotEmpty) {
        logStreamController.add(data);
        if (_isPreLog) {
          _preLogList.add(data);
        }
      }
    });

    try {
      if (await coreProcess!.exitCode
              .timeout(const Duration(milliseconds: 500)) !=
          0) {
        throw Exception('\n${_preLogList.join('\n')}');
      }
    } on TimeoutException catch (_) {
      _isPreLog = false;
    }
  }

  Future<void> stop() async {
    if (coreProcess != null) {
      logger.i('Stopping core: $coreName');
      coreProcess!.kill(ProcessSignal.sigterm);
      await coreProcess!.exitCode.timeout(const Duration(milliseconds: 500),
          onTimeout: () {
        coreProcess!.kill(ProcessSignal.sigkill);
        return Future.error(
            'Failed to stop $coreName, force killed the process.');
      });
      coreProcess = null;
    }
    if (configFileName.isNotEmpty) {
      if (await configFile.exists()) {
        logger.i('Deleting config file: $configFileName');
        await configFile.delete();
      }
    }
    if (coreName == 'sing-box') {
      logger.i('Deleting cache file: cache.db');
      final cacheFile = File(p.join(tempPath, 'cache.db'));
      if (await cacheFile.exists()) {
        await cacheFile.delete();
      }
    }
    if (!logStreamController.isClosed) {
      await logStreamController.close();
    }
  }

  Future<void> configure(ServerBase server);

  Future<void> writeConfig(String jsonString) async {
    if (await configFile.exists()) {
      await configFile.delete();
    }
    await configFile.writeAsString(jsonString);
  }
}
