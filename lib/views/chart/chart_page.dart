import 'package:auto_route/annotations.dart';
import 'package:body_temperature_note/constants.dart';
import 'package:body_temperature_note/utils/date_time_extensions.dart';
import 'package:body_temperature_note/utils/string_extensions.dart';
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
                        padding: const EdgeInsets.only(left: 12, right: 24),
                        child: LineChart(LineChartData(
                            minY: _state.minY,
                            maxY: _state.maxY,
                            maxX: _state.maxX,
                            minX: _state.minX,
                            gridData:
                                FlGridData(getDrawingHorizontalLine: (value) {
                              return FlLine(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  strokeWidth: 0.25,
                                  dashArray: [15, 5]);
                            }, getDrawingVerticalLine: (value) {
                              return FlLine(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  strokeWidth: 0.25,
                                  dashArray: [15, 5]);
                            }),
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
                                        var temp = "%.2f".format([element.y]);
                                        var dateTime = fromDayInYearSince1970(
                                            element.x.toInt());
                                        var formatDateString = formatDate(
                                            dateTime,
                                            titleDateFormatChartTouchData);
                                        return LineTooltipItem(
                                            "$temp\n$formatDateString",
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
                                rightTitles: AxisTitles(),
                                bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 16,
                                        interval: _state.intervalsX,
                                        getTitlesWidget: (value, meta) {
                                          var dateTime = fromDayInYearSince1970(
                                              value.toInt());
                                          if (_state.chartDuration ==
                                              ChartDuration.week) {
                                            return Text(formatDate(dateTime,
                                                titleWeekDaysAbbrFormat));
                                          }
                                          if (_state.chartDuration ==
                                              ChartDuration.month) {
                                            if (value == meta.min ||
                                                value == meta.max) {
                                              return const Text('');
                                            } else {
                                              return Text(formatDate(dateTime,
                                                  titleDateFormatChartXAxis));
                                            }
                                          } else {
                                            // season
                                            if (value == meta.min ||
                                                value == meta.max) {
                                              return const Text('');
                                            } else {
                                              return Text(formatDate(dateTime,
                                                  titleDateFormatChartXAxis));
                                            }
                                          }
                                        }))),
                            lineBarsData: [
                              LineChartBarData(
                                  isStrokeJoinRound: true,
                                  isStrokeCapRound: true,
                                  isStepLineChart: false,
                                  // TODO
                                  spots: _state.records.map((e) {
                                    return FlSpot(
                                        e.valueX.toDouble(), e.valueY);
                                  }).toList())
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
