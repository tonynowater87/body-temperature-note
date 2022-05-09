import 'package:body_temperature_note/main.dart';
import 'package:body_temperature_note/views/input/cubit/input_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:numberpicker/numberpicker.dart';

class TemperaturePicker extends StatefulWidget {
  const TemperaturePicker({Key? key}) : super(key: key);

  @override
  _TemperaturePickerState createState() => _TemperaturePickerState();
}

class _TemperaturePickerState extends State<TemperaturePicker> {

  final _logger = getIt<Logger>();

  @override
  Widget build(BuildContext context) {
    final TextTheme selectedFloatTextTheme = Theme.of(context).textTheme;
    final inputCubit = context.read<InputCubit>();
    return BlocBuilder<InputCubit, InputState>(
      builder: (context, state) {
        final _state = state as InputLoaded;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "體溫",
              style: TextStyle(fontSize: 18),
            ),
            NumberPicker(
              value: _state.decimalDigit,
              minValue: 35,
              maxValue: 42,
              infiniteLoop: true,
              itemWidth: 55,
              onChanged: (value) {
                _logger.d("onChanged $value");
                inputCubit.updateTensDigit(value);
              },
            ),
            const Text(
              ".",
              style: TextStyle(fontSize: 18),
            ),
            NumberPicker(
              value: _state.floatOneDigit,
              minValue: 0,
              maxValue: 9,
              itemWidth: 30,
              infiniteLoop: true,
              selectedTextStyle: selectedFloatTextTheme.headline6!
                  .apply(color: Theme.of(context).accentColor),
              onChanged: (value) {
                _logger.d("onChanged $value");
                inputCubit.updateFloatOneDigit(value);
              },
            ),
            NumberPicker(
              value: _state.floatTwoDigit,
              minValue: 0,
              maxValue: 9,
              itemWidth: 30,
              infiniteLoop: true,
              selectedTextStyle: selectedFloatTextTheme.headline6!
                  .apply(color: Theme.of(context).accentColor),
              onChanged: (value) {
                _logger.d("onChanged $value");
                inputCubit.updateFloatTwoDigit(value);
              },
            ),
            const Text(
              "°C",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        );
      },
    );
  }
}
