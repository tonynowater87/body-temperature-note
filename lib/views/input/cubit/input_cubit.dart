import 'package:bloc/bloc.dart';
import 'package:body_temperature_note/data/model/hive_record.dart';
import 'package:body_temperature_note/data/model/record_ui_model.dart';
import 'package:body_temperature_note/data/repository/record_repository.dart';
import 'package:body_temperature_note/main.dart';
import 'package:body_temperature_note/utils/string_extensions.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

part 'input_state.dart';

class InputCubit extends Cubit<InputState> {
  final RecordRepository repository;
  final _logger = getIt<Logger>();
  late RecordModel currentRecord;

  InputCubit({required this.repository}) : super(InputInitial()) {
    _logger.d("repo in input = ${repository.hashCode}");
  }

  void initState(String dateString) {
    final dateTime = DateTime.parse(dateString);

    emit(InputLoading());
    final record = repository.queryRecordByDate(dateTime);

    if (record != null) {
      currentRecord = record;
    } else {
      currentRecord = RecordModel(temperature: 36.0, dateTime: dateTime);
    }
    emit(InputLoaded(currentRecord));
  }

  void updateTensDigit(int tensDigit) {
    _logger.d("updateTensDigit $tensDigit");
    final temperatureString = "%.2f".format([currentRecord.temperature]);
    currentRecord.temperature = double.parse(
        "%d.%s".format([tensDigit, temperatureString.substring(3, 5)]));
    emit(InputLoaded(currentRecord));
  }

  void updateFloatOneDigit(int floatOneDigit) {
    final temperatureString = "%.2f".format([currentRecord.temperature]);
    currentRecord.temperature = double.parse("%s.%d%s".format([
      temperatureString.substring(0, 2),
      floatOneDigit,
      temperatureString.substring(4, 5)
    ]));
    emit(InputLoaded(currentRecord));
  }

  void updateFloatTwoDigit(int floatTwoDigit) {
    final temperatureString = "%.2f".format([currentRecord.temperature]);
    currentRecord.temperature = double.parse("%s.%s%d".format([
      temperatureString.substring(0, 2),
      temperatureString.substring(3, 4),
      floatTwoDigit,
    ]));
    emit(InputLoaded(currentRecord));
  }

  void saveRecord() async {
    await repository.addOrUpdateRecord(currentRecord);
  }

  void deleteRecord() async {
    await repository.deleteRecord(currentRecord);
  }
}
