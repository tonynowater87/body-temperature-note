import 'package:auto_route/auto_route.dart';
import 'package:body_temperature_note/data/provider/setting_provider.dart';
import 'package:body_temperature_note/data/repository/repository.dart';
import 'package:body_temperature_note/main.dart';
import 'package:body_temperature_note/views/input/cubit/input_cubit.dart';
import 'package:body_temperature_note/views/input/view/temperature_picker.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class InputPage extends StatefulWidget {
  late String dateString;

  InputPage({@PathParam("argument") required this.dateString})
      : super(key: null);

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final logger = getIt.get<Logger>();

  _InputPageState();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = InputCubit(
            repository: context.read<Repository>(),
            settingsProvider: context.read<SettingsProvider>());
        cubit.initState(widget.dateString);
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          title: Text('記錄目前的體溫',
              style: Theme.of(context).textTheme.headlineMedium),
        ),
        body: BlocBuilder<InputCubit, InputState>(
          builder: (context, state) {
            if (state is InputInitial) {
              return const CircularProgressIndicator();
            } else if (state is InputLoading) {
              return const CircularProgressIndicator();
            } else {
              return InputContainer(widget.dateString);
            }
          },
        ),
      ),
    );
  }
}

class InputContainer extends StatefulWidget {
  final String _dateString;

  InputContainer(this._dateString, {Key? key}) : super(key: key);

  @override
  State<InputContainer> createState() => _InputContainerState();
}

class _InputContainerState extends State<InputContainer> {
  final _logger = getIt<Logger>();
  final datePickerController = DatePickerController();
  var isInit = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print('[Tony] addPostFrameCallback $timeStamp');
      if (!isInit) {
        isInit = true;
        datePickerController.animateToDate(DateTime.parse(widget._dateString));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InputCubit, InputState>(
      builder: (context, state) {
        return Container(
          color: Theme.of(context).colorScheme.background,
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DatePicker(
                          DateTime.parse(widget._dateString)
                              .subtract(const Duration(days: 7)),
                          daysCount: 15,
                          controller: datePickerController,
                          initialSelectedDate:
                              DateTime.parse(widget._dateString),
                          selectionColor: Theme.of(context).primaryColor,
                          dateTextStyle: Theme.of(context).textTheme.bodySmall!,
                          dayTextStyle: Theme.of(context).textTheme.bodySmall!,
                          selectedTextColor:
                              Theme.of(context).textTheme.bodyMedium!.color!,
                          onDateChange: (date) {
                            print('[Tony] dateChanged $date');
                          },
                        )
                        /*Text(
                        formatDate(DateTime.parse(_dateString),
                            titleDayFormatyyyymmddDD),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        formatDate(
                            DateTime.parse(_dateString), titleTimeFormathhnn),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),*/
                      ]),
                ),
                Expanded(
                  child: Builder(builder: (context) {
                    if (state is InputLoaded) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [TemperaturePicker()],
                      );
                    } else if (state is InputTimeSetting) {
                      return createInlinePicker(
                          value: TimeOfDay(
                              hour: DateTime.parse(widget._dateString).hour,
                              minute:
                                  DateTime.parse(widget._dateString).minute),
                          minuteLabel: "",
                          hourLabel: "",
                          okText: "",
                          cancelText: "",
                          is24HrFormat: true,
                          onChange: (timeOfDay) {
                            print('[Tony] timeChanged $timeOfDay');
                          });
                    } else {
                      throw Exception("unexpected state : $state");
                    }
                  }),
                ),
                Wrap(
                  direction: Axis.horizontal,
                  children: [
                    ChoiceChip(
                        label: Text('修改溫度'),
                        selected: state is InputLoaded,
                        onSelected: (selected) {
                          if (selected) {
                            context.read<InputCubit>().setTemperature();
                          }
                          _logger.d("onSelected 1 ${selected}");
                        }),
                    SizedBox(width: 10),
                    ChoiceChip(
                        label: Text('修改時間'),
                        selected: state is InputTimeSetting,
                        onSelected: (selected) {
                          if (selected) {
                            context.read<InputCubit>().setTime();
                          }
                          _logger.d("onSelected 3 ${selected}");
                        }),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).errorColor),
                              shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero)),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero)),
                          onPressed: () async {
                            await context.read<InputCubit>().deleteRecord();
                            context.router.pop<bool>(true);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text('Delete'),
                          )),
                    ),
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor),
                              shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero)),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              // remove the button build-in padding bottom
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero)),
                          onPressed: () async {
                            await context.read<InputCubit>().saveRecord();
                            context.router.pop<bool>(true);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text('Save'),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
