import 'package:auto_route/auto_route.dart';
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
  void initState() {
    super.initState();
    _inputCubit = context.read<InputCubit>();
    _inputCubit.initState(widget.dateString);
  }

  @override
  Widget build(BuildContext context) {
    logger.d('[Tony] InputPage arg: ${widget.dateString}');
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        title:
            Text('記錄目前的體溫', style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: BlocBuilder<InputCubit, InputState>(
        builder: (context, state) {
          if (state is InputInitial) {
            return const CircularProgressIndicator();
          } else if (state is InputLoading) {
            return const CircularProgressIndicator();
          } else if (state is InputLoaded) {
            return InputContainer(widget.dateString);
          } else {
            throw Error();
          }
        },
      ),
    );
  }
}

class InputContainer extends StatelessWidget {
  final String _dateString;

  const InputContainer(this._dateString, {Key? key}) : super(key: key);

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
                            ["yyyy", "/", "mm", "/", "dd", "(", "DD", ")"]),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        formatDate(
                            DateTime.parse(_dateString), ["hh", ":", "nn"]),
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ]),
              ),
              const Expanded(
                child: Center(
                  child: TemperaturePicker(),
                ),
              ),
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
