import 'package:body_temperature_note/data/model/hive_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCloudStoreRecordProvider {

  final FirebaseFirestore fireStore;

  FirebaseCloudStoreRecordProvider(this.fireStore);

  void addRecord(HiveRecord record) async {
    //fireStore.doc("record")
  }

  void updateRecord(HiveRecord record) async {}

  List<HiveRecord> queryTodayRecords(DateTime today) {
    return List.empty();
  }

  List<HiveRecord> queryMonthRecords(DateTime month) {
    return List.empty();
  }
}
