import 'package:body_temperature_note/utils/pair.dart';
import 'package:flutter/material.dart';

extension DateTimeX on DateTime {
  Pair<DateTime> getWeekStartAndEndDay(int startWeekday) {
    if (weekday == startWeekday) {
      // 今天就是起始天
      DateTime endDateTime = add(const Duration(days: 6));
      return Pair(this, endDateTime);
    } else {
      // 今天的星期 > 起始星期
      if (weekday > startWeekday) {
        DateTime startDateTime =
            subtract(Duration(days: weekday - startWeekday));
        DateTime endDateTime = startDateTime.add(const Duration(days: 6));
        return Pair(startDateTime, endDateTime);
      } else {
        // 今天的星期 < 起始星期
        DateTime startDateTime =
            subtract(Duration(days: weekday - startWeekday))
                .subtract(const Duration(days: DateTime.daysPerWeek));
        DateTime endDateTime = startDateTime.add(const Duration(days: 6));
        return Pair(startDateTime, endDateTime);
      }
    }
  }

  Pair<DateTime> getSeasonStartAndEndMonth() {
    int currentMonth = month;
    switch (currentMonth) {
      case DateTime.january:
      // 12(去年), 1, 2
        return Pair(
            DateTime(year - 1, DateTime.december),
            DateTime(year, DateTime.february,
                DateUtils.getDaysInMonth(year, DateTime.february)));
      case DateTime.december:
      // 11, 12, 1(明年)
        return Pair(
            DateTime(year, DateTime.november),
            DateTime(year + 1, DateTime.january,
                DateUtils.getDaysInMonth(year + 1, DateTime.january)));
      default:
      // 皆今年
        return Pair(
            DateTime(year, month - 1, 1),
            DateTime(
                year, month + 1, DateUtils.getDaysInMonth(year, month + 1)));
    }
  }
}
