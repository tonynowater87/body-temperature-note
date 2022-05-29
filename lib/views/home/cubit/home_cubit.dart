import 'package:bloc/bloc.dart';
import 'package:body_temperature_note/data/provider/setting_provider.dart';
import 'package:body_temperature_note/data/repository/repository.dart';
import 'package:body_temperature_note/main.dart';
import 'package:body_temperature_note/views/home/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class HomeCubit extends Cubit<HomeState> {
  static DateTime currentDatePosition = DateTime.now();
  final Repository repository;
  final SettingsProvider settingsProvider;
  final _logger = getIt<Logger>();
  bool isCelsius = false;

  HomeCubit({required this.repository, required this.settingsProvider})
      : super(HomeInitState(
          DateUtils.getDaysInMonth(
              currentDatePosition.year, currentDatePosition.month),
          currentDatePosition.year,
          currentDatePosition.month,
          currentDatePosition.day,
        )) {
    isCelsius = settingsProvider.getIsCelsius();
  }

  void changeToToday() {
    currentDatePosition = DateTime.now();
    final records = repository.queryMonthRecords(currentDatePosition);
    final memos = repository.queryMonthMemos(currentDatePosition);

    emit(HomeDateState(
        DateUtils.getDaysInMonth(
            currentDatePosition.year, currentDatePosition.month),
        currentDatePosition.year,
        currentDatePosition.month,
        currentDatePosition.day,
        records,
        memos,
        isCelsius));
  }

  void nextMonth() {
    final month = currentDatePosition.month;
    if (month < DateTime.december) {
      currentDatePosition = DateTime(
          currentDatePosition.year, month + 1, currentDatePosition.day);
    } else {
      currentDatePosition = DateTime(currentDatePosition.year + 1,
          DateTime.january, currentDatePosition.day);
    }

    final records = repository.queryMonthRecords(currentDatePosition);
    final memos = repository.queryMonthMemos(currentDatePosition);

    emit(HomeDateState(
        DateUtils.getDaysInMonth(
            currentDatePosition.year, currentDatePosition.month),
        currentDatePosition.year,
        currentDatePosition.month,
        null,
        records,
        memos,
        isCelsius));
  }

  void previousMonth() {
    final month = currentDatePosition.month;
    if (month > DateTime.january) {
      currentDatePosition = DateTime(
          currentDatePosition.year, month - 1, currentDatePosition.day);
    } else {
      currentDatePosition = DateTime(currentDatePosition.year - 1,
          DateTime.december, currentDatePosition.day);
    }

    final records = repository.queryMonthRecords(currentDatePosition);
    final memos = repository.queryMonthMemos(currentDatePosition);

    emit(HomeDateState(
        DateUtils.getDaysInMonth(
            currentDatePosition.year, currentDatePosition.month),
        currentDatePosition.year,
        currentDatePosition.month,
        null,
        records,
        memos,
        isCelsius));
  }

  void refreshRecords() {
    final monthDate = DateTime(state.currentYear, state.currentMonth, 1, 0, 0,
        0, 0, 1); // 日不帶1的話會變成是是上個月的最後一天
    isCelsius = settingsProvider.getIsCelsius();
    final newRecords = repository.queryMonthRecords(monthDate);
    final newMemos = repository.queryMonthMemos(monthDate);

    var newState = HomeDateState(
        DateUtils.getDaysInMonth(
            currentDatePosition.year, currentDatePosition.month),
        currentDatePosition.year,
        currentDatePosition.month,
        null,
        newRecords,
        newMemos,
        isCelsius);
    emit(newState);
  }
}
