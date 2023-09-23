import 'dart:io';

import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:sphia/util/system.dart';

class MyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}

late final Logger logger;

class SphiaLog {
  static final DateFormat formatter = DateFormat('yyyy-MM-dd-HH-mm-ss');

  static void initLogger(bool saveLog, int methodCount, int errorMethodCount) {
    final String now = formatter.format(DateTime.now());
    logger = Logger(
      level: Level.verbose,
      filter: MyFilter(),
      printer: PrettyPrinter(
        colors: false,
        printTime: true,
        errorMethodCount: errorMethodCount,
        methodCount: methodCount,
        noBoxingByDefault: true,
      ),
      output: saveLog
          ? FileOutput(file: File(p.join(logPath, 'sphia-$now.log')))
          : null,
    );
  }
}
