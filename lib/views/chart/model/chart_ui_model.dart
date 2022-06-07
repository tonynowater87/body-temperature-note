class ChartModel {
  late double valueY; // temperature
  late int valueX; // day
  late String memo;

  ChartModel({
    required this.valueY,
    required this.valueX,
    required this.memo,
  });

  @override
  String toString() {
    return "x=($valueX:${DateTime.fromMillisecondsSinceEpoch(valueX)}),y=$valueY,memo=$memo";
  }
}
