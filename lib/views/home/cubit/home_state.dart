import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  final int currentDaysOfMonth;
  final int currentYear;
  final int currentMonth;
  final int? currentDay;

  const HomeState(this.currentDaysOfMonth, this.currentYear, this.currentMonth,
      this.currentDay);
}

class HomeInitState extends HomeState {
  const HomeInitState(int currentDaysOfMonth, int currentYear,
      int currentMonth, int? currentDay)
      : super(currentDaysOfMonth, currentYear, currentMonth, currentDay);

  @override
  List<Object?> get props => [Random().nextInt(0x7fffffff)];
}

class HomeTodayState extends HomeState {
  const HomeTodayState(int currentDaysOfMonth, int currentYear,
      int currentMonth, int? currentDay)
      : super(currentDaysOfMonth, currentYear, currentMonth, currentDay);

  @override
  List<Object?> get props => [Random().nextInt(0x7fffffff)];
}

class HomeDateState extends HomeState {
  const HomeDateState(int currentDaysOfMonth, int currentYear, int currentMonth,
      int? currentDay)
      : super(currentDaysOfMonth, currentYear, currentMonth, currentDay);

  @override
  List<Object> get props => [currentYear, currentMonth, currentDay ?? -1];

  @override
  String toString() {
    return "$currentYear/$currentMonth($currentDaysOfMonth)/${currentDay ?? ''}";
  }
}
