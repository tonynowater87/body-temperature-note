import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppThemeDataState extends Equatable {
  ThemeMode appThemeMode;

  AppThemeDataState({required this.appThemeMode});

  @override
  List<Object> get props => [appThemeMode];

  AppThemeDataState copyWith(ThemeMode themeMode) {
    return AppThemeDataState(appThemeMode: themeMode);
  }
}
