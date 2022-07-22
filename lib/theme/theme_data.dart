import 'package:body_temperature_note/theme/nord_color.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

enum AppTheme { light, dark, nord }

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
            errorColor: nord11,
            inputDecorationTheme: InputDecorationTheme(
                labelStyle: const TextStyle().copyWith(
                    color: Colors.black, fontSize: 16, letterSpacing: 0.5)),
            iconTheme: const IconThemeData(color: Colors.black),
            colorScheme: themeData.colorScheme.copyWith(
                onSurface: Colors.green.shade50,
                secondary: Colors.greenAccent.shade700,
                background: Colors.green.shade200),
            cardColor: Colors.green.shade100,
            dialogTheme: DialogTheme(
                backgroundColor: Colors.green.shade200,
                titleTextStyle: const TextStyle().copyWith(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1.25),
                contentTextStyle: const TextStyle().copyWith(
                    color: Colors.black, fontSize: 16, letterSpacing: 0.5)),
            textTheme: TextTheme(
                titleMedium: const TextStyle()
                    .copyWith(color: Colors.black, fontSize: 24),
                titleSmall: const TextStyle()
                    .copyWith(color: Colors.black, fontSize: 20),
                titleLarge: const TextStyle()
                    .copyWith(color: Colors.black, fontSize: 34),
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
            errorColor: nord11,
            inputDecorationTheme: InputDecorationTheme(
                labelStyle: const TextStyle().copyWith(
                    color: Colors.white, fontSize: 16, letterSpacing: 0.5)),
            iconTheme: IconThemeData(color: Colors.white),
            cardColor: Colors.teal.shade900,
            colorScheme: themeData.colorScheme.copyWith(
                onSurface: Colors.green.shade900,
                secondary: Colors.tealAccent.shade100,
                background: Colors.teal.shade700),
            dialogTheme: DialogTheme(
                backgroundColor: Colors.teal.shade700,
                titleTextStyle: const TextStyle().copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1.25),
                contentTextStyle: const TextStyle().copyWith(
                    color: Colors.white, fontSize: 16, letterSpacing: 0.5)),
            textTheme: TextTheme(
                titleMedium: const TextStyle()
                    .copyWith(color: Colors.white, fontSize: 24),
                titleSmall: const TextStyle()
                    .copyWith(color: Colors.white, fontSize: 20),
                titleLarge: const TextStyle()
                    .copyWith(color: Colors.white, fontSize: 34),
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
      case AppTheme.nord:
        return themeData.copyWith(
            brightness: Brightness.dark,
            appBarTheme: const AppBarTheme(backgroundColor: nord0),
            primaryColor: nord10,
            dividerColor: nord5,
            errorColor: nord11,
            inputDecorationTheme: InputDecorationTheme(
                labelStyle: const TextStyle()
                    .copyWith(color: nord6, fontSize: 16, letterSpacing: 0.5)),
            chipTheme: ChipThemeData(
                backgroundColor: nord0,
                labelStyle: const TextStyle()
                    .copyWith(color: nord6, fontSize: 12, letterSpacing: 0.25),
                secondaryLabelStyle: const TextStyle().copyWith(
                    color: nord6, fontSize: 16, fontWeight: FontWeight.w900),
                secondarySelectedColor: nord0,
                disabledColor: nord0),
            iconTheme: const IconThemeData(color: nord5),
            cardColor: nord3,
            colorScheme: themeData.colorScheme.copyWith(
                onSurface: nord8, secondary: nord8, background: nord1),
            dialogTheme: DialogTheme(
                backgroundColor: nord0,
                titleTextStyle: const TextStyle().copyWith(
                    color: nord6,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1.25),
                contentTextStyle: const TextStyle()
                    .copyWith(color: nord6, fontSize: 16, letterSpacing: 0.5)),
            textTheme: TextTheme(
                titleMedium:
                    const TextStyle().copyWith(color: nord6, fontSize: 24),
                titleSmall:
                    const TextStyle().copyWith(color: nord6, fontSize: 20),
                titleLarge:
                    const TextStyle().copyWith(color: nord6, fontSize: 34),
                headlineMedium:
                    const TextStyle().copyWith(color: nord6, fontSize: 24),
                headlineSmall:
                    const TextStyle().copyWith(color: nord6, fontSize: 20),
                headlineLarge:
                    const TextStyle().copyWith(color: nord6, fontSize: 34),
                bodyLarge: const TextStyle().copyWith(
                    color: nord6,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1.25),
                bodyMedium: const TextStyle()
                    .copyWith(color: nord6, fontSize: 16, letterSpacing: 0.5),
                bodySmall: const TextStyle().copyWith(
                    color: nord6, fontSize: 14, letterSpacing: 0.25)));
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
      case AppTheme.nord:
        return settingsThemeData.copyWith(
            dividerColor: nord4,
            settingsTileTextColor: nord6,
            titleTextColor: nord6,
            trailingTextColor: nord7,
            tileDescriptionTextColor: nord7,
            settingsListBackground: nord0,
            settingsSectionBackground: nord1);
    }
  }
}
