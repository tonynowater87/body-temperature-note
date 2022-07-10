import 'package:auto_route/auto_route.dart';
import 'package:body_temperature_note/constants.dart';
import 'package:body_temperature_note/data/provider/setting_provider.dart';
import 'package:body_temperature_note/data/repository/repository.dart';
import 'package:body_temperature_note/main.dart';
import 'package:body_temperature_note/views/input/cubit/input_cubit.dart';
import 'package:body_temperature_note/views/input/view/temperature_picker.dart';
import 'package:date_format/date_format.dart';
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
  late InputCubit _inputCubit;

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

class InputContainer extends StatelessWidget {
  final String _dateString;
  final _logger = getIt<Logger>();

  InputContainer(this._dateString, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InputCubit, InputState>(
      builder: (context, state) {
        return Container(
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(4.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatDate(DateTime.parse(_dateString),
                            titleDayFormatyyyymmddDD),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        formatDate(
                            DateTime.parse(_dateString), titleTimeFormathhnn),
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ]),
              ),
              Expanded(
                child: Builder(builder: (context) {
                  if (state is InputLoaded) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [TemperaturePicker()],
                    );
                  } else if (state is InputMemoLoaded) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Text("MEMO")],
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Text("DATETIME")],
                    );
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
                      label: Text('修改註記'),
                      selected: state is InputMemoLoaded,
                      onSelected: (selected) {
                        if (selected) {
                          context.read<InputCubit>().setMemo();
                        }
                        _logger.d("onSelected 2 ${selected}");
                      }),
                  SizedBox(width: 10),
                  ChoiceChip(
                      label: Text('修改日期'),
                      selected: state is InputDateTimeSetting,
                      onSelected: (selected) {
                        if (selected) {
                          context.read<InputCubit>().setDateTime();
                        }
                        _logger.d("onSelected 3 ${selected}");
                      }),
                ],
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
                        onPressed: () {
                          context.read<InputCubit>().saveRecord();
                          context.router.pop<bool>(true);
                        },
                        child: const Text('Save')),
                  ),
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
                        onPressed: () {
                          context.read<InputCubit>().deleteRecord();
                          context.router.pop<bool>(true);
                        },
                        child: const Text('Delete')),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
