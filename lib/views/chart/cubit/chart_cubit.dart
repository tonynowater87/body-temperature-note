import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:body_temperature_note/constants.dart';
import 'package:body_temperature_note/data/model/record_ui_model.dart';
import 'package:body_temperature_note/data/provider/setting_provider.dart';
import 'package:body_temperature_note/data/repository/repository.dart';
import 'package:body_temperature_note/utils/date_time_extensions.dart';
import 'package:body_temperature_note/utils/double_extensions.dart';
import 'package:body_temperature_note/utils/pair.dart';
import 'package:body_temperature_note/utils/string_extensions.dart';
import 'package:body_temperature_note/views/chart/model/chart_ui_model.dart';
import 'package:date_format/date_format.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'chart_state.dart';

class ChartCubit extends Cubit<ChartPageState> {
  Repository repository;
  SettingsProvider settingsProvider;

  ChartDuration selectedChartDuration = ChartDuration.week;
  late DateTime initDateTime;
  late DateTime selectedDateTime;
  late bool isCelsius;
  double? baseline;

  ChartCubit(this.repository, this.settingsProvider)
      : super(ChartLoadingState());

  void init(DateTime dateTime) {
    emit(ChartLoadingState());
    isCelsius = settingsProvider.getIsCelsius();

    if (settingsProvider.getIsDisplayBaseline()) {
      baseline = settingsProvider.getBaseline();
      if (!isCelsius) {
        baseline = defaultBaselineInCelsius.toFahrenheit();
      }
    }

    initDateTime = dateTime;
    selectedDateTime = dateTime;
    print(
        '[Tony] initDate=${initDateTime.millisecondsSinceEpoch},selectedDateTime=${selectedDateTime.millisecondsSinceEpoch}');
    refreshChart(selectedDateTime, selectedChartDuration);
  }

  void refreshChart(DateTime dateTime, ChartDuration chartDuration) {
    String dateTitle;
    List<ChartModel> records;
    int maxX;
    int minX;
    int intervalsX;
    switch (chartDuration) {
      case ChartDuration.week:
        Pair<DateTime> pair = dateTime.getWeekStartAndEndDay(DateTime.monday);
        dateTitle = "%s - %s".format([
          formatDate(pair.left, titleDayFormatyyyymmddDD),
          formatDate(pair.right, titleDayFormatyyyymmddDD)
        ]);
        // 1, 2, 3, 4, 5, 6, 7
        print(
            '[Tony] left=(${pair.left.toIso8601String()},${pair.left.millisecondsSinceEpoch}) right=(${pair.right.toIso8601String()},${pair.right.millisecondsSinceEpoch})');
        records = _getDurationChartModels(pair.left, pair.right);
        minX = dayInYear(pair.left);
        maxX = dayInYear(pair.right);
        intervalsX = 1;
        break;
      case ChartDuration.month:
        dateTitle = formatDate(dateTime, titleMonthFormatyyyymm);
        int daysInMonth =
            DateUtils.getDaysInMonth(dateTime.year, dateTime.month);
        var monthStartDate = DateTime(dateTime.year, dateTime.month, 1);
        var monthEndDate =
            DateTime(dateTime.year, dateTime.month, daysInMonth + 1)
                .subtract(const Duration(seconds: 1));
        records = _getDurationChartModels(monthStartDate, monthEndDate);
        minX = dayInYear(monthStartDate);
        maxX = dayInYear(monthEndDate);
        intervalsX = 10;
        break;
      case ChartDuration.season:
        Pair<DateTime> pair = dateTime.getSeasonStartAndEndMonth();
        dateTitle = "%s - %s".format([
          formatDate(pair.left, titleMonthFormatyyyymm),
          formatDate(pair.right, titleMonthFormatyyyymm)
        ]);
        records = _getDurationChartModels(
            pair.left,
            pair.right
                .add(const Duration(days: 1))
                .subtract(const Duration(seconds: 1)));
        minX = dayInYear(pair.left);
        maxX = dayInYear(pair.right);
        intervalsX = 21;
        break;
    }

    final newState = ChartLoadedState(
        title: dateTitle,
        baseline: baseline,
        intervalsX: intervalsX.toDouble(),
        maxX: maxX.toDouble(),
        minX: minX.toDouble(),
        maxY: records
            .map((e) => isCelsius ? e.valueY : e.valueY.toFahrenheit())
            .fold(50, (value, element) => value > element ? value : element),
        minY: records
            .map((e) => isCelsius ? e.valueY : e.valueY.toFahrenheit())
            .fold(30, (value, element) => value < element ? value : element),
        chartDuration: chartDuration,
        records: records);
    emit(newState);
  }

