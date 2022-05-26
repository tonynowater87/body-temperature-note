import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:body_temperature_note/data/model/record_ui_model.dart';
import 'package:body_temperature_note/main.dart';
import 'package:body_temperature_note/route/app_router.gr.dart';
import 'package:body_temperature_note/utils/string_extensions.dart';
import 'package:body_temperature_note/views/home/cubit/home_cubit.dart';
import 'package:body_temperature_note/views/home/cubit/home_state.dart';
import 'package:body_temperature_note/views/memo/memo_page.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class DateSelectorWidget extends StatefulWidget {
  const DateSelectorWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DateSelectorWidgetState();
  }
}

class _DateSelectorWidgetState extends State<DateSelectorWidget> {
  final scrollController = ScrollController();
  final itemScrollController = ItemScrollController();
  final itemPositionsListener = ItemPositionsListener.create();
  final _logger = getIt.get<Logger>();

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().stream.listen((state) {
      if (state is HomeInitState) {
        itemScrollController.jumpTo(index: DateTime.now().day - 1);
      } else if (state is HomeDateState &&
          state.currentDay == DateTime.now().day) {
        itemScrollController.scrollTo(
            index: DateTime.now().day - 1,
            // alignment: 0.2 // offset from the position scrolled to , 0..1
            duration: const Duration(milliseconds: 200));
      }
    });
    BlocProvider.of<HomeCubit>(context).changeToToday();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Column(
          children: <Widget>[
            Container(
              height: 60,
              color: Theme.of(context).colorScheme.background,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    constraints:
                        const BoxConstraints(minHeight: 40, minWidth: 40),
                    onPressed: () {
                      context.read<HomeCubit>().previousMonth();
                    },
                    icon: Icon(Icons.arrow_circle_left_outlined),
                    color: Theme.of(context).iconTheme.color,
                  ),
                  SizedBox(
                    width: 150,
                    child: TextButton(
                      onPressed: () {
                        context.read<HomeCubit>().changeToToday();
                      },
                      child: BlocBuilder<HomeCubit, HomeState>(
                          builder: (BuildContext context, state) {
                        return Text(
                          formatDate(
                              DateTime(state.currentYear, state.currentMonth),
                              [yyyy, '-', mm]),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        );
                      }),
                    ),
                  ),
                  IconButton(
                      padding: EdgeInsets.zero,
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      constraints:
                          const BoxConstraints(minHeight: 40, minWidth: 40),
                      onPressed: () {
                        context.read<HomeCubit>().nextMonth();
                      },
                      icon: Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Theme.of(context).iconTheme.color,
                      )),
                ],
              ),
            ),
            const Divider(
              height: 0.0,
              thickness: 0.5,
            ),
            state is HomeInitState
                ? const CircularProgressIndicator()
                : dateList(state as HomeDateState)
          ],
        );
      },
    );
  }

  Widget dateList(HomeDateState state) {
    return Expanded(
        child: ScrollablePositionedList.separated(
            padding: const EdgeInsets.only(bottom: 10),
            itemBuilder: (_, index) {
              final dayRecords = state.dateListModel.outputRecords[index];
              final List<Widget> temperatureViews = [];
              if (dayRecords.isEmpty) {
                temperatureViews.add(const Card(
                    child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('No Temperature'),
                )));
              } else {
                var maxCount = 0;
                for (int i = 0; i < dayRecords.length; i++) {
                  if (maxCount == 3) break;
                  maxCount++;
                  temperatureViews.add(Card(
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          child:
                              Text("%.2f".format([dayRecords[i].temperature])),
                          onTap: () {
                            onTapTemperature(context, dayRecords[i]);
                          }),
                    ),
                  ));
                }
              }

              var memo = state.dateListModel.outputMemos[index];
              if (memo != null && memo.memo.isNotEmpty) {
                temperatureViews.add(Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      child: Text(memo.memo),
                      onTap: () {
                        onTapMemo(state, index);
                      }),
                ));
              } else {
                temperatureViews.add(Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      child: Icon(Icons.note_add_outlined,
                          color: Theme.of(context).iconTheme.color),
                      onTap: () {
                        onTapMemo(state, index);
                      }),
                ));
              }

              return ListTile(
                onTap: () => onTapDay(context, index),
                trailing: Wrap(children: temperatureViews),
                title: Text((index + 1).toString(),
                    style: _getWeekDaysTextStyle(DateTime(
                        state.currentYear, state.currentMonth, index + 1))),
                subtitle: Text(
                    formatDate(
                        DateTime(
                            state.currentYear, state.currentMonth, index + 1),
                        [D]),
                    style: _getWeekDaysTextStyle(DateTime(
                        state.currentYear, state.currentMonth, index + 1))),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(thickness: 0.5, height: 1);
            },
            itemScrollController: itemScrollController,
            itemPositionsListener: itemPositionsListener,
            itemCount: state.currentDaysOfMonth));
  }

  onTapMemo(HomeDateState state, int index) async {
    bool? shouldRefresh = await showDialog<bool?>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return MemoPage(dateString: state.toDaysStringIso8604(index + 1));
      },
    );
    if (shouldRefresh == true) {
      context.read<HomeCubit>().refreshRecords();
    }
  }

  TextStyle _getWeekDaysTextStyle(DateTime dateTime) {
    final int weekday = dateTime.weekday;
    var textStyle = Theme.of(context).textTheme.headlineMedium!;
    if (weekday == 6) {
      textStyle = textStyle.copyWith(
          color: Theme.of(context).colorScheme.secondary,
          fontStyle: FontStyle.italic);
    } else if (weekday == 7) {
      textStyle = textStyle.copyWith(
          color: Theme.of(context).colorScheme.secondary,
          fontStyle: FontStyle.italic);
    }
    return textStyle;
  }

  onTapDay(BuildContext context, int index) async {
    final currentState = context.read<HomeCubit>().state;
    final now = DateTime.now();
    final dateString = formatDate(
        DateTime(currentState.currentYear, currentState.currentMonth, index + 1,
            now.hour, now.minute, now.second),
        [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
    final saved =
        await context.router.push<bool>(InputPageRoute(dateString: dateString));
    if (saved == true) {
      context.read<HomeCubit>().refreshRecords();
    }
  }

  onTapTemperature(BuildContext context, RecordModel recordModel) async {
    final dateString = formatDate(recordModel.dateTime,
        [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
    final saved =
        await context.router.push<bool>(InputPageRoute(dateString: dateString));
    if (saved == true) {
      context.read<HomeCubit>().refreshRecords();
    }
  }
}
