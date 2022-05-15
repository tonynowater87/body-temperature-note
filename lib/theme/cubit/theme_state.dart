import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppThemeDataState extends Equatable {
  ThemeMode appThemeMode;
  Locale appLocale;

  AppThemeDataState({required this.appThemeMode, required this.appLocale});

  @override
  List<Object> get props => [appThemeMode, appLocale];

  AppThemeDataState copyWith(
      {required ThemeMode themeMode, required Locale appLocale}) {
    return AppThemeDataState(appThemeMode: themeMode, appLocale: appLocale);
  }
}