  void updateChartDuration(ChartDuration chartDuration) {
    selectedChartDuration = chartDuration;
    refreshChart(selectedDateTime, selectedChartDuration);
  }

  void changeToToday() {
    selectedDateTime = initDateTime;
    selectedChartDuration = ChartDuration.week;
    refreshChart(selectedDateTime, selectedChartDuration);
  }

  void changeToNext() {
    switch (selectedChartDuration) {
      case ChartDuration.week:
        selectedDateTime =
            selectedDateTime.add(const Duration(days: DateTime.daysPerWeek));
        break;
      case ChartDuration.month:
        if (selectedDateTime.month == 12) {
          selectedDateTime =
              DateTime(selectedDateTime.year + 1, DateTime.january, 1);
        } else {
          selectedDateTime =
              DateTime(selectedDateTime.year, selectedDateTime.month + 1, 1);
        }
        break;
      case ChartDuration.season:
        if (selectedDateTime.month >= DateTime.october) {
          selectedDateTime = DateTime(
              selectedDateTime.year + 1, (selectedDateTime.month + 3) % 12, 1);
        } else {
          selectedDateTime =
              DateTime(selectedDateTime.year, selectedDateTime.month + 3, 1);
        }
        break;
    }

    refreshChart(selectedDateTime, selectedChartDuration);
  }

  void changeToPrevious() {
    switch (selectedChartDuration) {
      case ChartDuration.week:
        selectedDateTime = selectedDateTime
            .subtract(const Duration(days: DateTime.daysPerWeek));
        break;
      case ChartDuration.month:
        if (selectedDateTime.month == 1) {
          selectedDateTime =
              DateTime(selectedDateTime.year - 1, DateTime.december, 1);
        } else {
          selectedDateTime =
              DateTime(selectedDateTime.year, selectedDateTime.month - 1, 1);
        }
        break;
      case ChartDuration.season:
        if (selectedDateTime.month <= DateTime.march) {
          selectedDateTime = DateTime(
              selectedDateTime.year - 1, (selectedDateTime.month - 3) + 12, 1);
        } else {
          selectedDateTime =
              DateTime(selectedDateTime.year, selectedDateTime.month - 3, 1);
        }
        break;
    }

    refreshChart(selectedDateTime, selectedChartDuration);
  }

  List<ChartModel> _getDurationChartModels(DateTime startDay, DateTime endDay) {
    List<ChartModel> results = [];
    do {
      var dayChartModel = _getDayChartModel(startDay);
      print('[Tony] ${results.length}. ${dayChartModel?.valueX}');
      if (dayChartModel != null) {
        results.add(dayChartModel);
      }
      startDay = startDay.add(const Duration(days: 1));
    } while (!startDay.isAfter(endDay));

    return results;
  }

  ChartModel? _getDayChartModel(DateTime day) {
    print('[Tony] _getDayChartModel ${day.toIso8601String()}');
    List<RecordModel> dayRecords = repository.queryDayRecords(day);
    int dayRecordsLen = dayRecords.length;
    double dayAvgTemp;
    try {
      dayAvgTemp = dayRecords
              .map((e) => e.temperature)
              .reduce((value, element) => value + element) /
          dayRecordsLen;
    } catch (e) {
      return null;
    }

    String memo = repository.queryMemo(day)?.memo ?? "";

    return ChartModel(
        valueY: isCelsius ? dayAvgTemp : dayAvgTemp.toFahrenheit(),
        valueX: dayInYear(day),
        memo: memo);
  }
}
