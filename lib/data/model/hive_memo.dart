import 'package:hive/hive.dart';

part 'hive_memo.g.dart';

@HiveType(typeId: 2)
class HiveMemo extends HiveObject {
  @HiveField(0)
  late String memo;

  @HiveField(1)
  late DateTime dateTime;

  @override
  String toString() {
    return 'Record{key:$key, memo: $memo, dateTime: $dateTime}';
  }
}
