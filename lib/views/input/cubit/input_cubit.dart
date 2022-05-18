import 'package:bloc/bloc.dart';
import 'package:body_temperature_note/data/model/hive_record.dart';
import 'package:body_temperature_note/data/model/record_ui_model.dart';
import 'package:body_temperature_note/data/provider/settings_provider.dart';
import 'package:body_temperature_note/data/repository/record_repository.dart';
import 'package:body_temperature_note/main.dart';
import 'package:body_temperature_note/utils/double_extensions.dart';
import 'package:body_temperature_note/utils/string_extensions.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

part 'input_state.dart';

class InputCubit extends Cubit<InputState> {
  static const double defaultTemperature = 36.0;

  final RecordRepository repository;
  final SettingsProvider settingsProvider;
  late RecordModel currentRecord;
  bool isCelsius = false;

  InputCubit({required this.repository, required this.settingsProvider})
      : super(InputInitial());

  void initState(String dateString) {
    final dateTime = DateTime.parse(dateString);
    isCelsius = settingsProvider.getIsCelsius();
    emit(InputLoading());
    final record = repository.queryRecordByDate(dateTime);

    if (record != null) {
      if (isCelsius) {
        currentRecord = record;
      } else {
        currentRecord = record..temperature = record.temperature.toFahrenheit();
      }
    } else {
      if (isCelsius) {
        currentRecord =
            RecordModel(temperature: defaultTemperature, dateTime: dateTime);
      } else {
        currentRecord = RecordModel(
            temperature: defaultTemperature.toFahrenheit(), dateTime: dateTime);
      }
    }
    emit(InputLoaded(currentRecord, isCelsius));
  }

  void updateTensDigit(int tensDigit) {
    final temperatureString = "%.2f".format([currentRecord.temperature]);
    var updateToMaximum = tensDigit == 45.0 || tensDigit == 113.0;

    if (temperatureString.split('.')[0].length >= 3) {
      currentRecord.temperature = double.parse(
          "%d.%s".format([tensDigit, updateToMaximum ? "00" : temperatureString.substring(4, 6)]));
    } else {
      currentRecord.temperature = double.parse(
          "%d.%s".format([tensDigit, updateToMaximum ? "00" : temperatureString.substring(3, 5)]));
    }

    emit(InputLoaded(currentRecord, isCelsius));
  }

  void updateFloatOneDigit(int floatOneDigit) {
    final temperatureString = "%.2f".format([currentRecord.temperature]);
    if (temperatureString.split('.')[0].length >= 3) {
      currentRecord.temperature = double.parse("%s.%d%s".format([
        temperatureString.substring(0, 3),
        floatOneDigit,
        temperatureString.substring(5, 6)
      ]));
    } else {
      currentRecord.temperature = double.parse("%s.%d%s".format([
        temperatureString.substring(0, 2),
        floatOneDigit,
        temperatureString.substring(4, 5)
      ]));
    }
    emit(InputLoaded(currentRecord, isCelsius));
  }

  void updateFloatTwoDigit(int floatTwoDigit) {
    final temperatureString = "%.2f".format([currentRecord.temperature]);
    if (temperatureString.split('.')[0].length >= 3) {
      currentRecord.temperature = double.parse("%s.%s%d".format([
        temperatureString.substring(0, 3),
        temperatureString.substring(4, 5),
        floatTwoDigit,
      ]));
    } else {
      currentRecord.temperature = double.parse("%s.%s%d".format([
        temperatureString.substring(0, 2),
        temperatureString.substring(3, 4),
        floatTwoDigit,
      ]));
    }
    emit(InputLoaded(currentRecord, isCelsius));
  }

  void saveRecord() async {
    if (isCelsius) {
      await repository.addOrUpdateRecord(currentRecord);
    } else {
      await repository.addOrUpdateRecord(currentRecord..temperature = currentRecord.temperature.toCelsius());
    }
  }

  void deleteRecord() async {
    await repository.deleteRecord(currentRecord);
  }
}
