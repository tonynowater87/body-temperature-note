import 'package:auto_route/annotations.dart';
import 'package:body_temperature_note/constants.dart';
import 'package:body_temperature_note/data/provider/setting_provider.dart';
import 'package:body_temperature_note/data/repository/repository.dart';
import 'package:body_temperature_note/main.dart';
import 'package:body_temperature_note/utils/date_time_extensions.dart';
import 'package:body_temperature_note/utils/string_extensions.dart';
import 'package:body_temperature_note/utils/view/date_toolbar_widget.dart';
import 'package:body_temperature_note/views/chart/cubit/chart_cubit.dart';
import 'package:date_format/date_format.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

class ChartPage extends StatefulWidget {
  late String dateString;

  ChartPage({@PathParam("argument") required this.dateString})
      : super(key: null);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  var isShownReturnToNowButton = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final _logger = getIt<Logger>();
        _logger.d("chart create bloc");
        var chartCubit = ChartCubit(
            context.read<Repository>(), context.read<SettingsProvider>());
        chartCubit.init(DateTime.parse(widget.dateString));
        return chartCubit;
      },
      child: Scaffold(
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
                  return const Center(child: CircularProgressIndicator());
                } else {
                  ChartLoadedState loadedState = _state as ChartLoadedState;
                  return Column(
                    children: [
                      DateToolbarWidget(
                        height: 100,
                        title: loadedState.title,
                        onClickNext: () {
                          isShownReturnToNowButton = true;
                          context.read<ChartCubit>().changeToNext();
                        },
                        onClickPrevious: () {
                          isShownReturnToNowButton = true;
                          context.read<ChartCubit>().changeToPrevious();
                        },
                        onClickTitle: () {},
                        isShownReturnToNowButton: isShownReturnToNowButton,
                        onClickReturn: () {
                          isShownReturnToNowButton = false;
                          context.read<ChartCubit>().changeToToday();
                        },
                      ),
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
                                      tooltipBgColor: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      getTooltipItems:
                                          (List<LineBarSpot> touchedBarSpots) {
                                        return touchedBarSpots.map((element) {
                                          var memo = loadedState
                                              .memos[element.x.toInt() -
                                              loadedState.minX.toInt()]
                                              .memo;
                                          var temp;
                                          if (loadedState.isCelsius) {
                                            temp = "%.2f%s"
                                                .format([element.y, "°C"]);
                                          } else {
                                            temp = "%.2f%s"
                                                .format([element.y, "°F"]);
                                          }
                                          var dateTime = fromDayInYearSince1970(
                                              element.x.toInt());
                                          var formatDateString = formatDate(
                                              dateTime,
                                              titleDateFormatChartTouchData);
                                          return LineTooltipItem(
                                              "$temp\n$formatDateString\n$memo",
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
                                            var dateTime =
                                            fromDayInYearSince1970(
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
                      SizedBox(
                          width: double.maxFinite,
                          child: MaterialSegmentedControl(
                            borderColor: Theme.of(context).dividerColor,
                            selectedColor: Theme.of(context).primaryColor,
                            unselectedColor: Theme.of(context).disabledColor,
                            children: {
                              0: Text('週',
                                  style:
                                  Theme.of(context).textTheme.bodyMedium),
                              1: Text('月',
                                  style:
                                  Theme.of(context).textTheme.bodyMedium),
                              2: Text('季',
                                  style:
                                  Theme.of(context).textTheme.bodyMedium),
                            },
                            selectionIndex: _state.chartDuration.index,
                            onSegmentChosen: (index) {
                              switch (index) {
                                case 0:
                                  context
                                      .read<ChartCubit>()
                                      .updateChartDuration(ChartDuration.week);
                                  break;
                                case 1:
                                  context
                                      .read<ChartCubit>()
                                      .updateChartDuration(ChartDuration.month);
                                  break;
                                case 2:
                                  context
                                      .read<ChartCubit>()
                                      .updateChartDuration(
                                      ChartDuration.season);
                                  break;
                              }
                            },
                          )),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  );
                }
              },
            )),
      ),
    );
  }
}
