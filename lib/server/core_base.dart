import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/server/server_base.dart';
import 'package:sphia/util/system.dart';

abstract class CoreBase {
  String coreName;
  List<String> coreArgs;
  late String configFileName;
  late File configFile = File(p.join(tempPath, configFileName));
  Process? coreProcess;
  bool isPreLog = true;
  final List<String> preLogList = [];
  final logStreamController = StreamController<String>.broadcast();
  late final Server runningServer;

  Stream<String> get logStream => logStreamController.stream;

  CoreBase(this.coreName, this.coreArgs, this.configFileName);

  Future<void> start(Server server) async {
    late final ServerBase serverBase;

    runningServer = server;
    serverBase = ServerBase.fromJson(jsonDecode(server.data));

    await configure(serverBase);

    if (!SystemUtil.coreExists(coreName)) {
      logger.e('Core $coreName does not exist');
      throw Exception('Core $coreName does not exist');
    }
    logger.i('Starting core: $coreName');
    try {
      coreProcess = await Process.start(
        p.join(binPath, SystemUtil.getCoreFileName(coreName)),
        coreArgs,
      );
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
        throw Exception('\n${preLogList.join('\n')}');
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
    SystemUtil.deleteFileIfExists(
        configFile.path, 'Deleting config file: $configFileName');
    if (coreName == 'sing-box') {
      SystemUtil.deleteFileIfExists(
          p.join(tempPath, 'cache.db'), 'Deleting cache file: cache.db');
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
          preLogList.add(data);
        }
      }
    });
  }

  Future<void> configure(ServerBase server);

  Future<String> generateConfig(ServerBase server);

  Future<void> writeConfig(String jsonString) async {
    SystemUtil.deleteFileIfExists(
        configFile.path, 'Deleting config file: $configFileName');
    await configFile.writeAsString(jsonString);
  }
}
