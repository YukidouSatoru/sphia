import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/notifier/config/sphia_config.dart';
import 'package:sphia/app/notifier/visible.dart';
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
import 'package:sphia/view/widget/navigation_rail.dart' as sphia_rail;
import 'package:sphia/view/widget/updat.dart';
import 'package:sphia/view/widget/window_caption.dart';
import 'package:sphia/view/wrapper/tray.dart';
import 'package:window_manager/window_manager.dart';

part 'app.g.dart';

@riverpod
class NavigationIndexNotifier extends _$NavigationIndexNotifier {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

class SphiaApp extends ConsumerStatefulWidget {
  const SphiaApp({
    super.key,
  });

  @override
  ConsumerState<SphiaApp> createState() => _SphiaAppState();
}

class _SphiaAppState extends ConsumerState<SphiaApp> with WindowListener {
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
    final index = ref.watch(navigationIndexNotifierProvider);
    final navigationStyle = ref.watch(
        sphiaConfigNotifierProvider.select((value) => value.navigationStyle));
    final darkMode = ref
        .watch(sphiaConfigNotifierProvider.select((value) => value.darkMode));
    final useMaterial3 = ref.watch(
        sphiaConfigNotifierProvider.select((value) => value.useMaterial3));
    final themeColor = ref
        .watch(sphiaConfigNotifierProvider.select((value) => value.themeColor));
    dynamic navigation;

    if (navigationStyle == NavigationStyle.rail) {
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
              brightness: darkMode ? Brightness.dark : Brightness.light,
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
        useMaterial3,
        darkMode,
        themeColor,
        context,
      ),
      home: TrayWrapper(
        child: Scaffold(
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
                        index: index,
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
          floatingActionButton: navigationStyle == NavigationStyle.drawer
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SphiaUpdatWidget(darkMode),
                    _getDrawerFloatingButton(),
                  ],
                )
              : null,
          floatingActionButtonLocation:
              navigationStyle == NavigationStyle.drawer
                  ? FloatingActionButtonLocation.miniStartFloat
                  : null,
        ),
      ),
    );
  }

  Widget _getDrawerFloatingButton() {
    final darkMode = ref
        .watch(sphiaConfigNotifierProvider.select((value) => value.darkMode));
    return Container(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: FloatingActionButton(
        isExtended: true,
        elevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        disabledElevation: 0,
        foregroundColor: darkMode ? Colors.white : Colors.black,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        focusColor: Colors.transparent,
        onPressed: () {
          final notifier = ref.read(sphiaConfigNotifierProvider.notifier);
          notifier.updateValue('darkMode', !darkMode);
        },
        child: Icon(
          darkMode ? Icons.light_mode : Icons.dark_mode,
        ),
      ),
    );
  }

  NavigationDrawer _getNavigationDrawer(BuildContext context) {
    final index = ref.watch(navigationIndexNotifierProvider);
    return NavigationDrawer(
      selectedIndex: index,
      onDestinationSelected: (idx) {
        ref.read(navigationIndexNotifierProvider.notifier).setIndex(idx);
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
    final darkMode = ref
        .watch(sphiaConfigNotifierProvider.select((value) => value.darkMode));
    final index = ref.watch(navigationIndexNotifierProvider);
    return sphia_rail.NavigationRail(
      selectedIndex: index,
      onDestinationSelected: (index) {
        ref.read(navigationIndexNotifierProvider.notifier).setIndex(index);
      },
      trailing: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SphiaUpdatWidget(darkMode),
              Container(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: FloatingActionButton(
                  isExtended: true,
                  elevation: 0,
                  focusElevation: 0,
                  highlightElevation: 0,
                  hoverElevation: 0,
                  disabledElevation: 0,
                  foregroundColor: darkMode ? Colors.white : Colors.black,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onPressed: () {
                    final notifier =
                        ref.read(sphiaConfigNotifierProvider.notifier);
                    notifier.updateValue('darkMode', !darkMode);
                  },
                  child: Icon(
                    darkMode ? Icons.light_mode : Icons.dark_mode,
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
  void onWindowFocus() {
    super.onWindowFocus();
    final visibleNotifier = ref.read(visibleNotifierProvider.notifier);
    visibleNotifier.set(true);
  }

  @override
  void onWindowClose() async {
    final visibleNotifier = ref.read(visibleNotifierProvider.notifier);
    visibleNotifier.set(false);
    // Prevent close
    await windowManager.hide();
  }
}
