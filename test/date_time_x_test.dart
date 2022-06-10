import 'package:body_temperature_note/utils/date_time_extensions.dart';
import 'package:body_temperature_note/utils/pair.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('get date time from days since 1970 case 1', () {
    var now = DateTime(2022, 6, 10, 1, 1, 1);
    var daysSince1970 = now.dayInYearSince1970();
    var datetimeFromDaysSince1970 = fromDayInYearSince1970(daysSince1970);
    expect(datetimeFromDaysSince1970.year, now.year);
    expect(datetimeFromDaysSince1970.month, now.month);
    expect(datetimeFromDaysSince1970.day, now.day);
  });

  test('get date time from days since 1970 case 2', () {
    var now = DateTime(2020, 12, 31, 1, 1, 1);
    var daysSince1970 = now.dayInYearSince1970();
    var datetimeFromDaysSince1970 = fromDayInYearSince1970(daysSince1970);
    expect(datetimeFromDaysSince1970.year, now.year);
    expect(datetimeFromDaysSince1970.month, now.month);
    expect(datetimeFromDaysSince1970.day, now.day);
  });

  test('start day is today', () {
    // 1 2 3 4 5 6 7
    //         e t
    DateTime today = DateTime(2022, 5, 28);
    Pair<DateTime> pair = today.getWeekStartAndEndDay(DateTime.saturday);
    expect(today.weekday, DateTime.saturday);
    expect(pair.left.weekday, DateTime.saturday);
    expect(pair.right.weekday, DateTime.friday);
    expect(true, today.isBefore(pair.right));
  });

  test('start day before today case 2', () {
    // 1 2 3 4 5 6 7
    // s         t e
    DateTime today = DateTime(2022, 5, 28);
    Pair<DateTime> pair = today.getWeekStartAndEndDay(DateTime.monday);
    expect(today.weekday, DateTime.saturday);
    expect(pair.left.weekday, DateTime.monday);
    expect(pair.right.weekday, DateTime.sunday);
    expect(true, today.isAfter(pair.left) && today.isBefore(pair.right));
  });

  test('start day before today and is last year', () {
    // 2021       2022
    //   1 2 3 4 5 6 7
    //   s         t e
    DateTime today = DateTime(2022, 1, 1);
    Pair<DateTime> pair = today.getWeekStartAndEndDay(DateTime.monday);
    expect(today.weekday, DateTime.saturday);
    expect(pair.left.weekday, DateTime.monday);
    expect(pair.right.weekday, DateTime.sunday);
    expect(true, today.isAfter(pair.left) && today.isBefore(pair.right));
  });

  test('start day before today and end day is next year', () {
    //  2022        2023
    //   1 2 3 4 5 6 7
    //   s   t       e
    DateTime today = DateTime(2022, 12, 28);
    Pair<DateTime> pair = today.getWeekStartAndEndDay(DateTime.monday);
    expect(today.weekday, DateTime.wednesday);
    expect(pair.left.weekday, DateTime.monday);
    expect(pair.right.weekday, DateTime.sunday);
    expect(true, today.isAfter(pair.left) && today.isBefore(pair.right));
  });

  test('start weekday after today\'s weekday', () {
    // 7 1 2 3 4 5  6
    // s           t,e
    DateTime today = DateTime(2022, 5, 28);
    Pair<DateTime> pair = today.getWeekStartAndEndDay(DateTime.sunday);
    expect(today.weekday, DateTime.saturday);
    expect(pair.left.weekday, DateTime.sunday);
    expect(pair.right.weekday, DateTime.saturday);
    expect(true, today.isAfter(pair.left));
  });

  test('start weekday after today\'s weekday case 2', () {
    // 7 1 2 3 4 5 6
    // s       t   e
    DateTime today = DateTime(2022, 5, 26);
    Pair<DateTime> pair = today.getWeekStartAndEndDay(DateTime.sunday);
    expect(today.weekday, DateTime.thursday);
    expect(pair.left.weekday, DateTime.sunday);
    expect(pair.right.weekday, DateTime.saturday);
    expect(true, today.isAfter(pair.left));
  });

  test('start weekday after today\'s weekday case 3', () {
    //2022 2023
    // 6    7 1 2 3 4 5
    // s            t e
    DateTime today = DateTime(2023, 1, 5);
    Pair<DateTime> pair = today.getWeekStartAndEndDay(DateTime.saturday);
    expect(today.weekday, DateTime.thursday);
    expect(pair.left.weekday, DateTime.saturday);
    expect(pair.right.weekday, DateTime.friday);
    expect(true, today.isAfter(pair.left));
  });

  test('get season case 1', () {
    DateTime today = DateTime(2022, 5, 28);
    Pair<DateTime> pair = today.getSeasonStartAndEndMonth();
    expect(pair.left.year, 2022);
    expect(pair.left.month, DateTime.april);
    expect(pair.left.day, 1);
    expect(pair.right.year, 2022);
    expect(pair.right.month, DateTime.june);
    expect(pair.right.day,
        DateUtils.getDaysInMonth(pair.right.year, pair.right.month));
  });

  test('get season case 2', () {
    DateTime today = DateTime(2022, 1, 28);
    Pair<DateTime> pair = today.getSeasonStartAndEndMonth();
    expect(pair.left.year, 2021);
    expect(pair.left.month, DateTime.december);
    expect(pair.left.day, 1);
    expect(pair.right.year, 2022);
    expect(pair.right.month, DateTime.february);
    expect(pair.right.day,
        DateUtils.getDaysInMonth(pair.right.year, pair.right.month));
  });

  test('get season case 3', () {
    DateTime today = DateTime(2022, 12, 28);
    Pair<DateTime> pair = today.getSeasonStartAndEndMonth();
    expect(pair.left.year, 2022);
    expect(pair.left.month, DateTime.november);
    expect(pair.left.day, 1);
    expect(pair.right.year, 2023);
    expect(pair.right.month, DateTime.january);
    expect(pair.right.day,
        DateUtils.getDaysInMonth(pair.right.year, pair.right.month));
  });
}
