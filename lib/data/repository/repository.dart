import 'package:body_temperature_note/data/model/hive_memo.dart';
import 'package:body_temperature_note/data/model/record_ui_model.dart';

abstract class Repository {
  Future<void> addOrUpdateRecord(RecordModel record);

  Future<void> deleteRecord(RecordModel record);

  RecordModel? queryRecordByDate(DateTime now);

  List<RecordModel> queryDayRecords(DateTime today);

  List<RecordModel> queryMonthRecords(DateTime month);

  Future<void> addOrUpdateMemo(HiveMemo hiveMemo);

  Future<void> deleteMemo(DateTime datetime);
}
