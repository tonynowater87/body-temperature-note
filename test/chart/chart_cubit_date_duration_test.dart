import 'package:body_temperature_note/data/model/memo_ui_model.dart';
import 'package:body_temperature_note/data/model/record_ui_model.dart';
import 'package:body_temperature_note/views/chart/cubit/chart_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fake/fake_settings_provider.dart';
import '../fake/fake_week_repository.dart';

void main() {
  group('test baseline', () {
    late ChartCubit chartCubit;

    test('is not display baseline', () {
      chartCubit = ChartCubit(
          FakeWeekRepository(dayRecords: [], memoModel: null),
          FakeSettingsProvider(
              isCelsius: true, isDisplayBaseline: false, baseline: 37.7));
      chartCubit.init(DateTime(2022, 5, 29));
      final state = chartCubit.state as ChartLoadedState;

      expect(state.baseline, null);
    });

    test('isBaselineCelsius', () {
      chartCubit = ChartCubit(
          FakeWeekRepository(dayRecords: [], memoModel: null),
          FakeSettingsProvider(
              isCelsius: true, isDisplayBaseline: true, baseline: 37.7));
      chartCubit.init(DateTime(2022, 5, 29));
      final state = chartCubit.state as ChartLoadedState;

      expect(state.baseline, 37.7);
    });

    test('isBaselineNotCelsius', () {
      chartCubit = ChartCubit(
          FakeWeekRepository(dayRecords: [], memoModel: null),
          FakeSettingsProvider(
              isCelsius: false, isDisplayBaseline: true, baseline: 37.7));
      chartCubit.init(DateTime(2022, 5, 29));
      final state = chartCubit.state as ChartLoadedState;

      expect(state.baseline, 99.86);
    });
  });

  group('chart bloc week test', () {
    late ChartCubit chartCubit;
    setUp(() {
      chartCubit = ChartCubit(
          FakeWeekRepository(
              dayRecords: [recordModel(36), recordModel(37), recordModel(38)],
              memoModel: null),
          FakeSettingsProvider(
              isCelsius: true, isDisplayBaseline: false, baseline: 0));
    });
    test('change to week', () {
      chartCubit.init(DateTime(2022, 5, 29));
      chartCubit.updateChartDuration(ChartDuration.week);
      final state = chartCubit.state as ChartLoadedState;
      expect(state.title, "2022/05/23 Monday - 2022/05/29 Sunday");
      expect(state.records.first.valueX, 23);
      expect(state.records.first.valueY, 37.0);
      expect(state.records.first.memo, "");
      expect(state.records.length, 7);
    });

    test('change to today', () {
      chartCubit.init(DateTime(2022, 5, 29));
      chartCubit.updateChartDuration(ChartDuration.week);
      chartCubit.changeToNext();

      var state = chartCubit.state as ChartLoadedState;
      expect(state.title, "2022/05/30 Monday - 2022/06/05 Sunday");

      chartCubit.changeToToday();
      state = chartCubit.state as ChartLoadedState;
      expect(state.title, "2022/05/23 Monday - 2022/05/29 Sunday");

      chartCubit.changeToPrevious();
      state = chartCubit.state as ChartLoadedState;
      expect(state.title, "2022/05/16 Monday - 2022/05/22 Sunday");

      chartCubit.changeToToday();
      state = chartCubit.state as ChartLoadedState;
      expect(state.title, "2022/05/23 Monday - 2022/05/29 Sunday");
    });

    test('next week', () {
      chartCubit.init(DateTime(2022, 5, 29));
      chartCubit.updateChartDuration(ChartDuration.week);
      chartCubit.changeToNext();
      final state = chartCubit.state as ChartLoadedState;

      expect(chartCubit.selectedDateTime.year, 2022);
      expect(chartCubit.selectedDateTime.month, 6);
      expect(chartCubit.selectedDateTime.day, 5);
      expect(state.title, "2022/05/30 Monday - 2022/06/05 Sunday");
      expect(state.records.first.valueX, 30);
      expect(state.records.first.valueY, 37.0);
      expect(state.records.first.memo, "");
      expect(state.records.length, 7);
    });

    test('next week and to next year', () {
      chartCubit.init(DateTime(2022, 12, 30));
      chartCubit.updateChartDuration(ChartDuration.week);
      chartCubit.changeToNext();
      final state = chartCubit.state as ChartLoadedState;

      expect(chartCubit.selectedDateTime.year, 2023);
      expect(chartCubit.selectedDateTime.month, 1);
      expect(chartCubit.selectedDateTime.day, 6);
      expect(state.title, "2023/01/02 Monday - 2023/01/08 Sunday");
      expect(state.records.first.valueX, 2);
      expect(state.records.first.valueY, 37.0);
      expect(state.records.first.memo, "");
      expect(state.records.length, 7);
    });

    test('previous week', () {
      chartCubit.init(DateTime(2022, 5, 29));
      chartCubit.updateChartDuration(ChartDuration.week);
      chartCubit.changeToPrevious();
      final state = chartCubit.state as ChartLoadedState;

      expect(chartCubit.selectedDateTime.year, 2022);
      expect(chartCubit.selectedDateTime.month, 5);
      expect(chartCubit.selectedDateTime.day, 22);
      expect(state.title, "2022/05/16 Monday - 2022/05/22 Sunday");
      expect(state.records.first.valueX, 16);
      expect(state.records.first.valueY, 37.0);
      expect(state.records.first.memo, "");
      expect(state.records.length, 7);
    });

    test('previous week and to last year', () {
      chartCubit.init(DateTime(2022, 1, 1));
      chartCubit.updateChartDuration(ChartDuration.week);
      chartCubit.changeToPrevious();
      final state = chartCubit.state as ChartLoadedState;

      expect(chartCubit.selectedDateTime.year, 2021);
      expect(chartCubit.selectedDateTime.month, 12);
      expect(chartCubit.selectedDateTime.day, 25);
      expect(state.title, "2021/12/20 Monday - 2021/12/26 Sunday");
      expect(state.records.first.valueX, 20);
      expect(state.records.first.valueY, 37.0);
      expect(state.records.first.memo, "");
      expect(state.records.length, 7);
    });
  });

  group('chart bloc month test', () {
    late ChartCubit chartCubit;
    setUp(() {
      chartCubit = ChartCubit(
          FakeWeekRepository(
              dayRecords: [recordModel(36), recordModel(37), recordModel(38)],
              memoModel: MemoModel(memo: "UnitTest", dateTime: DateTime.now())),
          FakeSettingsProvider(
              isCelsius: true, isDisplayBaseline: false, baseline: 0));
    });

    test('change to month', () {
      chartCubit.init(DateTime(2022, 5, 29));
      chartCubit.updateChartDuration(ChartDuration.month);
      final state = chartCubit.state as ChartLoadedState;

      expect(state.title, "2022/05");
      expect(state.records.first.valueX, 1);
      expect(state.records.last.valueX, 31);
      expect(state.records.first.valueY, 37.0);
      expect(state.records.first.memo, "UnitTest");
      expect(state.records.length, 31);
    });

    test('change to today', () {
      chartCubit.init(DateTime(2022, 5, 29));
      chartCubit.updateChartDuration(ChartDuration.month);
      chartCubit.changeToNext();

      var state = chartCubit.state as ChartLoadedState;
      expect(state.title, "2022/06");

      chartCubit.changeToToday();
      state = chartCubit.state as ChartLoadedState;
      expect(state.title, "2022/05/23 Monday - 2022/05/29 Sunday");

      chartCubit.updateChartDuration(ChartDuration.month);
      chartCubit.changeToPrevious();
      state = chartCubit.state as ChartLoadedState;
      expect(state.title, "2022/04");

      chartCubit.changeToToday();
      state = chartCubit.state as ChartLoadedState;
      expect(state.title, "2022/05/23 Monday - 2022/05/29 Sunday");
    });

    test('next month', () {
      chartCubit.init(DateTime(2022, 5, 29));
      chartCubit.updateChartDuration(ChartDuration.month);
      chartCubit.changeToNext();
      final state = chartCubit.state as ChartLoadedState;

      expect(chartCubit.selectedDateTime.year, 2022);
      expect(chartCubit.selectedDateTime.month, 6);
      expect(chartCubit.selectedDateTime.day, 1);
      expect(state.title, "2022/06");
      expect(state.records.first.valueX, 1);
      expect(state.records.last.valueX, 30);
      expect(state.records.first.valueY, 37.0);
      expect(state.records.first.memo, "UnitTest");
      expect(state.records.length, 30);
    });

    test('next month to february', () {
      chartCubit.init(DateTime(2022, 1, 31));
      chartCubit.updateChartDuration(ChartDuration.month);
      chartCubit.changeToNext();
      final state = chartCubit.state as ChartLoadedState;

      expect(chartCubit.selectedDateTime.year, 2022);
      expect(chartCubit.selectedDateTime.month, 2);
      expect(chartCubit.selectedDateTime.day, 1);
      expect(state.title, "2022/02");
      expect(state.records.first.valueX, 1);
      expect(state.records.last.valueX, 28);
      expect(state.records.first.valueY, 37.0);
      expect(state.records.first.memo, "UnitTest");
      expect(state.records.length, 28);
    });

    test('next month and to next year', () {
      chartCubit.init(DateTime(2022, 12, 29));
      chartCubit.updateChartDuration(ChartDuration.month);
      chartCubit.changeToNext();
      final state = chartCubit.state as ChartLoadedState;

      expect(chartCubit.selectedDateTime.year, 2023);
      expect(chartCubit.selectedDateTime.month, 1);
      expect(chartCubit.selectedDateTime.day, 1);
      expect(state.title, "2023/01");
      expect(state.records.first.valueX, 1);
      expect(state.records.last.valueX, 31);
      expect(state.records.first.valueY, 37.0);
      expect(state.records.first.memo, "UnitTest");
      expect(state.records.length, 31);
    });

    test('previous month', () {
      chartCubit.init(DateTime(2022, 5, 29));
      chartCubit.updateChartDuration(ChartDuration.month);
      chartCubit.changeToPrevious();
      final state = chartCubit.state as ChartLoadedState;

      expect(chartCubit.selectedDateTime.year, 2022);
      expect(chartCubit.selectedDateTime.month, 4);
      expect(chartCubit.selectedDateTime.day, 1);
      expect(state.title, "2022/04");
      expect(state.records.first.valueX, 1);
      expect(state.records.last.valueX, 30);
      expect(state.records.first.valueY, 37.0);
      expect(state.records.first.memo, "UnitTest");
      expect(state.records.length, 30);
    });

    test('previous month and to last year', () {
      chartCubit.init(DateTime(2022, 1, 29));
      chartCubit.updateChartDuration(ChartDuration.month);
      chartCubit.changeToPrevious();
      final state = chartCubit.state as ChartLoadedState;

      expect(chartCubit.selectedDateTime.year, 2021);
      expect(chartCubit.selectedDateTime.month, 12);
      expect(chartCubit.selectedDateTime.day, 1);
      expect(state.title, "2021/12");
      expect(state.records.first.valueX, 1);
      expect(state.records.last.valueX, 31);
      expect(state.records.first.valueY, 37.0);
      expect(state.records.first.memo, "UnitTest");
      expect(state.records.length, 31);
    });
  });

  group('chart bloc season test', () {
    late ChartCubit chartCubit;
    setUp(() {
      chartCubit = ChartCubit(
          FakeWeekRepository(
              dayRecords: [recordModel(36)],
              memoModel: MemoModel(memo: "UnitTest", dateTime: DateTime.now())),
          FakeSettingsProvider(
              isCelsius: true, isDisplayBaseline: false, baseline: 0));
    });
    test('change to season', () {
      chartCubit.init(DateTime(2022, 5, 29));
      chartCubit.updateChartDuration(ChartDuration.season);
      final state = chartCubit.state as ChartLoadedState;

      expect(state.title, "2022/04 - 2022/06");
      expect(state.records.first.valueX, 1);
      expect(state.records.last.valueX, 30);
      expect(state.records.first.valueY, 36.0);
      expect(state.records.first.memo, "UnitTest");
      expect(state.records.length, 91);
    });

    test('change to today', () {
      chartCubit.init(DateTime(2022, 5, 29));
      chartCubit.updateChartDuration(ChartDuration.season);
      chartCubit.changeToNext();

      var state = chartCubit.state as ChartLoadedState;
      expect(state.title, "2022/07 - 2022/09");

      chartCubit.changeToToday();
      state = chartCubit.state as ChartLoadedState;
      expect(state.title, "2022/05/23 Monday - 2022/05/29 Sunday");

      chartCubit.updateChartDuration(ChartDuration.season);
      chartCubit.changeToPrevious();
      state = chartCubit.state as ChartLoadedState;
      expect(state.title, "2022/01 - 2022/03");

      chartCubit.changeToToday();
      state = chartCubit.state as ChartLoadedState;
      expect(state.title, "2022/05/23 Monday - 2022/05/29 Sunday");
    });

    test('next season', () {
      chartCubit.init(DateTime(2022, 5, 29));
      chartCubit.updateChartDuration(ChartDuration.season);
      chartCubit.changeToNext();
      final state = chartCubit.state as ChartLoadedState;

      expect(chartCubit.selectedDateTime.year, 2022);
      expect(chartCubit.selectedDateTime.month, 8);
      expect(chartCubit.selectedDateTime.day, 1);
      expect(state.title, "2022/07 - 2022/09");
      expect(state.records.first.valueX, 1);
      expect(state.records.last.valueX, 30);
      expect(state.records.first.valueY, 36.0);
      expect(state.records.first.memo, "UnitTest");
      expect(state.records.length, 92);
    });

    test('next season and cross to next year case 1', () {
      chartCubit.init(DateTime(2022, 10, 29));
      chartCubit.updateChartDuration(ChartDuration.season);
      chartCubit.changeToNext();
      final state = chartCubit.state as ChartLoadedState;

      expect(chartCubit.selectedDateTime.year, 2023);
      expect(chartCubit.selectedDateTime.month, 1);
      expect(chartCubit.selectedDateTime.day, 1);
      expect(state.title, "2022/12 - 2023/02");
      expect(state.records.first.valueX, 1);
      expect(state.records.last.valueX, 28);
      expect(state.records.first.valueY, 36.0);
      expect(state.records.first.memo, "UnitTest");
      expect(state.records.length, 90);
    });

    test('next season and cross to next year case 2', () {
      chartCubit.init(DateTime(2022, 11, 29));
      chartCubit.updateChartDuration(ChartDuration.season);
      chartCubit.changeToNext();
      final state = chartCubit.state as ChartLoadedState;

      expect(chartCubit.selectedDateTime.year, 2023);
      expect(chartCubit.selectedDateTime.month, 2);
      expect(chartCubit.selectedDateTime.day, 1);
      expect(state.title, "2023/01 - 2023/03");
      expect(state.records.first.valueX, 1);
      expect(state.records.last.valueX, 31);
      expect(state.records.first.valueY, 36.0);
      expect(state.records.first.memo, "UnitTest");
      expect(state.records.length, 90);
    });

    test('next season and cross to next year case 3', () {
      chartCubit.init(DateTime(2022, 12, 29));
      chartCubit.updateChartDuration(ChartDuration.season);
      chartCubit.changeToNext();
      final state = chartCubit.state as ChartLoadedState;

      expect(chartCubit.selectedDateTime.year, 2023);
      expect(chartCubit.selectedDateTime.month, 3);
      expect(chartCubit.selectedDateTime.day, 1);
      expect(state.title, "2023/02 - 2023/04");
      expect(state.records.first.valueX, 1);
      expect(state.records.last.valueX, 30);
      expect(state.records.first.valueY, 36.0);
      expect(state.records.first.memo, "UnitTest");
      expect(state.records.length, 89);
    });

    test('previous season', () {
      chartCubit.init(DateTime(2022, 4, 29));
      chartCubit.updateChartDuration(ChartDuration.season);
      chartCubit.changeToPrevious();
      final state = chartCubit.state as ChartLoadedState;

      expect(chartCubit.selectedDateTime.year, 2022);
      expect(chartCubit.selectedDateTime.month, 1);
      expect(chartCubit.selectedDateTime.day, 1);
      expect(state.title, "2021/12 - 2022/02");
      expect(state.records.first.valueX, 1);
      expect(state.records.last.valueX, 28);
      expect(state.records.first.valueY, 36.0);
      expect(state.records.first.memo, "UnitTest");
      expect(state.records.length, 90);
    });

    test('previous season and to last year case 1', () {
      chartCubit.init(DateTime(2022, 3, 29));
      chartCubit.updateChartDuration(ChartDuration.season);
      chartCubit.changeToPrevious();
      final state = chartCubit.state as ChartLoadedState;

      expect(chartCubit.selectedDateTime.year, 2021);
      expect(chartCubit.selectedDateTime.month, 12);
      expect(chartCubit.selectedDateTime.day, 1);
      expect(state.title, "2021/11 - 2022/01");
      expect(state.records.first.valueX, 1);
      expect(state.records.last.valueX, 31);
      expect(state.records.first.valueY, 36.0);
      expect(state.records.first.memo, "UnitTest");
      expect(state.records.length, 92);
    });

    test('previous season and to last year case 2', () {
      chartCubit.init(DateTime(2022, 2, 28));
      chartCubit.updateChartDuration(ChartDuration.season);
      chartCubit.changeToPrevious();
      final state = chartCubit.state as ChartLoadedState;

      expect(chartCubit.selectedDateTime.year, 2021);
      expect(chartCubit.selectedDateTime.month, 11);
      expect(chartCubit.selectedDateTime.day, 1);
      expect(state.title, "2021/10 - 2021/12");
      expect(state.records.first.valueX, 1);
      expect(state.records.last.valueX, 31);
      expect(state.records.first.valueY, 36.0);
      expect(state.records.first.memo, "UnitTest");
      expect(state.records.length, 92);
    });

    test('previous season and to last year case 3', () {
      chartCubit.init(DateTime(2022, 1, 28));
      chartCubit.updateChartDuration(ChartDuration.season);
      chartCubit.changeToPrevious();
      final state = chartCubit.state as ChartLoadedState;

      expect(chartCubit.selectedDateTime.year, 2021);
      expect(chartCubit.selectedDateTime.month, 10);
      expect(chartCubit.selectedDateTime.day, 1);
      expect(state.title, "2021/09 - 2021/11");
      expect(state.records.first.valueX, 1);
      expect(state.records.last.valueX, 30);
      expect(state.records.first.valueY, 36.0);
      expect(state.records.first.memo, "UnitTest");
      expect(state.records.length, 91);
    });
  });
}

RecordModel recordModel(double temp) =>
    RecordModel(temperature: temp, dateTime: DateTime(2022, 5, 29));
