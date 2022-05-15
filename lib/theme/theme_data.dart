import 'package:flutter/material.dart';

enum AppTheme { light, dark }

extension AppThemeExtension on AppTheme {
  ThemeData getThemeData() {
    final themeData = ThemeData();
    switch (this) {
      case AppTheme.light:
        return themeData.copyWith(
            brightness: Brightness.light,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.green),
            primaryColor: Colors.green,
            colorScheme: themeData.colorScheme
                .copyWith(secondary: Colors.greenAccent),
            textTheme: TextTheme(
                headlineLarge: const TextStyle().copyWith(color: Colors.grey),
                displaySmall: const TextStyle().copyWith(color: Colors.grey),
                displayMedium: const TextStyle().copyWith(color: Colors.grey),
                displayLarge: const TextStyle().copyWith(color: Colors.grey)));
      case AppTheme.dark:
        return themeData.copyWith(
            brightness: Brightness.dark,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.teal),
            primaryColor: Colors.teal,
            colorScheme: themeData.colorScheme
                .copyWith(secondary: Colors.tealAccent),
            textTheme: TextTheme(
                headlineLarge: const TextStyle().copyWith(color: Colors.white),
                displaySmall: const TextStyle().copyWith(color: Colors.white),
                displayMedium: const TextStyle().copyWith(color: Colors.white),
                displayLarge: const TextStyle().copyWith(color: Colors.white)));
    }
  }
}
