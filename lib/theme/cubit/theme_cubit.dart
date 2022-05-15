import 'package:bloc/bloc.dart';
import 'package:body_temperature_note/theme/cubit/theme_state.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<AppThemeDataState> {
  ThemeCubit() : super(AppThemeDataState(appThemeMode: ThemeMode.system));

  toggle() {
    if (state.appThemeMode == ThemeMode.dark) {
      emit(state.copyWith(ThemeMode.light));
    } else {
      emit(state.copyWith(ThemeMode.dark));
    }
  }
}
