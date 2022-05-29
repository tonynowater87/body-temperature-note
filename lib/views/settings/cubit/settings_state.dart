import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  bool isDarkMode;
  bool isCelsius;
  bool isDisplayBaseline;
  Locale locale;

  SettingsState copyWith(
      {required bool isDarkMode,
      required bool isCelsius,
      required bool isDisplayBaseline,
      required Locale locale}) {
    return SettingsState(
        isDarkMode: isDarkMode,
        isDisplayBaseline: isDisplayBaseline,
        isCelsius: isCelsius,
        locale: locale);
  }

  @override
  List<Object> get props => [isDarkMode, isDisplayBaseline, isCelsius, locale];

  SettingsState({
    required this.isDarkMode,
    required this.isCelsius,
    required this.isDisplayBaseline,
    required this.locale,
  });
}
