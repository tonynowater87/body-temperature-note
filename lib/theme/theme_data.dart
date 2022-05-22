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
            appBarTheme: AppBarTheme(backgroundColor: Colors.green.shade100),
            primaryColor: Colors.green,
            dividerColor: Colors.black45,
            iconTheme: IconThemeData(color: Colors.black),
            colorScheme: themeData.colorScheme.copyWith(
                secondary: Colors.greenAccent.shade700,
                background: Colors.green.shade200),
            cardColor: Colors.green.shade100,
            textTheme: TextTheme(
                headlineMedium: const TextStyle()
                    .copyWith(color: Colors.black, fontSize: 24),
                headlineSmall: const TextStyle()
                    .copyWith(color: Colors.black, fontSize: 20),
                headlineLarge: const TextStyle()
                    .copyWith(color: Colors.black, fontSize: 34),
                bodyLarge: const TextStyle().copyWith(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1.25),
                bodyMedium: const TextStyle().copyWith(
                    color: Colors.black, fontSize: 16, letterSpacing: 0.5),
                bodySmall: const TextStyle().copyWith(
                    color: Colors.black, fontSize: 14, letterSpacing: 0.25)));
      case AppTheme.dark:
        return themeData.copyWith(
            brightness: Brightness.dark,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.teal),
            primaryColor: Colors.teal,
            dividerColor: Colors.white38,
            iconTheme: IconThemeData(color: Colors.white),
            cardColor: Colors.teal.shade900,
            colorScheme: themeData.colorScheme.copyWith(
                secondary: Colors.tealAccent.shade100,
                background: Colors.teal.shade700),
            textTheme: TextTheme(
                headlineMedium: const TextStyle()
                    .copyWith(color: Colors.white, fontSize: 24),
                headlineSmall: const TextStyle()
                    .copyWith(color: Colors.white, fontSize: 20),
                headlineLarge: const TextStyle()
                    .copyWith(color: Colors.white, fontSize: 34),
                bodyLarge: const TextStyle().copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1.25),
                bodyMedium: const TextStyle().copyWith(
                    color: Colors.white, fontSize: 16, letterSpacing: 0.5),
                bodySmall: const TextStyle().copyWith(
                    color: Colors.white, fontSize: 14, letterSpacing: 0.25)));
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
            settingsListBackground: Colors.green.shade200,
            settingsSectionBackground: Colors.green.shade100);
      case AppTheme.dark:
        return settingsThemeData.copyWith(
            dividerColor: Colors.white,
            settingsTileTextColor: Colors.white,
            titleTextColor: Colors.white,
            trailingTextColor: Colors.white,
            tileDescriptionTextColor: Colors.white,
            settingsListBackground: Colors.teal.shade700,
            settingsSectionBackground: Colors.teal.shade600);
    }
  }
}
