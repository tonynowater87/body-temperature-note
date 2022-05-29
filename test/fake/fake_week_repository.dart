import 'package:body_temperature_note/data/model/memo_ui_model.dart';
import 'package:body_temperature_note/data/model/record_ui_model.dart';
import 'package:body_temperature_note/data/repository/repository.dart';

class FakeWeekRepository extends Repository {
  List<RecordModel> dayRecords;
  MemoModel? memoModel;

  @override
  Future<void> addOrUpdateMemo(MemoModel memoModel) {
    throw UnimplementedError();
  }

  @override
  Future<void> addOrUpdateRecord(RecordModel record) {
    // TODO: implement addOrUpdateRecord
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMemo(DateTime datetime) {
    // TODO: implement deleteMemo
    throw UnimplementedError();
  }

  @override
  Future<void> deleteRecord(RecordModel record) {
    // TODO: implement deleteRecord
    throw UnimplementedError();
  }

  @override
  List<RecordModel> queryDayRecords(DateTime today) {
    return dayRecords;
  }

  @override
  MemoModel? queryMemo(DateTime day) {
    return memoModel;
  }

  @override
  List<MemoModel> queryMonthMemos(DateTime month) {
    // TODO: implement queryMonthRecords
    throw UnimplementedError();
  }

  @override
  List<RecordModel> queryMonthRecords(DateTime month) {
    // TODO: implement queryMonthRecords
    throw UnimplementedError();
  }

  @override
  RecordModel? queryRecordByDate(DateTime now) {
    // TODO: implement queryRecordByDate
    throw UnimplementedError();
  }

  FakeWeekRepository({
    required this.dayRecords,
    required this.memoModel,
  });
}
