import 'package:bloc_test/bloc_test.dart';
import 'package:body_temperature_note/data/model/record_ui_model.dart';
import 'package:body_temperature_note/views/chart/cubit/chart_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake/fake_settings_provider.dart';
import 'fake/fake_week_repository.dart';

class MockCounterCubit extends MockCubit<ChartPageState> implements ChartCubit {
}

void main() {
  group('chart bloc week test', () {
    late ChartCubit chartCubit;
    setUp(() {
      chartCubit = ChartCubit(
          FakeWeekRepository(
              dayRecords: [recordModel(36), recordModel(37), recordModel(38)],
              monthRecords: []),
          FakeSettingsProvider());
    });
    tearDown(() {
      print('[Tony] tearDown');
    });
    test('week', () {
      chartCubit.init(DateTime.now());

      final state = chartCubit.state;
      print('[Tony] state = $state');
    });
    test('month', () {
      print('[Tony] month');
    });
    test('season', () {
      print('[Tony] season');
    });
  });
}

RecordModel recordModel(double temp) =>
    RecordModel(temperature: temp, dateTime: DateTime.now());
