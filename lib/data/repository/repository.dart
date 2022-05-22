import 'package:body_temperature_note/data/model/memo_ui_model.dart';
import 'package:body_temperature_note/data/model/record_ui_model.dart';

abstract class Repository {
  Future<void> addOrUpdateRecord(RecordModel record);

  Future<void> deleteRecord(RecordModel record);

  RecordModel? queryRecordByDate(DateTime now);

  List<RecordModel> queryDayRecords(DateTime today);

  List<RecordModel> queryMonthRecords(DateTime month);

  Future<void> addOrUpdateMemo(MemoModel memoModel);

  Future<void> deleteMemo(DateTime datetime);
}
