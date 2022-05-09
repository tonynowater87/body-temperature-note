import 'package:bloc/bloc.dart';
import 'package:body_temperature_note/data/model/hive_record.dart';
import 'package:body_temperature_note/data/repository/record_repository.dart';
import 'package:body_temperature_note/main.dart';
import 'package:body_temperature_note/utils/string_extensions.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

part 'input_state.dart';

class InputCubit extends Cubit<InputState> {
  final RecordRepository repository;
  final _logger = getIt<Logger>();
  late HiveRecord currentRecord;

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
      currentRecord = HiveRecord()
        ..temperature = 36.0
        ..dateTime = dateTime;
    }
    emit(InputLoaded(currentRecord));
  }

  // TODO 個別更新int, double, double
  void temperatureUpdated(double temperature) {
    currentRecord.temperature = temperature;
    emit(InputLoaded(currentRecord));
  }

  void saveRecord() {
    final addedId = repository.addOrUpdateRecord(currentRecord);
    _logger.d("addedId = $addedId");
  }
}
