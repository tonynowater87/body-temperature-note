part of 'chart_cubit.dart';

abstract class ChartPageState extends Equatable {}

class ChartLoadingState extends ChartPageState {
  @override
  List<Object?> get props => [Random().nextInt(0x7fffffff)];
}

class ChartLoadedState extends ChartPageState {
  late String title;
  late double? baseline;
  late ChartDuration chartDuration;
  late List<ChartModel> records;
  late double maxY;
  late double minY;
  late double minX;
  late double maxX;
  late double intervalsX;

  @override
  List<Object> get props =>
      [records, title, chartDuration, intervalsX, maxX, minX, maxY, minY];

  ChartLoadedState({
    required this.title,
    this.baseline,
    required this.chartDuration,
    required this.records,
    required this.maxY,
    required this.minY,
    required this.minX,
    required this.maxX,
    required this.intervalsX,
  });
}

enum ChartDuration { week, month, season }
