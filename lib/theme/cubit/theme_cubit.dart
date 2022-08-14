import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:body_temperature_note/data/provider/setting_provider.dart';
import 'package:body_temperature_note/main.dart';
import 'package:body_temperature_note/theme/cubit/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';

class ThemeCubit extends Cubit<AppThemeDataState> {
  final _logger = getIt<Logger>();

  ThemeCubit(SettingsProvider settingsProvider)
      : super(AppThemeDataState(
            appThemeMode: ThemeMode.system, appLocale: window.locale)) {
    final selectedLocale = settingsProvider.getLanguageCode();
    if (selectedLocale == null) {
      var languageCode = window.locale.languageCode;
      settingsProvider.setLanguageCode(languageCode);
    }
    final isDarkMode = settingsProvider.getIsDarkMode();
    if (isDarkMode == null) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      settingsProvider.setIsDarkMode(brightness == Brightness.dark);
    }
    if (isDarkMode != null && selectedLocale != null) {
      if (isDarkMode) {
        emit(state.copyWith(
            themeMode: ThemeMode.dark, appLocale: Locale(selectedLocale)));
      } else {
        emit(state.copyWith(
            themeMode: ThemeMode.light, appLocale: Locale(selectedLocale)));
      }
    }
  }

  toggle(bool isUsingDarkMode) {
    if (isUsingDarkMode) {
      emit(state.copyWith(
          themeMode: ThemeMode.dark, appLocale: state.appLocale));
    } else {
      emit(state.copyWith(
          themeMode: ThemeMode.light, appLocale: state.appLocale));
    }
  }

  changeLocale(Locale locale) {
    emit(state.copyWith(themeMode: state.appThemeMode, appLocale: locale));
  }
}
