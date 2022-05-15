import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  bool isDarkMode;
  bool isCelsius;
  Locale locale;

  SettingsState(
      {required this.isDarkMode,
      required this.isCelsius,
      required this.locale});

  SettingsState copyWith(
      {required bool isDarkMode,
      required bool isCelsius,
      required Locale locale}) {
    return SettingsState(
        isDarkMode: isDarkMode, isCelsius: isCelsius, locale: locale);
  }

  @override
  List<Object> get props => [isDarkMode, isCelsius, locale];
}
