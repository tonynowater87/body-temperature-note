import 'dart:math';

import 'package:body_temperature_note/data/model/memo_ui_model.dart';
import 'package:body_temperature_note/data/model/record_ui_model.dart';
import 'package:body_temperature_note/utils/double_extensions.dart';
import 'package:body_temperature_note/views/home/date_list_ui_model.dart';
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
  List<MemoModel> inputMemos;
  bool isCelsius;
  late DateListModel dateListModel;

  HomeDateState(int currentDaysOfMonth, int currentYear, int currentMonth,
      int? currentDay, this.inputRecords, this.inputMemos, this.isCelsius)
      : super(currentDaysOfMonth, currentYear, currentMonth, currentDay) {
    // index = monthDay
    List<List<RecordModel>> outputRecords = [];
    for (int dayOfMonth = 1; dayOfMonth <= currentDaysOfMonth; dayOfMonth++) {
      outputRecords.add(inputRecords
          .where((record) => record.dateTime.day == dayOfMonth)
          .map((element) => element
            ..temperature = isCelsius
                ? element.temperature
                : element.temperature.toFahrenheit())
          .toList(growable: false));
    }

    // index = monthDay
    List<MemoModel?> outputMemos = [];
    for (int dayOfMonth = 1; dayOfMonth <= currentDaysOfMonth; dayOfMonth++) {
      final memo =
          inputMemos.where((element) => element.dateTime.day == dayOfMonth);
      if (memo.isNotEmpty) {
        outputMemos.add(memo.first);
      } else {
        outputMemos.add(null);
      }
    }

    dateListModel =
        DateListModel(outputRecords: outputRecords, outputMemos: outputMemos);
  }

  @override
  List<Object> get props =>
      [isCelsius, currentYear, currentMonth, currentDay ?? -1, dateListModel];

  @override
  String toString() {
    return "$currentYear/$currentMonth($currentDaysOfMonth)/${currentDay ?? ''}, records size = ${dateListModel}";
  }

  String toDaysStringIso8604(int day) {
    return DateTime(currentYear, currentMonth, day).toIso8601String();
  }
}
