import 'package:auto_route/annotations.dart';
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
    context.read<ChartCubit>();
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
      body: Center(
        child: Container(
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
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
                        extraLinesData: ExtraLinesData(
                            horizontalLines: [HorizontalLine(y: 38)]),
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
                              spots: [
                                FlSpot(2, 2),
                                FlSpot(15, 10),
                              ],
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
                child: CupertinoSegmentedControl(children: const {
                  1: Text('週'),
                  2: Text('月'),
                  3: Text('季'),
                }, groupValue: 1, onValueChanged: (value) => {}),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
