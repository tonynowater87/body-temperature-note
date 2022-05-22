import 'package:body_temperature_note/data/model/hive_memo.dart';
import 'package:hive/hive.dart';

class HiveMemoProvider {
  final Box<HiveMemo> box;

  HiveMemoProvider(this.box);

  HiveMemo? queryMemoByDateTime(DateTime dateTime) {
    HiveMemo? existedMemo;

    try {
      existedMemo =
          box.values.firstWhere((element) => element.dateTime == dateTime);
    } on StateError {
      existedMemo = null;
    }

    return existedMemo;
  }

  Future<int> addOrUpdateMemo(HiveMemo newlyHiveMemo) async {
    HiveMemo? existedMemo;
    try {
      existedMemo = box.values
          .firstWhere((element) => element.dateTime == newlyHiveMemo.dateTime);
    } on StateError {
      existedMemo = null;
    }

    if (existedMemo == null) {
      return box.add(newlyHiveMemo);
    } else {
      await box.put(existedMemo.key, newlyHiveMemo);
      return Future.value(newlyHiveMemo.key);
    }
  }

  Future<bool> deleteMemo(DateTime date) {
    HiveMemo? existedMemo;

    try {
      existedMemo =
          box.values.firstWhere((element) => element.dateTime == date);
    } on StateError {
      existedMemo = null;
    }

    if (existedMemo == null) {
      return Future.value(false);
    } else {
      return box.delete(existedMemo.key).then((value) => true);
    }
  }
}
