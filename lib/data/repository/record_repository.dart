import 'package:body_temperature_note/data/model/hive_record.dart';
import 'package:body_temperature_note/data/provider/firebase_cloud_store_record_provider.dart';
import 'package:body_temperature_note/data/provider/hive_record_provider.dart';
import 'package:body_temperature_note/data/repository/repository.dart';

class RecordRepository extends Repository {
  final HiveRecordProvider hiveRecordProvider;
  final FirebaseCloudStoreRecordProvider _firebaseCloudStoreRecordProvider;

  RecordRepository({
    required this.hiveRecordProvider,
    required FirebaseCloudStoreRecordProvider firebaseCloudStoreRecordProvider,
  }) : _firebaseCloudStoreRecordProvider = firebaseCloudStoreRecordProvider;

  @override
  Future<void> addRecord(HiveRecord record) {
    return hiveRecordProvider.addRecord(record);
  }

  @override
  List<HiveRecord> queryMonthRecords(DateTime month) {
    return hiveRecordProvider.queryMonthRecords(month);
  }

  @override
  List<HiveRecord> queryTodayRecords(DateTime today) {
    return hiveRecordProvider.queryTodayRecords(today);
  }

  @override
  Future<void> updateRecord(HiveRecord record) {
    return hiveRecordProvider.updateRecord(record);
  }
}
