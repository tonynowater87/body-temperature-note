import 'package:body_temperature_note/data/model/hive_record.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HiveRecordProvider {
  final Box<HiveRecord> _box;

  HiveRecordProvider(this._box);

  Future<int> addRecord(HiveRecord record) {
    return _box.add(record);
  }

  Future<void> updateRecord(HiveRecord record) {
    final existedRecord = _box.get(record.key);

    if (existedRecord != null) {
      return (existedRecord
            ..dateTime = record.dateTime
            ..temperature = record.temperature)
          .save();
    } else {
      return Future.value();
    }
  }

  Future<void> removeRecord(HiveRecord record) {
    return _box.values
        .firstWhere((element) => element.key == record.key)
        .delete();
  }

  List<HiveRecord> queryTodayRecords(DateTime today) {
    final now = DateTime.now();
    final tomorrow = DateTime.now();
    final todayBeginPoint = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final todayEndPoint =
        DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 0, 0, 0);
    return _box.values
        .where((element) =>
            element.dateTime.isBefore(todayEndPoint) &&
            element.dateTime.isAfter(todayBeginPoint))
        .toList(growable: false);
  }

  List<HiveRecord> queryMonthRecords(DateTime month) {
    final now = DateTime.now();
    final endDayOfTheMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final thisMonthBeginPoint = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final thisMonthEndPoint =
        DateTime(now.year, now.month, endDayOfTheMonth, 23, 59, 59);
    return _box.values
        .where((element) =>
            element.dateTime.isBefore(thisMonthBeginPoint) &&
            element.dateTime.isAfter(thisMonthEndPoint))
        .toList(growable: false);
  }
}