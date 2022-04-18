import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  static DateTime currentDatePosition = DateTime.now();

  HomeCubit()
      : super(HomeDateState(
            currentYear: currentDatePosition.year,
            currentMonth: currentDatePosition.month,
            currentDay: currentDatePosition.day,
            currentDaysOfMonth: DateUtils.getDaysInMonth(
                currentDatePosition.year, currentDatePosition.month)));

  @override
  void onChange(Change<HomeState> change) {
    print('[Cubit] current = $state, change = $change');
    super.onChange(change);
  }

  void changeToToday() {
    currentDatePosition = DateTime.now();
    emit(HomeDateState(
        currentYear: currentDatePosition.year,
        currentMonth: currentDatePosition.month,
        currentDay: currentDatePosition.day,
        currentDaysOfMonth: DateUtils.getDaysInMonth(
            currentDatePosition.year, currentDatePosition.month)));
  }

  void nextMonth() {
    final month = currentDatePosition.month;
    if (month < DateTime.december) {
      currentDatePosition = DateTime(
          currentDatePosition.year, month + 1, currentDatePosition.day);
      emit(HomeDateState(
          currentYear: currentDatePosition.year,
          currentMonth: currentDatePosition.month,
          currentDay: null,
          currentDaysOfMonth: DateUtils.getDaysInMonth(
              currentDatePosition.year, currentDatePosition.month)));
    } else {
      currentDatePosition = DateTime(currentDatePosition.year + 1,
          DateTime.january, currentDatePosition.day);
      emit(HomeDateState(
          currentYear: currentDatePosition.year,
          currentMonth: currentDatePosition.month,
          currentDay: null,
          currentDaysOfMonth: DateUtils.getDaysInMonth(
              currentDatePosition.year, currentDatePosition.month)));
    }
  }

  void previousMonth() {
    final month = currentDatePosition.month;
    if (month > DateTime.january) {
      currentDatePosition = DateTime(
          currentDatePosition.year, month - 1, currentDatePosition.day);
      emit(HomeDateState(
          currentYear: currentDatePosition.year,
          currentMonth: currentDatePosition.month,
          currentDay: null,
          currentDaysOfMonth: DateUtils.getDaysInMonth(
              currentDatePosition.year, currentDatePosition.month)));
    } else {
      currentDatePosition = DateTime(currentDatePosition.year - 1,
          DateTime.december, currentDatePosition.day);
      emit(HomeDateState(
          currentYear: currentDatePosition.year,
          currentMonth: currentDatePosition.month,
          currentDay: null,
          currentDaysOfMonth: DateUtils.getDaysInMonth(
              currentDatePosition.year, currentDatePosition.month)));
    }
  }
}
