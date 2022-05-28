import 'package:bloc/bloc.dart';
import 'package:body_temperature_note/data/provider/setting_provider.dart';
import 'package:body_temperature_note/l10n/l10n.dart';
import 'package:body_temperature_note/views/settings/cubit/settings_state.dart';
import 'package:flutter/material.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsProvider settingsProvider;

  SettingsCubit(this.settingsProvider)
      : super(SettingsState(
            isCelsius: false,
            isDarkMode: false,
            locale: const Locale('en', 'US'))) {
    final isDarkMode = settingsProvider.getIsDarkMode() ?? false;
    final isCelsius = settingsProvider.getIsCelsius();
    final languageCode = settingsProvider.getLanguageCode();
    Locale locale;

    if (languageCode == null) {
      locale = const Locale('en', '');
    } else {
      locale = Locale(languageCode, '');
    }
    emit(SettingsState(
        isDarkMode: isDarkMode, isCelsius: isCelsius, locale: locale));
  }

  updateIsCelsius(bool isCelsius) async {
    final isUpdated = await settingsProvider.setIsCelsius(isCelsius);
    if (isUpdated) {
      emit(state.copyWith(
          isDarkMode: state.isDarkMode,
          isCelsius: isCelsius,
          locale: state.locale));
    }
  }

  updateIsDarkMode(bool isDarkMode) async {
    final isUpdated = await settingsProvider.setIsDarkMode(isDarkMode);
    if (isUpdated) {
      emit(state.copyWith(
          isDarkMode: isDarkMode,
          isCelsius: state.isCelsius,
          locale: state.locale));
    }
  }

  updateLocale(Locale locale) async {
    final isUpdated =
        await settingsProvider.setLanguageCode(locale.languageCode);
    if (!isUpdated) return;
    await AppLocalizations.delegate.load(locale);

    emit(state.copyWith(
        isDarkMode: state.isDarkMode,
        isCelsius: state.isCelsius,
        locale: locale));
  }
}
