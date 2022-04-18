import 'package:auto_route/auto_route.dart';
import 'package:body_temperature_note/route/app_router.gr.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'home_cubit.dart';

class DateSelectorWidget extends StatefulWidget {
  const DateSelectorWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DateSelectorWidgetState();
  }
}

class _DateSelectorWidgetState extends State<DateSelectorWidget> {
  final itemScrollController = ItemScrollController();
  final itemPositionsListener = ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeDateState) {
          if (state.currentDay != null) {
            print('[Tony] SCROLLING!!');
            itemScrollController.scrollTo(
                index: DateTime.now().day -
                    1, // offset from the position scrolled to , 0..1
                duration: const Duration(milliseconds: 200));
          }
        }
      },
      child: Expanded(
          child: Column(
        children: [
          Container(
            color: Colors.lime.shade100,
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
                    icon: const Icon(Icons.arrow_left_outlined)),
                SizedBox(
                  width: 150,
                  child: TextButton(
                    onPressed: () {
                      context.read<HomeCubit>().changeToToday();
                    },
                    child: BlocBuilder<HomeCubit, HomeState>(
                      builder: (BuildContext context, state) {
                        if (state is HomeDateState) {
                          return Text(
                            formatDate(
                                DateTime(state.currentYear, state.currentMonth),
                                [yyyy, '-', mm]),
                            textAlign: TextAlign.center,
                          );
                        } else {
                          throw Exception('unexpected HomeState = $state');
                        }
                      },
                    ),
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
                    icon: const Icon(Icons.arrow_right_outlined)),
              ],
            ),
          ),
          const Divider(
            height: 0.0,
            thickness: 0.5,
            color: Colors.grey,
          ),
          Expanded(child: BlocBuilder<HomeCubit, HomeState>(
            builder: (BuildContext context, HomeState _state) {
              final state = _state as HomeDateState;
              return ScrollablePositionedList.separated(
                  padding: const EdgeInsets.only(bottom: 10),
                  itemBuilder: (_, index) {
                    return ListTile(
                      onTap: () async {
                        final currentState = context.read<HomeCubit>().state as HomeDateState;
                        final now = DateTime.now();
                        final dateString = formatDate(
                            DateTime(
                                currentState.currentYear,
                                currentState.currentMonth,
                                index + 1,
                                now.hour,
                                now.minute,
                                now.second),
                            [
                              yyyy,
                              '-',
                              mm,
                              '-',
                              dd,
                              ' ',
                              HH,
                              ':',
                              mm,
                              ':',
                              dd
                            ]);
                        context
                            .pushRoute(InputPageRoute(dateString: dateString));
                      },
                      title: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: _getWeekDaysTextColor(DateTime(
                                state.currentYear,
                                state.currentMonth,
                                index + 1))),
                      ),
                      subtitle: Text(
                        formatDate(
                            DateTime(state.currentYear, state.currentMonth,
                                index + 1),
                            [D]),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getWeekDaysTextColor(DateTime(
                                state.currentYear,
                                state.currentMonth,
                                index + 1))),
                      ),
                      selected: index == DateTime.now().day - 1 &&
                          state.currentMonth == DateTime.now().month,
                      selectedTileColor: Colors.yellow,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                        thickness: 0.5, height: 1, color: Colors.grey);
                  },
                  itemScrollController: itemScrollController,
                  itemPositionsListener: itemPositionsListener,
                  itemCount: state.currentDaysOfMonth);
            },
          )),
        ],
      )),
    );
  }

  Color _getWeekDaysTextColor(DateTime dateTime) {
    final int weekday = dateTime.weekday;
    var textColor = Colors.black87;
    if (weekday == 6) {
      textColor = Colors.orange;
    } else if (weekday == 7) {
      textColor = Colors.redAccent;
    }
    return textColor;
  }
}
