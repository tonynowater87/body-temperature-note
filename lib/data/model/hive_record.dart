import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'hive_record.g.dart';

@HiveType(typeId: 1)
class HiveRecord extends HiveObject {
  @HiveField(0)
  late double temperature;

  @HiveField(1)
  late DateTime dateTime; // [yyyy, mm, dd, HH, nn];

  @override
  String toString() {
    return 'Record{key:$key, temperature: $temperature, dateTime: ${DateFormat("MM.dd.hh.mm").format(dateTime)}}';
  }
}