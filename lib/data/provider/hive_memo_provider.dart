import 'package:body_temperature_note/data/model/hive_memo.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HiveMemoProvider {
  final Box<HiveMemo> box;

  HiveMemoProvider(this.box);

  HiveMemo? queryMemoByDateTime(DateTime dateTime) {
    HiveMemo? existedMemo;

    try {
      existedMemo =
          box.values.firstWhere((element) => element.dateTime == dateTime);
    } on StateError {
      existedMemo = null;
    }

    return existedMemo;
  }

  List<HiveMemo> queryMonthRecords(DateTime monthDate) {
    final endDayOfTheMonth =
        DateUtils.getDaysInMonth(monthDate.year, monthDate.month);
    final thisMonthBeginPoint = DateTime(monthDate.year, monthDate.month);
    final thisMonthEndPoint =
        DateTime(monthDate.year, monthDate.month, endDayOfTheMonth, 23, 59, 59);
    return box.values
        .where((element) =>
            element.dateTime.isBefore(thisMonthEndPoint) &&
            element.dateTime.isAfter(thisMonthBeginPoint))
        .toList(growable: false);
  }

  Future<int> addOrUpdateMemo(HiveMemo newlyHiveMemo) async {
    HiveMemo? existedMemo;
    try {
      existedMemo = box.values
          .firstWhere((element) => element.dateTime == newlyHiveMemo.dateTime);
    } on StateError {
      existedMemo = null;
    }

    if (existedMemo == null) {
      return box.add(newlyHiveMemo);
    } else {
      await box.put(existedMemo.key, newlyHiveMemo);
      return Future.value(newlyHiveMemo.key);
    }
  }

  Future<bool> deleteMemo(DateTime date) {
    HiveMemo? existedMemo;

    try {
      existedMemo =
          box.values.firstWhere((element) => element.dateTime == date);
    } on StateError {
      existedMemo = null;
    }

    if (existedMemo == null) {
      return Future.value(false);
    } else {
      return box.delete(existedMemo.key).then((value) => true);
    }
  }
}
