import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/theme.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/page/about.dart';
import 'package:sphia/view/page/dashboard.dart';
import 'package:sphia/view/page/log.dart';
import 'package:sphia/view/page/rule.dart';
import 'package:sphia/view/page/server.dart';
import 'package:sphia/view/page/setting.dart';
import 'package:sphia/view/page/update.dart';
import 'package:window_manager/window_manager.dart';

class SphiaApp extends StatefulWidget {
  const SphiaApp({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SphiaAppState();
}

class _SphiaAppState extends State<SphiaApp> with WindowListener {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _init();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  void _init() async {
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final sphiaConfigProvider = Provider.of<SphiaConfigProvider>(context);
    final sphiaConfig = sphiaConfigProvider.config;

    NavigationRail? rail;
    NavigationDrawer? drawer;

    if (sphiaConfig.navigationStyle == 'rail') {
      rail = NavigationRail(
        selectedIndex: _index,
        onDestinationSelected: (index) {
          setState(() {
            _index = index;
          });
        },
        trailing: Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: FloatingActionButton(
                isExtended: true,
                elevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
                hoverElevation: 0,
                disabledElevation: 0,
                foregroundColor:
                    sphiaConfig.darkMode ? Colors.white : Colors.black,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                focusColor: Colors.transparent,
                onPressed: () {
                  logger.i(
                      'Updating darkMode from ${sphiaConfig.darkMode} to ${!sphiaConfig.darkMode}');
                  sphiaConfig.darkMode = !sphiaConfig.darkMode;
                  sphiaConfigProvider.saveConfig();
                },
                child: Icon(
                  sphiaConfig.darkMode ? Icons.light_mode : Icons.dark_mode,
                ),
              ),
            ),
          ),
        ),
        destinations: [
          NavigationRailDestination(
            icon: const Icon(Icons.dashboard),
            label: Builder(
              builder: (context) => Text(
                S.of(context).dashboard,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.folder),
            label: Builder(
              builder: (context) => Text(
                S.of(context).servers,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.rule),
            label: Builder(
              builder: (context) => Text(
                S.of(context).rules,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.settings),
            label: Builder(
              builder: (context) => Text(
                S.of(context).settings,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.upgrade),
            label: Builder(
              builder: (context) => Text(
                S.of(context).update,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.description),
            label: Builder(
              builder: (context) => Text(
                S.of(context).log,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.info),
            label: Builder(
              builder: (context) => Text(
                S.of(context).about,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      );
    } else {
      drawer = NavigationDrawer(
        selectedIndex: _index,
        onDestinationSelected: (index) {
          setState(() {
            _index = index;
          });
        },
        children: [
          NavigationDrawerDestination(
            icon: const Icon(Icons.dashboard),
            label: Flexible(
              child: Builder(
                builder: (context) => Text(
                  S.of(context).dashboard,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.folder),
            label: Flexible(
              child: Builder(
                builder: (context) => Text(
                  S.of(context).servers,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.rule),
            label: Flexible(
              child: Builder(
                builder: (context) => Text(
                  S.of(context).rules,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.settings),
            label: Flexible(
              child: Builder(
                builder: (context) => Text(
                  S.of(context).settings,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.upgrade),
            label: Flexible(
              child: Builder(
                builder: (context) => Text(
                  S.of(context).update,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.description),
            label: Flexible(
              child: Builder(
                builder: (context) => Text(
                  S.of(context).log,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.info),
            label: Flexible(
              child: Builder(
                builder: (context) => Text(
                  S.of(context).about,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: SphiaTheme.getThemeData(
        sphiaConfig.useMaterial3,
        sphiaConfig.darkMode,
        sphiaConfig.themeColor,
        context,
      ),
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: [
                  if (sphiaConfig.navigationStyle == 'rail' && rail != null)
                    // Rail
                    rail,
                  if (sphiaConfig.navigationStyle == 'drawer' && drawer != null)
                    // Drawer
                    drawer,
                  // Pages
                  Expanded(
                    child: IndexedStack(
                      index: _index,
                      children: const [
                        Dashboard(),
                        ServerPage(),
                        RulePage(),
                        SettingPage(),
                        UpdatePage(),
                        LogPage(),
                        AboutPage(),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: sphiaConfig.navigationStyle == 'drawer'
            ? Container(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: FloatingActionButton(
                  isExtended: true,
                  elevation: 0,
                  focusElevation: 0,
                  highlightElevation: 0,
                  hoverElevation: 0,
                  disabledElevation: 0,
                  foregroundColor:
                      sphiaConfig.darkMode ? Colors.white : Colors.black,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onPressed: () {
                    logger.i(
                        'Updating darkMode from ${sphiaConfig.darkMode} to ${!sphiaConfig.darkMode}');
                    sphiaConfig.darkMode = !sphiaConfig.darkMode;
                    sphiaConfigProvider.saveConfig();
                  },
                  child: Icon(
                    sphiaConfig.darkMode ? Icons.light_mode : Icons.dark_mode,
                  ),
                ),
              )
            : null,
        floatingActionButtonLocation: sphiaConfig.navigationStyle == 'drawer'
            ? FloatingActionButtonLocation.miniStartFloat
            : null,
      ),
    );
  }

  @override
  void onWindowClose() async {
    // Prevent close
    await windowManager.hide();
  }
}
