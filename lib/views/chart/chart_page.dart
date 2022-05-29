import 'package:auto_route/annotations.dart';
import 'package:body_temperature_note/utils/view/date_toolbar_widget.dart';
import 'package:body_temperature_note/views/chart/cubit/chart_cubit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartPage extends StatefulWidget {
  late String dateString;

  ChartPage({@PathParam("argument") required this.dateString})
      : super(key: null);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChartCubit>().init(DateTime.parse(widget.dateString));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        title: Text(
          "Chart",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Container(
          color: Theme.of(context).colorScheme.background,
          child: BlocBuilder<ChartCubit, ChartPageState>(
            builder: (context, _state) {
              if (_state is ChartLoadingState) {
                return Center(child: CircularProgressIndicator());
              } else {
                ChartLoadedState loadedState = _state as ChartLoadedState;
                return Column(
                  children: [
                    DateToolbarWidget(
                        title: loadedState.title,
                        onClickNext: () {
                          context.read<ChartCubit>().changeToNext();
                        },
                        onClickPrevious: () {
                          context.read<ChartCubit>().changeToPrevious();
                        },
                        onClickTitle: () {
                          context.read<ChartCubit>().changeToToday();
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: LineChart(LineChartData(
                              minY: 0,
                              maxY: 50,
                              maxX: 30,
                              minX: 1,
                              extraLinesData: _state.baseline != null
                                  ? ExtraLinesData(horizontalLines: [
                                      HorizontalLine(y: _state.baseline!)
                                    ])
                                  : null,
                              borderData: FlBorderData(show: false),
                              titlesData: FlTitlesData(
                                  topTitles: AxisTitles(),
                                  rightTitles: AxisTitles(),
                                  bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 16,
                                          interval: 5,
                                          getTitlesWidget: (value, meta) =>
                                              Text('${value.toInt()}')))),
                              lineBarsData: [
                                LineChartBarData(
                                    spots: _state.records
                                        .map((e) => FlSpot(
                                            e.valueX.toDouble(), e.valueY))
                                        .toList(),
                                    gradient: LinearGradient(
                                        colors: [Colors.green, Colors.red]))
                              ])),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.maxFinite,
                      child: CupertinoSegmentedControl(
                          children: const {
                            1: Text('週'),
                            2: Text('月'),
                            3: Text('季'),
                          },
                          groupValue: _state.chartDuration.index + 1,
                          onValueChanged: (value) {
                            switch (value) {
                              case 1:
                                context
                                    .read<ChartCubit>()
                                    .updateChartDuration(ChartDuration.week);
                                break;
                              case 2:
                                context
                                    .read<ChartCubit>()
                                    .updateChartDuration(ChartDuration.month);
                                break;
                              case 3:
                                context
                                    .read<ChartCubit>()
                                    .updateChartDuration(ChartDuration.season);
                                break;
                            }
                          }),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                );
              }
            },
          )),
    );
  }
}
