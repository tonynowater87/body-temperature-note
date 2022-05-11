import 'package:body_temperature_note/data/model/hive_memo.dart';
import 'package:body_temperature_note/data/model/hive_record.dart';
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
  Future<void> addOrUpdateRecord(HiveRecord record) {
    return hiveRecordProvider.addOrUpdateRecord(record);
  }

  @override
  HiveRecord? queryRecordByDate(DateTime now) {
    return hiveRecordProvider.queryRecordByDateTime(now);
  }

  @override
  List<HiveRecord> queryMonthRecords(DateTime month) {
    return hiveRecordProvider.queryMonthRecords(month);
  }

  @override
  List<HiveRecord> queryDayRecords(DateTime today) {
    return hiveRecordProvider.queryDayRecords(today);
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
  Future<void> deleteRecord(HiveRecord record) {
    return hiveRecordProvider.removeRecord(record);
  }
}
