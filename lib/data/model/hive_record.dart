import 'package:hive/hive.dart';

part 'hive_record.g.dart';

@HiveType(typeId: 1)
class HiveRecord extends HiveObject {
  @HiveField(0)
  late double temperature;

  @HiveField(1)
  late DateTime dateTime;

  @override
  String toString() {
    return 'Record{key:$key, temperature: $temperature, dateTime: $dateTime}';
  }
}