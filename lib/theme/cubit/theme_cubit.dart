import 'package:bloc/bloc.dart';
import 'package:body_temperature_note/data/provider/settings_provider.dart';
import 'package:body_temperature_note/main.dart';
import 'package:body_temperature_note/theme/cubit/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class ThemeCubit extends Cubit<AppThemeDataState> {
  final _logger = getIt<Logger>();

  ThemeCubit(SettingsProvider settingsProvider)
      : super(AppThemeDataState(
            appThemeMode: ThemeMode.system,
            appLocale: Locale(Intl.getCurrentLocale()))) {
    final selectedLocale = settingsProvider.getLanguageCode();
    _logger.d('selectedLocale = $selectedLocale');
    if (selectedLocale == null) {
      return;
    }
    final isDarkMode = settingsProvider.getIsDarkMode();
    if (isDarkMode == null) {
      return;
    }
    if (isDarkMode) {
      emit(state.copyWith(
          themeMode: ThemeMode.dark, appLocale: Locale(selectedLocale)));
    } else {
      emit(state.copyWith(
          themeMode: ThemeMode.light, appLocale: Locale(selectedLocale)));
    }
  }

  toggle() {
    if (state.appThemeMode == ThemeMode.dark) {
      emit(state.copyWith(
          themeMode: ThemeMode.light, appLocale: state.appLocale));
    } else {
      emit(state.copyWith(
          themeMode: ThemeMode.dark, appLocale: state.appLocale));
    }
  }

  changeLocale(Locale locale) {
    emit(state.copyWith(themeMode: state.appThemeMode, appLocale: locale));
  }
}
