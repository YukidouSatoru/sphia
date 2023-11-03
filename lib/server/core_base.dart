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
  bool isPreLog = true;
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

    listenToProcessStream(coreProcess!.stdout);
    listenToProcessStream(coreProcess!.stderr);

    try {
      if (await coreProcess?.exitCode
              .timeout(const Duration(milliseconds: 500)) !=
          0) {
        throw Exception('\n${_preLogList.join('\n')}');
      }
    } on TimeoutException catch (_) {
      isPreLog = false;
    }
  }

  Future<void> stop() async {
    if (coreProcess != null) {
      logger.i('Stopping core: $coreName');
      coreProcess?.kill(ProcessSignal.sigterm);
      await coreProcess?.exitCode.timeout(const Duration(milliseconds: 500),
          onTimeout: () {
        coreProcess?.kill(ProcessSignal.sigkill);
        return Future.error(
            'Failed to stop $coreName, force killed the process.');
      });
      coreProcess = null;
    }
    deleteFileIfExists(configFile, 'Deleting config file: $configFileName');
    if (coreName == 'sing-box') {
      final cacheFile = File(p.join(tempPath, 'cache.db'));
      deleteFileIfExists(cacheFile, 'Deleting cache file: cache.db');
    }
    if (!logStreamController.isClosed) {
      await logStreamController.close();
    }
  }

  void listenToProcessStream(Stream<List<int>> stream) {
    stream.transform(utf8.decoder).listen((data) {
      if (data.trim().isNotEmpty) {
        logStreamController.add(data);
        if (isPreLog) {
          _preLogList.add(data);
        }
      }
    });
  }

  Future<void> deleteFileIfExists(File file, String logMessage) async {
    if (await file.exists()) {
      logger.i(logMessage);
      await file.delete();
    }
  }

  Future<void> configure(ServerBase server);

  Future<String> generateConfig(ServerBase server);

  Future<void> writeConfig(String jsonString) async {
    if (await configFile.exists()) {
      await configFile.delete();
    }
    await configFile.writeAsString(jsonString);
  }
}
