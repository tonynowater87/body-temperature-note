import 'package:body_temperature_note/main.dart';
import 'package:body_temperature_note/utils/double_extensions.dart';
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
              minValue: _state.isCelsius ? 35 : 35.0.toFahrenheit().toInt(),
              maxValue: _state.isCelsius ? 45 : 45.0.toFahrenheit().toInt(),
              infiniteLoop: true,
              itemWidth: _state.isCelsius ? 55 : 65,
              onChanged: (value) {
                inputCubit.updateTensDigit(value);
              },
            ),
            const Text(
              ".",
              style: TextStyle(fontSize: 18),
            ),
            NumberPicker(
              value: _state.decimalDigit == 45 || _state.decimalDigit == 45.0.toFahrenheit().toInt() ? 0 : _state.floatOneDigit,
              minValue: 0,
              maxValue: _state.decimalDigit == 45 || _state.decimalDigit == 45.0.toFahrenheit().toInt() ? 0 : 9,
              itemWidth: 30,
              infiniteLoop: true,
              selectedTextStyle: selectedFloatTextTheme.headline6!
                  .apply(color: Theme.of(context).accentColor),
              onChanged: (value) {
                inputCubit.updateFloatOneDigit(value);
              },
            ),
            NumberPicker(
              value: _state.decimalDigit == 45 || _state.decimalDigit == 45.0.toFahrenheit().toInt() ? 0 : _state.floatTwoDigit,
              minValue: 0,
              maxValue: _state.decimalDigit == 45 || _state.decimalDigit == 45.0.toFahrenheit().toInt() ? 0 : 9,
              itemWidth: 30,
              infiniteLoop: true,
              selectedTextStyle: selectedFloatTextTheme.headline6!
                  .apply(color: Theme.of(context).accentColor),
              onChanged: (value) {
                inputCubit.updateFloatTwoDigit(value);
              },
            ),
            Text(
              _state.isCelsius ? "°C" : "°F",
              style: const TextStyle(fontSize: 18),
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
