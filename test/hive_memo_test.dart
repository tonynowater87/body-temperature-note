import 'package:body_temperature_note/data/model/hive_memo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

main() {
  var path = "HiveMemoTest";
  Hive.init(path);
  Hive.registerAdapter(HiveMemoAdapter());
  print('[Tony] hive_memo_test.dart start');

  group('test hive memo', () {
    Box<HiveMemo>? box;
    setUp(() async {
      box = await Hive.openBox(path);
      print('[Tony] group setUp $box');
    });
    tearDown(() {
      print('[Tony] group tearDown');
      box?.close();
      Hive.close();
    });

    test('insert & update memo', () async {
      var now = DateTime.now();
      var newlyHiveMemo = HiveMemo()
        ..memo = "Test Memo 1"
        ..dateTime = DateTime(now.year, now.month, now.day);

      // check is existed
      HiveMemo? existedMemo;
      try {
        existedMemo = box!.values.firstWhere(
            (element) => element.dateTime == newlyHiveMemo.dateTime);
      } on StateError {
        // NOTE: if on block catch the error, then catch block will not be executed
        print('[Tony] onStateError');
        existedMemo = null;
      } catch (e) {
        print('[Tony] catch StateError = $e');
        existedMemo = null;
      }

      if (existedMemo != null) {
        // putUpdated
        await box!.putAt(existedMemo.key, newlyHiveMemo..memo = "Updated");
        final updatedMemo = box!.get(newlyHiveMemo.key)!;
        print(
            '[Tony] updated, updatedId = ${updatedMemo.key}, memo = ${updatedMemo.memo}');
        expect(updatedMemo.memo, "Updated");
      } else {
        // inserted
        final insertedId = await box!.add(newlyHiveMemo);
        final insertedMemo = box!.get(insertedId);
        print(
            '[Tony] inserted, insertedId = $insertedId, memo = $insertedMemo');
        expect(insertedMemo!.memo, "Test Memo 1");
      }

      final memos = box!.values;
      expect(memos.length, 1);
    });

    test('delete memo', () async {
      // delete by key
      // box!.delete(key);

      // delete by position
      // box!.deleteAt(index);

      // delete all keys
      // box?.deleteAll(keys);

      // delete all
      DateTime now = DateTime.now();
      final memo1 = HiveMemo()
        ..memo = "Test Memo 1"
        ..dateTime = DateTime(now.year, now.month, now.day);
      await box!.add(memo1);

      final memo2 = HiveMemo()
        ..memo = "Test Memo 1"
        ..dateTime = DateTime(now.year, now.month, now.day);
      await box!.add(memo2);
      final clearedCount = await box!.clear();
      print('[Tony] clearedCount = $clearedCount');
      //box!.deleteFromDisk();
    });
  });
}
