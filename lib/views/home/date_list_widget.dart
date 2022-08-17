import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:body_temperature_note/constants.dart';
import 'package:body_temperature_note/data/model/record_ui_model.dart';
import 'package:body_temperature_note/main.dart';
import 'package:body_temperature_note/route/app_router.gr.dart';
import 'package:body_temperature_note/utils/string_extensions.dart';
import 'package:body_temperature_note/utils/view/date_toolbar_widget.dart';
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

  var isShownReturnToNowButton = false;

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
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return DateToolbarWidget(
                  title: formatDate(
                      DateTime(state.currentYear, state.currentMonth),
                      titleMonthFormatyyyymm),
                  onClickNext: () {
                    isShownReturnToNowButton = true;
                    context.read<HomeCubit>().nextMonth();
                  },
                  onClickPrevious: () {
                    isShownReturnToNowButton = true;
                    context.read<HomeCubit>().previousMonth();
                  },
                  onClickTitle: () {
                    isShownReturnToNowButton = false;
                    context.read<HomeCubit>().changeToToday();
                  },
                  isShownReturnToNowButton: isShownReturnToNowButton,
                  onClickReturn: () {
                    isShownReturnToNowButton = false;
                    context.read<HomeCubit>().changeToToday();
                  },
                );
              },
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

              temperatureViews.add(const SizedBox(
                width: 10,
              ));

              IconData icon;
              if (memo?.memo.isNotEmpty == true) {
                icon = Icons.note_alt;
              } else {
                icon = Icons.note_alt_outlined;
              }

              temperatureViews.add(Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: InkWell(
                    child: Icon(icon,
                        size: 30, color: Theme.of(context).iconTheme.color),
                    onTap: () {
                      onTapMemo(state, index);
                    }),
              ));

              /*temperatureViews.add(const SizedBox(
                width: 2,
              ));
              temperatureViews.add(Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                    child: Icon(Icons.add_box_outlined,
                        color: Theme.of(context).iconTheme.color),
                    onTap: () {
                      onTapDay(context, index);
                    }),
              ));*/
              var itemDateTime =
                  DateTime(state.currentYear, state.currentMonth, index + 1);
              Color borderColor;
              if (isToday(itemDateTime)) {
                borderColor = Theme.of(context).primaryColor;
              } else {
                borderColor = Colors.transparent;
              }
              return Container(
                color: borderColor,
                child: ListTile(
                  onTap: () => onTapDay(context, index),
                  dense: true,
                  visualDensity:
                      const VisualDensity(vertical: 4, horizontal: 4),
                  trailing: Wrap(children: temperatureViews),
                  title: Text((index + 1).toString(),
                      style: _getWeekDaysTextStyle(itemDateTime)),
                  subtitle: Text(
                      formatDate(itemDateTime, titleWeekDaysAbbrFormat),
                      style: _getWeekDaysTextStyle(itemDateTime)),
                ),
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
    final dateString = DateTime(currentState.currentYear,
            currentState.currentMonth, index + 1, now.hour, now.minute)
        .toIso8601String();
    final saved =
        await context.router.push<bool>(InputPageRoute(dateString: dateString));
    if (saved == true) {
      context.read<HomeCubit>().refreshRecords();
    }
  }

  onTapTemperature(BuildContext context, RecordModel recordModel) async {
    final saved = await context.router.push<bool>(
        InputPageRoute(dateString: recordModel.dateTime.toIso8601String()));
    if (saved == true) {
      context.read<HomeCubit>().refreshRecords();
    }
  }

  bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    if (now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day) {
      return true;
    }
    return false;
  }
}
