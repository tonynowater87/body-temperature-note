import 'package:body_temperature_note/data/model/hive_record.dart';

abstract class Repository {
  Future<void> addRecord(HiveRecord record);

  Future<void> updateRecord(HiveRecord record);

  List<HiveRecord> queryDayRecords(DateTime today);

  List<HiveRecord> queryMonthRecords(DateTime month);
}