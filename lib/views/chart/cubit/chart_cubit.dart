import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:body_temperature_note/constants.dart';
import 'package:body_temperature_note/data/model/record_ui_model.dart';
import 'package:body_temperature_note/data/provider/setting_provider.dart';
import 'package:body_temperature_note/data/repository/repository.dart';
import 'package:body_temperature_note/utils/date_time_extensions.dart';
import 'package:body_temperature_note/utils/pair.dart';
import 'package:body_temperature_note/utils/string_extensions.dart';
import 'package:body_temperature_note/views/chart/model/chart_ui_model.dart';
import 'package:date_format/date_format.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'chart_state.dart';

class ChartCubit extends Cubit<ChartPageState> {
  late Repository repository;
  late SettingsProvider settingsProvider;

  ChartDuration selectedChartDuration = ChartDuration.week;
  late DateTime selectedDateTime;

  ChartCubit(this.repository, this.settingsProvider)
      : super(ChartLoadingState());

  void init(DateTime dateTime) {
    emit(ChartLoadingState());
    selectedDateTime = dateTime;
    refreshChart(selectedDateTime, selectedChartDuration);
  }

  void refreshChart(DateTime dateTime, ChartDuration chartDuration) {
    String dateTitle;
    List<ChartModel> records;

    switch (chartDuration) {
      case ChartDuration.week:
        Pair<DateTime> pair = dateTime.getWeekStartAndEndDay(DateTime.monday);
        dateTitle = "%s - %s".format([
          formatDate(pair.left, titleDayFormatyyyymmddDD),
          formatDate(pair.right, titleDayFormatyyyymmddDD)
        ]);
        records = getDurationChartModels(pair.left, pair.right);
        break;
      case ChartDuration.month:
        dateTitle = formatDate(dateTime, titleMonthFormatyyyymm);
        records = getDurationChartModels(
            DateTime(dateTime.year, dateTime.month, 1),
            DateTime(dateTime.year, dateTime.month,
                DateUtils.getDaysInMonth(dateTime.year, dateTime.month)));
        break;
      case ChartDuration.season:
        Pair<DateTime> pair = dateTime.getSeasonStartAndEndMonth();
        dateTitle = "%s - %s".format([
          formatDate(pair.left, titleMonthFormatyyyymm),
          formatDate(pair.right, titleMonthFormatyyyymm)
        ]);
        records = getDurationChartModels(pair.left, pair.right);
        break;
    }

    emit(ChartLoadedState(
        title: dateTitle,
        baseline: 36,
        chartDuration: chartDuration,
        records: records));
  }

  void updateChartDuration(ChartDuration chartDuration) {
    selectedChartDuration = chartDuration;
    refreshChart(selectedDateTime, selectedChartDuration);
  }

  void changeToToday() {}

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

  List<ChartModel> getDurationChartModels(DateTime startDay, DateTime endDay) {
    List<ChartModel> results = [];
    do {
      results.add(getDayChartModel(startDay));
      startDay = startDay.add(const Duration(days: 1));
    } while (!startDay.isAfter(endDay));

    return results;
  }

  ChartModel getDayChartModel(DateTime day) {
    List<RecordModel> dayRecords = repository.queryDayRecords(day);
    int dayRecordsLen = dayRecords.length;
    double dayAvgTemp = dayRecords
            .map((e) => e.temperature)
            .reduce((value, element) => value + element) /
        dayRecordsLen;
    String memo = repository.queryMemo(day)?.memo ?? "";

    return ChartModel(valueY: dayAvgTemp, valueX: day.day, memo: memo);
  }
}
