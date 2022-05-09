import 'package:auto_route/auto_route.dart';
import 'package:body_temperature_note/main.dart';
import 'package:body_temperature_note/views/input/cubit/input_cubit.dart';
import 'package:body_temperature_note/views/input/view/temperature_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class InputPage extends StatefulWidget {
  //yyyy-mm-dd hh:nn:ss
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
        title: const Text('記錄目前的體溫'),
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
  final _logger = getIt<Logger>();

  final String _dateString;

  InputContainer(this._dateString, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InputCubit, InputState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              color: Colors.green,
              width: double.infinity,
              padding: const EdgeInsets.all(4.0),
              child: Wrap(children: [Text(_dateString)]),
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
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero)),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          // remove the button build-in padding bottom
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      onPressed: () {},
                      child: const Text('Save')),
                ),
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red.shade400),
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero)),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      onPressed: () {},
                      child: const Text('Delete')),
                )
              ],
            )
          ],
        );
      },
    );
  }
}
