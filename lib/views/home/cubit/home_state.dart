import 'dart:math';

import 'package:body_temperature_note/data/model/hive_record.dart';
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
  const HomeInitState(int currentDaysOfMonth, int currentYear, int currentMonth,
      int? currentDay)
      : super(currentDaysOfMonth, currentYear, currentMonth, currentDay);

  @override
  List<Object?> get props => [Random().nextInt(0x7fffffff)];
}

class HomeDateState extends HomeState {
  List<HiveRecord> inputRecords;
  late List<List<HiveRecord>> outputRecords;

  HomeDateState(int currentDaysOfMonth, int currentYear, int currentMonth,
      int? currentDay, this.inputRecords)
      : super(currentDaysOfMonth, currentYear, currentMonth, currentDay) {
    outputRecords = [];
    for (int i = 0; i < currentDaysOfMonth; i++) {
      outputRecords.add(inputRecords
          .takeWhile((value) => value.dateTime.day == i)
          .toList(growable: false));
    }
  }

  @override
  List<Object> get props => [currentYear, currentMonth, currentDay ?? -1];

  @override
  String toString() {
    return "$currentYear/$currentMonth($currentDaysOfMonth)/${currentDay ?? ''}, records = $outputRecords";
  }
}
