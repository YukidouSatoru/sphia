import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/util/system.dart';

abstract class Core {
  String coreName;
  List<String> coreArgs;
  late String configFileName;
  late final File _configFile = File(p.join(tempPath, configFileName));
  Process? _coreProcess;
  bool _isPreLog = true;
  final List<String> preLogList = [];
  final _logStreamController = StreamController<String>.broadcast();
  List<int> serverId = [];
  bool isRouting = false;

  Stream<String> get logStream => _logStreamController.stream;

  Core(this.coreName, this.coreArgs, this.configFileName);

  Future<void> start(Server selectedServer) async {
    await configure(selectedServer);

    if (!SystemUtil.coreExists(coreName)) {
      logger.e('Core $coreName does not exist');
      throw Exception('Core $coreName does not exist');
    }
    logger.i('Starting core: $coreName');
    try {
      _coreProcess = await Process.start(
        p.join(binPath, SystemUtil.getCoreFileName(coreName)),
        coreArgs,
      );
    } on ProcessException catch (e) {
      logger.e('Failed to start $coreName: ${e.message}');
      throw Exception('Failed to start $coreName: ${e.message}');
    }

    if (_coreProcess == null) {
      throw Exception('Core Process is null');
    }

    listenToProcessStream(_coreProcess!.stdout);
    listenToProcessStream(_coreProcess!.stderr);

    try {
      if (await _coreProcess?.exitCode
              .timeout(const Duration(milliseconds: 500)) !=
          0) {
        throw Exception('\n${preLogList.join('\n')}');
      }
    } on TimeoutException catch (_) {
      _isPreLog = false;
    }
  }

  Future<void> stop() async {
    if (_coreProcess != null) {
      logger.i('Stopping core: $coreName');
      _coreProcess?.kill(ProcessSignal.sigterm);
      await _coreProcess?.exitCode.timeout(const Duration(milliseconds: 500),
          onTimeout: () {
        _coreProcess?.kill(ProcessSignal.sigkill);
        return Future.error(
            'Failed to stop $coreName, force killed the process.');
      });
      _coreProcess = null;
    }
    SystemUtil.deleteFileIfExists(
        _configFile.path, 'Deleting config file: $configFileName');
    if (coreName == 'sing-box') {
      SystemUtil.deleteFileIfExists(
          p.join(tempPath, 'cache.db'), 'Deleting cache file: cache.db');
    }
    if (!_logStreamController.isClosed) {
      await _logStreamController.close();
    }
  }

  void listenToProcessStream(Stream<List<int>> stream) {
    stream.transform(utf8.decoder).listen((data) {
      if (data.trim().isNotEmpty) {
        _logStreamController.add(data);
        if (_isPreLog) {
          preLogList.add(data);
        }
      }
    });
  }

  Future<void> configure(Server selectedServer);

  Future<String> generateConfig(List<Server> servers);

  Future<void> writeConfig(String jsonString) async {
    SystemUtil.deleteFileIfExists(
        _configFile.path, 'Deleting config file: $configFileName');
    logger.i('Writing config file: $configFileName');
    await _configFile.writeAsString(jsonString);
  }
}
