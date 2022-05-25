import 'package:body_temperature_note/data/model/hive_memo.dart';
import 'package:body_temperature_note/data/model/hive_record.dart';
import 'package:body_temperature_note/data/model/memo_ui_model.dart';
import 'package:body_temperature_note/data/model/record_ui_model.dart';
import 'package:body_temperature_note/data/provider/firebase_cloud_store_record_provider.dart';
import 'package:body_temperature_note/data/provider/hive_memo_provider.dart';
import 'package:body_temperature_note/data/provider/hive_record_provider.dart';
import 'package:body_temperature_note/data/repository/repository.dart';

class RecordRepository extends Repository {
  HiveRecordProvider hiveRecordProvider;
  HiveMemoProvider hiveMemoProvider;
  FirebaseCloudStoreRecordProvider firebaseCloudStoreRecordProvider;

  RecordRepository({
    required this.hiveRecordProvider,
    required this.hiveMemoProvider,
    required this.firebaseCloudStoreRecordProvider,
  });

  @override
  Future<void> addOrUpdateRecord(RecordModel record) {
    final formattedDate = DateTime(record.dateTime.year, record.dateTime.month,
        record.dateTime.day, record.dateTime.hour, record.dateTime.minute);

    final existedRecord =
        hiveRecordProvider.queryRecordByDateTime(formattedDate);
    if (existedRecord != null) {
      return hiveRecordProvider.addOrUpdateRecord(existedRecord
        ..temperature = record.temperature
        ..dateTime = formattedDate);
    } else {
      return hiveRecordProvider.addOrUpdateRecord(HiveRecord()
        ..dateTime = formattedDate
        ..temperature = record.temperature);
    }
  }

  @override
  RecordModel? queryRecordByDate(DateTime now) {
    final existedRecord = hiveRecordProvider.queryRecordByDateTime(now);
    if (existedRecord == null) return null;
    return RecordModel(
        temperature: existedRecord.temperature,
        dateTime: existedRecord.dateTime);
  }

  @override
  List<RecordModel> queryMonthRecords(DateTime month) {
    return hiveRecordProvider
        .queryMonthRecords(month)
        .map((it) =>
            RecordModel(temperature: it.temperature, dateTime: it.dateTime))
        .toList(growable: false);
  }

  @override
  List<RecordModel> queryDayRecords(DateTime today) {
    return hiveRecordProvider
        .queryDayRecords(today)
        .map((it) =>
            RecordModel(temperature: it.temperature, dateTime: it.dateTime))
        .toList(growable: false);
  }

  @override
  Future<void> addOrUpdateMemo(MemoModel memoModel) {
    final formattedDate = DateTime(memoModel.dateTime.year,
        memoModel.dateTime.month, memoModel.dateTime.day);

    final existedMemo = hiveMemoProvider.queryMemoByDateTime(formattedDate);
    if (existedMemo != null) {
      return hiveMemoProvider.addOrUpdateMemo(existedMemo
        ..memo = memoModel.memo
        ..dateTime = formattedDate);
    } else {
      return hiveMemoProvider.addOrUpdateMemo(HiveMemo()
        ..dateTime = formattedDate
        ..memo = memoModel.memo);
    }
  }

  @override
  Future<void> deleteMemo(DateTime datetime) {
    return hiveMemoProvider.deleteMemo(datetime);
  }

  @override
  Future<void> deleteRecord(RecordModel record) {
    final existedRecord =
        hiveRecordProvider.queryRecordByDateTime(record.dateTime);
    return hiveRecordProvider.removeRecord(existedRecord!);
  }

  @override
  MemoModel? queryMemo(DateTime day) {
    HiveMemo? hiveMemo = hiveMemoProvider.queryMemoByDateTime(day);
    if (hiveMemo == null) {
      return null;
    }

    return MemoModel(memo: hiveMemo.memo, dateTime: hiveMemo.dateTime);
  }

  @override
  List<MemoModel> queryMonthMemos(DateTime month) {
    return hiveMemoProvider
        .queryMonthRecords(month)
        .map((it) => MemoModel(memo: it.memo, dateTime: it.dateTime))
        .toList(growable: false);
  }
}
