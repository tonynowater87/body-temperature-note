import 'package:body_temperature_note/data/model/hive_memo.dart';
import 'package:body_temperature_note/data/model/hive_record.dart';
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
    final existedRecord =
        hiveRecordProvider.queryRecordByDateTime(record.dateTime);
    if (existedRecord != null) {
      return hiveRecordProvider.addOrUpdateRecord(existedRecord
        ..temperature = record.temperature
        ..dateTime = record.dateTime);
    } else {
      return hiveRecordProvider.addOrUpdateRecord(HiveRecord()
        ..dateTime = record.dateTime
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
  Future<void> addOrUpdateMemo(HiveMemo hiveMemo) {
    return hiveMemoProvider.addOrUpdateMemo(hiveMemo);
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
}
