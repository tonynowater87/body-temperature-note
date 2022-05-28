part of 'chart_cubit.dart';

abstract class ChartPageState extends Equatable {}

class ChartLoadingState extends ChartPageState {
  @override
  List<Object?> get props => [Random().nextInt(0x7fffffff)];
}

class ChartLoadedState extends ChartPageState {
  late String title;
  late double baseline;
  late ChartDuration chartDuration;
  late List<ChartModel> records;

  @override
  List<Object> get props => [records, title, baseline, chartDuration];

  ChartLoadedState({
    required this.title,
    required this.baseline,
    required this.chartDuration,
    required this.records,
  });
}

enum ChartDuration { week, month, season }
