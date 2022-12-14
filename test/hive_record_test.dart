import 'package:body_temperature_note/data/model/hive_record.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  var path = "HiveRecordTest";
  Hive.init(path);
  Hive.registerAdapter(HiveRecordAdapter());
  print('[Tony] test start');

  group('hive playground', () {
    Box<HiveRecord>? box;

    setUp(() async {
      box = await Hive.openBox(path);
      print('[Tony] setup');
    });

    tearDown(() async {
      print('[Tony] tearDown');
      //await box?.deleteFromDisk();
      box?.close();
      Hive.close();
    });

    test('test inserted', () {
      // cool syntax
      box?.add(HiveRecord()
        ..temperature = 36.2
        ..dateTime = DateTime.now());

      box?.add(HiveRecord()
        ..temperature = 36.2
        ..dateTime = DateTime.now());

      box?.add(HiveRecord()
        ..temperature = 36.2
        ..dateTime = DateTime.now());

      final insertedBox = box?.getAt(0);
      expect(insertedBox!.temperature, 36.2);

      print('[Tony] t1');
    });

    test('test updated', () {
      final firstItem = box!.getAt(0)!;
      (firstItem..dateTime = DateTime.now()).save();
    });

    test('test deleted', () {
      //box!.delete(box!.values.first.key);
    });

    test('test query and filter', () {
      final values = box?.values;
      /*final filtered = values?.where((element) =>
          element.dateTime
              .isBefore(DateTime.parse("2022-04-19 23:45:31.312")) &&
          element.dateTime.isAfter(DateTime.parse("2022-04-19 23:45:31.301")));*/

      values?.forEach((HiveRecord element) {
        print('[Tony] $element ${element.hashCode}');
      });
      print('[Tony] t2');
    });
  });
}
