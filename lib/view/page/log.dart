import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sphia/app/provider/core.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/page/wrapper.dart';
import 'package:window_manager/window_manager.dart';

class LogPage extends StatefulWidget {
  const LogPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> with WindowListener {
  bool _previousCoreRunning = false;
  final List<String> _logList = [];
  StreamSubscription<String>? _logSubscription;
  final _scrollController = ScrollController();
  bool _isUserScrolling = false;
  bool _hasScrollListener = false;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
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
      if (coreProvider.coreRunning &&
          sphiaConfigProvider.config.enableCoreLog) {
        _scrollController.addListener(() {
          if (_scrollController.position.userScrollDirection !=
              ScrollDirection.idle) {
            _isUserScrolling = true;
          }
        });
        _logList.addAll(coreProvider.routing.preLogList);
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
              color: Colors.transparent,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: coreProvider.coreRunning &&
                      sphiaConfigProvider.config.enableCoreLog &&
                      (!sphiaConfigProvider.config.saveCoreLog)
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
    if (!coreProvider.coreRunning) {
      return;
    }
    _hasScrollListener = true;
    _logSubscription = coreProvider.routing.logStream.listen((log) {
      _addLog(log);
    });
  }

  void _removeLogListener({bool background = false}) {
    if (!background) {
      _logList.clear();
    }
    _logSubscription?.cancel();
    _logSubscription = null;
    _isUserScrolling = false;
    if (_hasScrollListener) {
      _scrollController.removeListener(() {});
      _hasScrollListener = false;
    }
  }

  void _addLog(String log) {
    final sphiaConfigProvider = GetIt.I.get<SphiaConfigProvider>();
    final trimLog = log.trim();
    if (trimLog.isNotEmpty &&
        trimLog != '\n' &&
        trimLog != '\r\n' &&
        trimLog != '\r') {
      _logList.add(trimLog);
      if (_logList.length >= sphiaConfigProvider.config.maxLogCount) {
        _logList.removeAt(0);
      }
      if (_isVisible) {
        setState(() {});
      }
      if (_hasScrollListener) {
        if (!_isUserScrolling && _isVisible) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        }
      }
    }
  }

  @override
  void onWindowFocus() {
    setState(() {
      _isVisible = true;
    });
    _listenToLogs();
  }

  @override
  void onWindowClose() {
    setState(() {
      _isVisible = false;
    });
    _removeLogListener(background: true);
  }
}
