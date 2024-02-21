import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/util/system.dart';
import 'package:sphia/core/helper.dart';

abstract class Core {
  String name;
  List<String> args;
  late String configFileName;
  late final File _configFile = File(p.join(tempPath, configFileName));
  Process? _process;
  bool _isPreLog = true;
  final List<String> preLogList = [];
  final _logStreamController = StreamController<String>.broadcast();
  List<Server> servers = [];
  bool isRouting = false;

  Stream<String> get logStream => _logStreamController.stream;

  Core(this.name, this.args, this.configFileName);

  Future<void> start() async {
    if (!CoreHelper.coreExists(name)) {
      logger.e('Core $name does not exist');
      throw Exception('Core $name does not exist');
    }

    await configure();
    logger.i('Starting core: $name');
    try {
      _process = await Process.start(
        p.join(binPath, CoreHelper.getCoreFileName(name)),
        args,
      );
    } on ProcessException catch (e) {
      logger.e('Failed to start $name: ${e.message}');
      throw Exception('Failed to start $name: ${e.message}');
    }

    if (_process == null) {
      logger.e('Core Process is null');
      throw Exception('Core Process is null');
    }

    listenToProcessStream(_process!.stdout);
    listenToProcessStream(_process!.stderr);

    try {
      if (await _process?.exitCode.timeout(const Duration(milliseconds: 500)) !=
          0) {
        throw Exception('\n${preLogList.join('\n')}');
      }
    } on TimeoutException catch (_) {
      _isPreLog = false;
    }
  }

  Future<void> stop() async {
    if (_process == null) {
      logger.w('Core process is null');
      return;
    }
    logger.i('Stopping core: $name');
    _process!.kill();
    final pid = _process!.pid;
    _process = null;
    // check if port is still in use
    await Future.delayed(const Duration(milliseconds: 100));
    if (await CoreHelper.coreIsStillRunning(isRouting, name)) {
      logger.w('Detected core $name is still running, killing process: $pid');
      await SystemUtil.killProcess(pid);
    }

    SystemUtil.deleteFileIfExists(
      _configFile.path,
      'Deleting config file: $configFileName',
    );
    if (name == 'sing-box') {
      SystemUtil.deleteFileIfExists(
        p.join(tempPath, 'cache.db'),
        'Deleting cache file: cache.db',
      );
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

  Future<void> configure();

  Future<String> generateConfig(ConfigParameters parameters);

  Future<void> writeConfig(String jsonString) async {
    SystemUtil.deleteFileIfExists(
        _configFile.path, 'Deleting config file: $configFileName');
    logger.i('Writing config file: $configFileName');
    await _configFile.writeAsString(jsonString);
  }
}

abstract class ConfigParameters {}
