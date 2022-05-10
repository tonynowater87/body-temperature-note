import 'package:bloc/bloc.dart';
import 'package:body_temperature_note/data/repository/record_repository.dart';
import 'package:body_temperature_note/main.dart';
import 'package:body_temperature_note/views/home/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class HomeCubit extends Cubit<HomeState> {
  static DateTime currentDatePosition = DateTime.now();
  final RecordRepository repository;
  final _logger = getIt<Logger>();

  HomeCubit({required this.repository})
      : super(HomeInitState(
          DateUtils.getDaysInMonth(
              currentDatePosition.year, currentDatePosition.month),
          currentDatePosition.year,
          currentDatePosition.month,
          currentDatePosition.day,
        ));

  void changeToToday() {
    currentDatePosition = DateTime.now();
    final records = repository.queryMonthRecords(currentDatePosition);

    emit(HomeDateState(
        DateUtils.getDaysInMonth(
            currentDatePosition.year, currentDatePosition.month),
        currentDatePosition.year,
        currentDatePosition.month,
        currentDatePosition.day,
        records));
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

    emit(HomeDateState(
        DateUtils.getDaysInMonth(
            currentDatePosition.year, currentDatePosition.month),
        currentDatePosition.year,
        currentDatePosition.month,
        null,
        records));
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

    emit(HomeDateState(
        DateUtils.getDaysInMonth(
            currentDatePosition.year, currentDatePosition.month),
        currentDatePosition.year,
        currentDatePosition.month,
        null,
        records));
  }

  void refreshRecords() {
    final monthDate =
        DateTime(state.currentYear, state.currentMonth, 1, 0, 0, 0, 0, 0);
    final newRecords = repository.queryMonthRecords(monthDate);
    var newState = HomeDateState(
        DateUtils.getDaysInMonth(
            currentDatePosition.year, currentDatePosition.month),
        currentDatePosition.year,
        currentDatePosition.month,
        null,
        newRecords);
    emit(newState);
  }
}
