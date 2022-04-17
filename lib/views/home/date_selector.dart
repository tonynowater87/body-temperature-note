import 'package:auto_route/auto_route.dart';
import 'package:body_temperature_note/route/app_router.gr.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class DateSelectorWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DateSelectorWidgetState();
  }
}

class _DateSelectorWidgetState extends State<DateSelectorWidget> {
  final itemScrollController = ItemScrollController();
  final itemPositionsListener = ItemPositionsListener.create();
  int currentYear = DateTime.now().year;
  int currentMonth = DateTime.now().month;
  int currentDaysOfMonth = 0;
  String currentWeekDaysName = '';
  bool initializedList = false;

  @override
  void initState() {
    super.initState();
    currentDaysOfMonth = DateUtils.getDaysInMonth(currentYear, currentMonth);
    itemPositionsListener.itemPositions.addListener(() {
      if (!initializedList) {
        // scroll to current day
        itemScrollController.scrollTo(
            index: DateTime.now().day -
                1, // offset from the position scrolled to , 0..1
            duration: const Duration(milliseconds: 200));
        initializedList = true;
      }
    });
  }

  void _backToCurrentDate() {
    setState(() {
      currentYear = DateTime.now().year;
      currentMonth = DateTime.now().month;
      initializedList = false;
    });
  }

  void _addMonth() {
    setState(() {
      if (currentMonth < 12) {
        currentMonth++;
      } else {
        currentYear++;
        currentMonth = DateTime.january;
      }
    });
  }

  void _minusMonth() {
    setState(() {
      if (currentMonth > 1) {
        currentMonth--;
      } else {
        currentYear--;
        currentMonth = DateTime.december;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    currentDaysOfMonth = DateUtils.getDaysInMonth(currentYear, currentMonth);
    debugPrint(
        '[Tony] build year = $currentYear, month = $currentMonth, daysInMonth = $currentDaysOfMonth');
    return Expanded(
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
                    _minusMonth();
                  },
                  icon: const Icon(Icons.arrow_left_outlined)),
              SizedBox(
                width: 150,
                child: TextButton(
                  onPressed: () {
                    _backToCurrentDate();
                  },
                  child: Text(
                    formatDate(
                        DateTime(currentYear, currentMonth), [yyyy, '-', mm]),
                    textAlign: TextAlign.center,
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
                    _addMonth();
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
        Expanded(
            child: ScrollablePositionedList.separated(
                padding: const EdgeInsets.only(bottom: 10),
                itemBuilder: (_, index) {
                  return ListTile(
                    onTap: () async {
                      final now = DateTime.now();
                      final dateString = formatDate(
                          DateTime(currentYear, currentMonth, index + 1,
                              now.hour, now.minute, now.second),
                          [yyyy, '-', mm, '-', dd, ' ', HH, ':', mm, ':', dd]);
                      context.pushRoute(InputPageRoute(dateString: dateString));
                    },
                    title: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: _getWeekDaysTextColor(
                              DateTime(currentYear, currentMonth, index + 1))),
                    ),
                    subtitle: Text(
                      formatDate(
                          DateTime(currentYear, currentMonth, index + 1), [D]),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getWeekDaysTextColor(
                              DateTime(currentYear, currentMonth, index + 1))),
                    ),
                    selected: index == DateTime.now().day - 1 &&
                        currentMonth == DateTime.now().month,
                    selectedTileColor: Colors.yellow,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                      thickness: 0.5, height: 1, color: Colors.grey);
                },
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
                itemCount: currentDaysOfMonth)),
      ],
    ));
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
