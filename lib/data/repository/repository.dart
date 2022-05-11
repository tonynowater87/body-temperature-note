import 'package:body_temperature_note/data/model/hive_memo.dart';
import 'package:body_temperature_note/data/model/hive_record.dart';

abstract class Repository {
  Future<void> addOrUpdateRecord(HiveRecord record);

  Future<void> deleteRecord(HiveRecord record);

  HiveRecord? queryRecordByDate(DateTime now);

  List<HiveRecord> queryDayRecords(DateTime today);

  List<HiveRecord> queryMonthRecords(DateTime month);

  Future<void> addOrUpdateMemo(HiveMemo hiveMemo);

  Future<void> deleteMemo(DateTime datetime);
}
