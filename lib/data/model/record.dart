import 'package:hive/hive.dart';
part 'record.g.dart';

@HiveType(typeId: 1)
class Record extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late double temperature;

  @HiveField(2)
  late DateTime dateTime;

  @override
  String toString() {
    return 'Record{id: $id, temperature: $temperature, dateTime: $dateTime}';
  }
}