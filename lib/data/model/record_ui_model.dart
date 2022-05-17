class RecordModel {
  double temperature;
  DateTime dateTime;

  RecordModel({required this.temperature, required this.dateTime});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordModel &&
          runtimeType == other.runtimeType &&
          temperature == other.temperature &&
          dateTime == other.dateTime;

  @override
  int get hashCode => temperature.hashCode ^ dateTime.hashCode;
}
