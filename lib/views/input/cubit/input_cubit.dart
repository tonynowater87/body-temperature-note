import 'package:bloc/bloc.dart';
import 'package:body_temperature_note/data/model/memo_ui_model.dart';
import 'package:body_temperature_note/data/model/record_ui_model.dart';
import 'package:body_temperature_note/data/provider/setting_provider.dart';
import 'package:body_temperature_note/data/repository/repository.dart';
import 'package:body_temperature_note/main.dart';
import 'package:body_temperature_note/utils/double_extensions.dart';
import 'package:body_temperature_note/utils/string_extensions.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

part 'input_state.dart';

class InputCubit extends Cubit<InputState> {
  static const double defaultTemperature = 36.0;

  final Repository repository;
  final SettingsProvider settingsProvider;
  late RecordModel modifiedRecord;
  late MemoModel modifiedMemoModel;
  late DateTime modifiedDateTime;
  bool isCelsius = false;

  InputCubit({required this.repository, required this.settingsProvider})
      : super(InputInitial());

  void initState(String dateString) {
    modifiedDateTime = DateTime.parse(dateString);
    isCelsius = settingsProvider.getIsCelsius();
    emit(InputLoading());

    final memo = repository.queryMemo(DateTime(
        modifiedDateTime.year, modifiedDateTime.month, modifiedDateTime.day));
    if (memo != null) {
      modifiedMemoModel = memo;
    } else {
      modifiedMemoModel = MemoModel(memo: "", dateTime: modifiedDateTime);
    }

    final record = repository.queryRecordByDate(modifiedDateTime);
    if (record != null) {
      if (isCelsius) {
        modifiedRecord = record;
      } else {
        modifiedRecord = record
          ..temperature = record.temperature.toFahrenheit();
      }
    } else {
      if (isCelsius) {
        modifiedRecord = RecordModel(
            temperature: defaultTemperature, dateTime: modifiedDateTime);
      } else {
        modifiedRecord = RecordModel(
            temperature: defaultTemperature.toFahrenheit(),
            dateTime: modifiedDateTime);
      }
    }
    emit(InputLoaded(modifiedRecord, isCelsius));
  }

  void setTemperature() {
    initState(modifiedDateTime.toIso8601String());
  }

  void setMemo() {
    emit(InputMemoLoaded(modifiedMemoModel));
  }

  void setDateTime() {
    emit(InputDateTimeSetting(modifiedDateTime));
  }

  void updateTensDigit(int tensDigit) {
    final temperatureString = "%.2f".format([modifiedRecord.temperature]);
    var updateToMaximum = tensDigit == 45.0 || tensDigit == 113.0;

    if (temperatureString.split('.')[0].length >= 3) {
      modifiedRecord.temperature = double.parse("%d.%s".format([
        tensDigit,
        updateToMaximum ? "00" : temperatureString.substring(4, 6)
      ]));
    } else {
      modifiedRecord.temperature = double.parse("%d.%s".format([
        tensDigit,
        updateToMaximum ? "00" : temperatureString.substring(3, 5)
      ]));
    }

    emit(InputLoaded(modifiedRecord, isCelsius));
  }

  void updateFloatOneDigit(int floatOneDigit) {
    final temperatureString = "%.2f".format([modifiedRecord.temperature]);
    if (temperatureString.split('.')[0].length >= 3) {
      modifiedRecord.temperature = double.parse("%s.%d%s".format([
        temperatureString.substring(0, 3),
        floatOneDigit,
        temperatureString.substring(5, 6)
      ]));
    } else {
      modifiedRecord.temperature = double.parse("%s.%d%s".format([
        temperatureString.substring(0, 2),
        floatOneDigit,
        temperatureString.substring(4, 5)
      ]));
    }
    emit(InputLoaded(modifiedRecord, isCelsius));
  }

  void updateFloatTwoDigit(int floatTwoDigit) {
    final temperatureString = "%.2f".format([modifiedRecord.temperature]);
    if (temperatureString.split('.')[0].length >= 3) {
      modifiedRecord.temperature = double.parse("%s.%s%d".format([
        temperatureString.substring(0, 3),
        temperatureString.substring(4, 5),
        floatTwoDigit,
      ]));
    } else {
      modifiedRecord.temperature = double.parse("%s.%s%d".format([
        temperatureString.substring(0, 2),
        temperatureString.substring(3, 4),
        floatTwoDigit,
      ]));
    }
    emit(InputLoaded(modifiedRecord, isCelsius));
  }

  void updateMemo(String memo) {
    modifiedMemoModel.memo = memo;
  }

  saveRecord() async {
    if (isCelsius) {
      await repository.addOrUpdateRecord(modifiedRecord);
    } else {
      await repository.addOrUpdateRecord(
          modifiedRecord..temperature = modifiedRecord.temperature.toCelsius());
    }

    await repository.addOrUpdateMemo(modifiedMemoModel);
  }

  deleteRecord() async {
    await repository.deleteRecord(modifiedRecord);
    await repository.deleteMemo(modifiedMemoModel.dateTime);
  }
}
