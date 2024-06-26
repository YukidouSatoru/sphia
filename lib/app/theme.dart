import 'dart:math' show max;

import 'package:flutter/material.dart';

class SphiaTheme {
  static RoundedRectangleBorder listTileShape(bool useMaterial3) => useMaterial3
      ? const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        )
      : const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        );

  static ThemeData getThemeData(bool useMaterial3, bool darkMode,
      int themeColorInt, BuildContext context) {
    final themeColor = Color(themeColorInt);
    if (darkMode) {
      return ThemeData(
        useMaterial3: useMaterial3,
        brightness: Brightness.dark,
        navigationRailTheme: NavigationRailThemeData(
          selectedLabelTextStyle: TextStyle(
            color: themeColor,
          ),
          selectedIconTheme: useMaterial3
              ? null
              : IconThemeData(
                  color: themeColor,
                  opacity: 1.0,
                ),
          unselectedLabelTextStyle: const TextStyle(
            color: Colors.white,
          ),
          unselectedIconTheme: const IconThemeData(
            color: Colors.white,
            opacity: 1.0,
          ),
          labelType: NavigationRailLabelType.all,
          indicatorShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          backgroundColor: Colors.transparent,
        ),
        drawerTheme: DrawerThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          width: max(MediaQuery.of(context).size.width / 7.5 + 15, 150),
        ),
        navigationDrawerTheme: const NavigationDrawerThemeData(
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
        ),
        appBarTheme: AppBarTheme(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: themeColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          toolbarTextStyle: const TextStyle(color: Colors.white),
        ),
        tabBarTheme: TabBarTheme(
          indicatorColor: themeColor,
          labelColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          shape: CircleBorder(),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: themeColor,
          // behavior: SnackBarBehavior.floating,
          elevation: 2,
          // width: MediaQuery.of(context).size.width / 1.75,
          contentTextStyle: const TextStyle(color: Colors.white),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateColor.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return themeColor;
            } else {
              return Colors.white;
            }
          }),
          trackColor: MaterialStateColor.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return themeColor.withOpacity(0.5);
            } else {
              if (useMaterial3) {
                return Colors.transparent;
              } else {
                return Colors.grey;
              }
            }
          }),
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.white,
        ),
        colorScheme: ColorScheme.dark(
          primary: themeColor,
          primaryContainer: themeColor,
          secondary: themeColor,
          secondaryContainer: themeColor,
          surface: Colors.grey[850]!,
          surfaceTint: Colors.grey[100],
        ).copyWith(background: Colors.grey[850]!),
      );
    } else {
      return ThemeData(
        useMaterial3: useMaterial3,
        brightness: Brightness.light,
        navigationRailTheme: NavigationRailThemeData(
          selectedLabelTextStyle: TextStyle(
            color: themeColor,
          ),
          selectedIconTheme: useMaterial3
              ? null
              : IconThemeData(
                  color: themeColor,
                  opacity: 1.0,
                ),
          unselectedLabelTextStyle: const TextStyle(
            color: Colors.black,
          ),
          unselectedIconTheme: const IconThemeData(
            color: Colors.black,
            opacity: 1.0,
          ),
          labelType: NavigationRailLabelType.all,
          indicatorShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          backgroundColor: Colors.transparent,
        ),
        drawerTheme: DrawerThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          width: max(MediaQuery.of(context).size.width / 7.5 + 15, 150),
        ),
        navigationDrawerTheme: const NavigationDrawerThemeData(
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
        ),
        appBarTheme: AppBarTheme(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          foregroundColor: Colors.grey,
          titleTextStyle: TextStyle(
            color: themeColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          toolbarTextStyle: const TextStyle(color: Colors.black),
        ),
        tabBarTheme: TabBarTheme(
          indicatorColor: themeColor,
          labelColor: Colors.black,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          shape: CircleBorder(),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: themeColor,
          // behavior: SnackBarBehavior.floating,
          elevation: 2,
          // width: MediaQuery.of(context).size.width / 1.75,
          contentTextStyle: const TextStyle(color: Colors.black),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateColor.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return themeColor;
            } else {
              return Colors.black;
            }
          }),
          trackColor: MaterialStateColor.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return themeColor.withOpacity(0.5);
            } else {
              if (useMaterial3) {
                return Colors.transparent;
              } else {
                return Colors.grey;
              }
            }
          }),
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.black,
        ),
        colorScheme: ColorScheme.light(
          primary: themeColor,
          primaryContainer: themeColor,
          secondary: themeColor,
          secondaryContainer: themeColor,
          surface: Colors.grey[100]!,
          surfaceTint: Colors.grey[850],
        ).copyWith(background: Colors.grey[100]!),
      );
    }
  }
}
