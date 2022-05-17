import 'dart:math';

import 'package:body_temperature_note/data/model/record_ui_model.dart';
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
  List<RecordModel> inputRecords;
  late List<List<RecordModel>> outputRecords;

  HomeDateState(int currentDaysOfMonth, int currentYear, int currentMonth,
      int? currentDay, this.inputRecords)
      : super(currentDaysOfMonth, currentYear, currentMonth, currentDay) {
    outputRecords = [];
    for (int dayOfMonth = 1; dayOfMonth <= currentDaysOfMonth; dayOfMonth++) {
      outputRecords.add(inputRecords
          .where((record) => record.dateTime.day == dayOfMonth)
          .toList(growable: false));
    }
  }

  @override
  List<Object> get props =>
      [currentYear, currentMonth, currentDay ?? -1, outputRecords];

  @override
  String toString() {
    return "$currentYear/$currentMonth($currentDaysOfMonth)/${currentDay ?? ''}, records size = ${outputRecords.length}";
  }
}
