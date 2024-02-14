import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/theme.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/util/system.dart';
import 'package:sphia/view/page/about.dart';
import 'package:sphia/view/page/dashboard.dart';
import 'package:sphia/view/page/log.dart';
import 'package:sphia/view/page/rule.dart';
import 'package:sphia/view/page/server.dart';
import 'package:sphia/view/page/setting.dart';
import 'package:sphia/view/page/update.dart';
import 'package:sphia/view/widget/updat.dart';
import 'package:sphia/view/widget/window_caption.dart';
import 'package:sphia/view/widget/navigation_rail.dart' as sphia_rail;
import 'package:window_manager/window_manager.dart';

class SphiaApp extends StatefulWidget {
  const SphiaApp({
    super.key,
  });

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
    if (SystemUtil.os != OS.macos) {
      await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    } else {
      await windowManager.setTitle('Sphia - $sphiaVersion');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final sphiaConfigProvider = Provider.of<SphiaConfigProvider>(context);
    final sphiaConfig = sphiaConfigProvider.config;
    dynamic navigation;

    if (sphiaConfig.navigationStyle == NavigationStyle.rail.index) {
      navigation = _getNavigationRail(context);
    } else {
      navigation = _getNavigationDrawer(context);
    }

    final titleTextStyle = Theme.of(context).textTheme.titleLarge!.copyWith(
          fontSize: 14.5,
          fontFamily: 'Verdana',
          color: Colors.grey[500],
        );

    final titleText = Text(
      'Sphia - $sphiaVersion',
      style: titleTextStyle,
      textAlign: TextAlign.center,
    );

    // on macOS, the title bar is handled by the system
    // else, use the custom title bar
    final titleBar = PreferredSize(
      preferredSize: const Size.fromHeight(kWindowCaptionHeight),
      child: SystemUtil.os == OS.macos
          ? Center(
              child: titleText,
            )
          : SphiaWindowCaption(
              title: titleText,
              backgroundColor: Colors.transparent,
              brightness:
                  sphiaConfig.darkMode ? Brightness.dark : Brightness.light,
            ),
    );

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
        appBar: titleBar,
        body: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: [
                  navigation,
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
        floatingActionButton:
            sphiaConfig.navigationStyle == NavigationStyle.drawer.index
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SphiaUpdatWidget().updatWidget(),
                      _getDrawerFloatingButton(),
                    ],
                  )
                : null,
        floatingActionButtonLocation:
            sphiaConfig.navigationStyle == NavigationStyle.drawer.index
                ? FloatingActionButtonLocation.miniStartFloat
                : null,
      ),
    );
  }

  Widget _getDrawerFloatingButton() {
    final sphiaConfigProvider = Provider.of<SphiaConfigProvider>(context);
    final sphiaConfig = sphiaConfigProvider.config;
    return Container(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: FloatingActionButton(
        isExtended: true,
        elevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        disabledElevation: 0,
        foregroundColor: sphiaConfig.darkMode ? Colors.white : Colors.black,
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
    );
  }

  NavigationDrawer _getNavigationDrawer(BuildContext context) {
    return NavigationDrawer(
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

  sphia_rail.NavigationRail _getNavigationRail(BuildContext context) {
    final sphiaConfigProvider = Provider.of<SphiaConfigProvider>(context);
    final sphiaConfig = sphiaConfigProvider.config;
    return sphia_rail.NavigationRail(
      selectedIndex: _index,
      onDestinationSelected: (index) {
        setState(() {
          _index = index;
        });
      },
      trailing: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SphiaUpdatWidget().updatWidget(),
              Container(
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
            ],
          ),
        ),
      ),
      destinations: [
        sphia_rail.NavigationRailDestination(
          icon: const Icon(Icons.dashboard),
          label: Builder(
            builder: (context) => Text(
              S.of(context).dashboard,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        sphia_rail.NavigationRailDestination(
          icon: const Icon(Icons.folder),
          label: Builder(
            builder: (context) => Text(
              S.of(context).servers,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        sphia_rail.NavigationRailDestination(
          icon: const Icon(Icons.rule),
          label: Builder(
            builder: (context) => Text(
              S.of(context).rules,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        sphia_rail.NavigationRailDestination(
          icon: const Icon(Icons.settings),
          label: Builder(
            builder: (context) => Text(
              S.of(context).settings,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        sphia_rail.NavigationRailDestination(
          icon: const Icon(Icons.upgrade),
          label: Builder(
            builder: (context) => Text(
              S.of(context).update,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        sphia_rail.NavigationRailDestination(
          icon: const Icon(Icons.description),
          label: Builder(
            builder: (context) => Text(
              S.of(context).log,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        sphia_rail.NavigationRailDestination(
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
  }

  @override
  void onWindowClose() async {
    // Prevent close
    await windowManager.hide();
  }
}
