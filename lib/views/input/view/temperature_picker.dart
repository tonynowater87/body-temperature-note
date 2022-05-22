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
    final TextStyle selectedFloatTextTheme =
        Theme.of(context).textTheme.headlineSmall!;
    final TextStyle unselectedFloatTextTheme =
        Theme.of(context).textTheme.bodyText2!;
    final inputCubit = context.read<InputCubit>();

    return BlocBuilder<InputCubit, InputState>(
      builder: (context, state) {
        final _state = state as InputLoaded;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("體溫", style: Theme.of(context).textTheme.headlineMedium),
            NumberPicker(
              value: _state.decimalDigit,
              minValue: _state.isCelsius ? 35 : 35.0.toFahrenheit().toInt(),
              maxValue: _state.isCelsius ? 45 : 45.0.toFahrenheit().toInt(),
              infiniteLoop: true,
              textStyle: unselectedFloatTextTheme,
              selectedTextStyle: selectedFloatTextTheme,
              itemWidth: _state.isCelsius ? 55 : 65,
              onChanged: (value) {
                inputCubit.updateTensDigit(value);
              },
            ),
            Text(".", style: Theme.of(context).textTheme.headlineMedium),
            NumberPicker(
              value: _state.decimalDigit == 45 ||
                      _state.decimalDigit == 45.0.toFahrenheit().toInt()
                  ? 0
                  : _state.floatOneDigit,
              minValue: 0,
              maxValue: _state.decimalDigit == 45 ||
                      _state.decimalDigit == 45.0.toFahrenheit().toInt()
                  ? 0
                  : 9,
              itemWidth: 30,
              infiniteLoop: true,
              textStyle: unselectedFloatTextTheme,
              selectedTextStyle: selectedFloatTextTheme,
              onChanged: (value) {
                inputCubit.updateFloatOneDigit(value);
              },
            ),
            NumberPicker(
              value: _state.decimalDigit == 45 ||
                      _state.decimalDigit == 45.0.toFahrenheit().toInt()
                  ? 0
                  : _state.floatTwoDigit,
              minValue: 0,
              maxValue: _state.decimalDigit == 45 ||
                      _state.decimalDigit == 45.0.toFahrenheit().toInt()
                  ? 0
                  : 9,
              itemWidth: 30,
              infiniteLoop: true,
              textStyle: unselectedFloatTextTheme,
              selectedTextStyle: selectedFloatTextTheme,
              onChanged: (value) {
                inputCubit.updateFloatTwoDigit(value);
              },
            ),
            Text(
              _state.isCelsius ? "°C" : "°F",
              style: Theme.of(context).textTheme.headlineMedium,
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
