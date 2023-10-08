import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sphia/app/provider/core.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/page/wrapper.dart';

class LogPage extends StatefulWidget {
  const LogPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  bool _previousCoreRunning = false;
  final List<String> _logList = [];
  StreamSubscription<String>? _logSubscription;
  final _scrollController = ScrollController();
  bool isUserScrolling = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _removeLogListener();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sphiaConfigProvider = Provider.of<SphiaConfigProvider>(context);
    final coreProvider = Provider.of<CoreProvider>(context);
    if (_previousCoreRunning != coreProvider.coreRunning) {
      _previousCoreRunning = coreProvider.coreRunning;
      if (sphiaConfigProvider.config.enableCoreLog &&
          coreProvider.coreRunning) {
        _scrollController.addListener(() {
          if (_scrollController.position.userScrollDirection !=
              ScrollDirection.idle) {
            isUserScrolling = true;
          }
        });
        _logList.addAll(coreProvider.cores.last.preLogList);
        _listenToLogs();
      } else {
        _removeLogListener();
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).log),
        elevation: 0,
      ),
      body: PageWrapper(
        child: PageView(
          children: [
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: sphiaConfigProvider.config.enableCoreLog &&
                      coreProvider.cores.isNotEmpty
                  ? SingleChildScrollView(
                      controller: _scrollController,
                      child: SelectableText(
                        _logList.join('\n'),
                        style: const TextStyle(
                          fontFamily: 'Courier New',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Center(
                      child: Text(S.of(context).noLogsAvailable),
                    ),
            )
          ],
        ),
      ),
    );
  }

  void _listenToLogs() {
    final coreProvider = GetIt.I.get<CoreProvider>();
    _logSubscription = coreProvider.cores.last.logStream.listen((log) {
      _addLog(log);
    });
  }

  void _removeLogListener() {
    _logList.clear();
    isUserScrolling = false;
    _scrollController.removeListener(() {});
    _logSubscription?.cancel();
    _logSubscription = null;
  }

  void _addLog(String log) {
    final sphiaConfigProvider = GetIt.I.get<SphiaConfigProvider>();
    if (log.trim().isNotEmpty && log.trim() != '\n') {
      _logList.add(log);
      if (_logList.length >= sphiaConfigProvider.config.maxLogCount) {
        _logList.removeAt(0);
      }
      setState(() {});
      if (!isUserScrolling) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    }
  }
}
