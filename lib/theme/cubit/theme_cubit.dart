import 'package:bloc/bloc.dart';
import 'package:body_temperature_note/data/provider/settings_provider.dart';
import 'package:body_temperature_note/theme/cubit/theme_state.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<AppThemeDataState> {

  ThemeCubit(SettingsProvider settingsProvider) : super(AppThemeDataState(appThemeMode: ThemeMode.system)) {
    final isDarkMode = settingsProvider.getIsDarkMode();
    if (isDarkMode == null) {
      return;
    }
    if (isDarkMode) {
      emit(state.copyWith(ThemeMode.dark));
    } else {
      emit(state.copyWith(ThemeMode.light));
    }
  }

  toggle() {
    if (state.appThemeMode == ThemeMode.dark) {
      emit(state.copyWith(ThemeMode.light));
    } else {
      emit(state.copyWith(ThemeMode.dark));
    }
  }
}
