import 'package:auto_route/annotations.dart';
import 'package:body_temperature_note/constants.dart';
import 'package:body_temperature_note/utils/view/date_toolbar_widget.dart';
import 'package:body_temperature_note/views/chart/cubit/chart_cubit.dart';
import 'package:date_format/date_format.dart';
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
          width: double.maxFinite,
          child: BlocBuilder<ChartCubit, ChartPageState>(
            builder: (context, _state) {
              if (_state is ChartLoadingState) {
                return Center(child: CircularProgressIndicator());
              } else {
                ChartLoadedState loadedState = _state as ChartLoadedState;
                return Column(
                  children: [
                    DateToolbarWidget(
                        height: 100,
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
                        child: LineChart(LineChartData(
                            minY: _state.minY - 5,
                            maxY: _state.maxY + 5,
                            maxX: _state.maxX,
                            minX: _state.minX,
                            lineTouchData: LineTouchData(
                                touchTooltipData: LineTouchTooltipData(
                                    maxContentWidth:
                                        MediaQuery.of(context).size.width / 2,
                                    fitInsideHorizontally: true,
                                    tooltipBgColor:
                                        Theme.of(context).colorScheme.onSurface,
                                    getTooltipItems:
                                        (List<LineBarSpot> touchedBarSpots) {
                                      return touchedBarSpots.map((element) {
                                        var dateTime =
                                            DateTime.fromMillisecondsSinceEpoch(
                                                element.x.toInt());
                                        var formatDateString = formatDate(
                                            dateTime,
                                            titleDateFormatChartTouchData);
                                        return LineTooltipItem(
                                            "${element.y}\n$formatDateString",
                                            Theme.of(context)
                                                .textTheme
                                                .headlineSmall!);
                                      }).toList();
                                    })),
                            extraLinesData: _state.baseline != null
                                ? ExtraLinesData(horizontalLines: [
                                    HorizontalLine(y: _state.baseline!)
                                  ])
                                : null,
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                                topTitles: AxisTitles(),
                                bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 16,
                                        interval: _state.intervalsX,
                                        getTitlesWidget: (value, meta) {
                                          var dateTime = DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  value.toInt());
                                          print(
                                              '[Tony] value=$value,dateTime=$dateTime,max=${meta.max},min=${meta.min},meta=${meta.formattedValue}');
                                          if (_state.chartDuration ==
                                              ChartDuration.week) {
                                            return Text(formatDate(dateTime,
                                                titleWeekDaysAbbrFormat));
                                          } else {
                                            return Text(formatDate(dateTime,
                                                titleDateFormatChartXAxis));
                                          }
                                        }))),
                            lineBarsData: [
                              LineChartBarData(
                                  spots: _state.records
                                      .map((e) =>
                                          FlSpot(e.valueX.toDouble(), e.valueY))
                                      .toList(),
                                  gradient: LinearGradient(
                                      colors: [Colors.green, Colors.red]))
                            ])),
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
