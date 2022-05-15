import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

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
            colorScheme:
                themeData.colorScheme.copyWith(secondary: Colors.greenAccent),
            cardColor: Colors.green.shade500,
            textTheme: TextTheme(
                headlineMedium: const TextStyle().copyWith(color: Colors.grey),
                headlineSmall: const TextStyle().copyWith(color: Colors.grey),
                headlineLarge: const TextStyle().copyWith(color: Colors.grey),
                displaySmall: const TextStyle().copyWith(color: Colors.grey),
                displayMedium: const TextStyle().copyWith(color: Colors.grey),
                displayLarge: const TextStyle().copyWith(color: Colors.grey)));
      case AppTheme.dark:
        return themeData.copyWith(
            brightness: Brightness.dark,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.teal),
            primaryColor: Colors.teal,
            cardColor: Colors.teal.shade500,
            colorScheme:
                themeData.colorScheme.copyWith(secondary: Colors.tealAccent),
            textTheme: TextTheme(
                headlineMedium: const TextStyle().copyWith(color: Colors.white),
                headlineSmall: const TextStyle().copyWith(color: Colors.white),
                headlineLarge: const TextStyle().copyWith(color: Colors.white),
                displaySmall: const TextStyle().copyWith(color: Colors.white),
                displayMedium: const TextStyle().copyWith(color: Colors.white),
                displayLarge: const TextStyle().copyWith(color: Colors.white)));
    }
  }

  SettingsThemeData getSettingsThemeData() {
    const settingsThemeData = SettingsThemeData();
    switch (this) {
      case AppTheme.light:
        return settingsThemeData.copyWith(
            dividerColor: Colors.black38,
            settingsTileTextColor: Colors.black87,
            titleTextColor: Colors.black87,
            trailingTextColor: Colors.black87,
            tileDescriptionTextColor: Colors.black87,
            settingsListBackground: Colors.green.shade50,
            settingsSectionBackground: Colors.white);
      case AppTheme.dark:
        return settingsThemeData.copyWith(
            dividerColor: Colors.white,
            settingsTileTextColor: Colors.white,
            titleTextColor: Colors.white,
            trailingTextColor: Colors.white,
            tileDescriptionTextColor: Colors.white,
            settingsListBackground: Colors.green.shade900,
            settingsSectionBackground: Colors.black12);
    }
  }
}
