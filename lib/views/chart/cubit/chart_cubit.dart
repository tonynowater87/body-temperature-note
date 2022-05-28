import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:body_temperature_note/data/model/record_ui_model.dart';
import 'package:body_temperature_note/data/provider/setting_provider.dart';
import 'package:body_temperature_note/data/repository/repository.dart';
import 'package:body_temperature_note/utils/date_time_extensions.dart';
import 'package:body_temperature_note/utils/pair.dart';
import 'package:body_temperature_note/views/chart/model/chart_ui_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'chart_state.dart';

class ChartCubit extends Cubit<ChartPageState> {
  late Repository repository;
  late SettingsProvider settingsProvider;

  ChartDuration chartDuration = ChartDuration.season;
  late DateTime selectedDateTime;

  ChartCubit(this.repository, this.settingsProvider)
      : super(ChartLoadingState());

  void init(DateTime dateTime) {
    selectedDateTime = dateTime;

    switch (chartDuration) {
      case ChartDuration.week:
        Pair<DateTime> pair = dateTime.getWeekStartAndEndDay(DateTime.monday);
        getDurationChartModels(pair.left, pair.right);
        break;
      case ChartDuration.month:
        getDurationChartModels(
            DateTime(dateTime.year, dateTime.month, 1),
            DateTime(dateTime.year, dateTime.month,
                DateUtils.getDaysInMonth(dateTime.year, dateTime.month)));
        break;
      case ChartDuration.season:
        Pair<DateTime> pair = dateTime.getSeasonStartAndEndMonth();
        getDurationChartModels(pair.left, pair.right);
        break;
    }
  }

  List<ChartModel> getDurationChartModels(DateTime startDay, DateTime endDay) {
    List<ChartModel> results = [];
    do {
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
