import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sphia/app/notifier/config/sphia_config.dart';
import 'package:sphia/app/notifier/core_state.dart';
import 'package:sphia/app/notifier/proxy.dart';
import 'package:sphia/app/notifier/visible.dart';
import 'package:sphia/app/state/core_state.dart';
import 'package:sphia/app/state/proxy.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/wrapper/page.dart';

class LogPage extends ConsumerStatefulWidget {
  const LogPage({
    super.key,
  });

  @override
  ConsumerState<LogPage> createState() => _LogPageState();
}

class _LogPageState extends ConsumerState<LogPage> {
  final List<String> _logList = [];
  StreamSubscription<String>? _logSubscription;
  final _scrollController = ScrollController();
  bool _isUserScrolling = false;
  bool _hasScrollListener = false;

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
    final enableCoreLog = ref.watch(
        sphiaConfigNotifierProvider.select((value) => value.enableCoreLog));
    final saveCoreLog = ref.watch(
        sphiaConfigNotifierProvider.select((value) => value.saveCoreLog));
    final coreRunning =
        ref.watch(proxyNotifierProvider.select((value) => value.coreRunning));
    void proxyListener(ProxyState? previous, ProxyState next) {
      if (previous != null) {
        if (previous.coreRunning != next.coreRunning) {
          if (next.coreRunning && enableCoreLog && (!saveCoreLog)) {
            _scrollController.addListener(() {
              if (_scrollController.position.userScrollDirection !=
                  ScrollDirection.idle) {
                _isUserScrolling = true;
              }
            });
            final coreState = ref.read(coreStateNotifierProvider).valueOrNull;
            if (coreState != null && coreState.cores.isNotEmpty) {
              _logList.addAll(coreState.routing.preLogList);
              final visible = ref.read(visibleNotifierProvider);
              _listenToLogs();
              if (!visible) {
                _removeLogListener(background: true);
              }
            }
          } else {
            _removeLogListener();
          }
        }
      }
    }

    ref.listen(proxyNotifierProvider, proxyListener);
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
              child: coreRunning && enableCoreLog && (!saveCoreLog)
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
            ),
          ],
        ),
      ),
    );
  }

  void _listenToLogs() {
    _hasScrollListener = true;
    final coreState = ref.watch(coreStateNotifierProvider).valueOrNull;
    if (coreState != null) {
      _logSubscription = coreState.logStream.listen((log) {
        _addLog(log);
      });
    }
  }

  void _removeLogListener({bool background = false}) {
    if (!background) {
      _logList.clear();
    }
    _logSubscription?.cancel();
    _logSubscription = null;
    _isUserScrolling = false;
    if (_hasScrollListener) {
      _scrollController.removeListener(() {
        if (_scrollController.position.userScrollDirection !=
            ScrollDirection.idle) {
          _isUserScrolling = true;
        }
      });
      _hasScrollListener = false;
      if (!background) {
        _scrollController.jumpTo(0);
      }
    }
  }

  void _addLog(String log) {
    final maxLogCount = ref.watch(
        sphiaConfigNotifierProvider.select((value) => value.maxLogCount));
    final visible = ref.watch(visibleNotifierProvider);
    final trimLog = log.trim();
    if (trimLog.isNotEmpty &&
        trimLog != '\n' &&
        trimLog != '\r\n' &&
        trimLog != '\r') {
      _logList.add(trimLog);
      if (_logList.length >= maxLogCount) {
        _logList.removeAt(0);
      }
      if (visible) {
        setState(() {
          // trigger rebuild
        });
      }
      if (_hasScrollListener) {
        if (!_isUserScrolling && visible) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          }
        }
      }
    }
  }
}
