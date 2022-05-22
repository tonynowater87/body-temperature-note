class MemoModel {
  String memo;
  DateTime dateTime;

  MemoModel({required this.memo, required this.dateTime});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoModel &&
          runtimeType == other.runtimeType &&
          memo == other.memo &&
          dateTime == other.dateTime;

  @override
  int get hashCode => memo.hashCode ^ dateTime.hashCode;
}
