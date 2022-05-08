import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:body_temperature_note/data/model/hive_record.dart';
import 'package:body_temperature_note/data/repository/record_repository.dart';
import 'package:body_temperature_note/main.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

part 'input_state.dart';

class InputCubit extends Cubit<InputState> {
  final RecordRepository repository;
  final _logger = getIt<Logger>();

  late DateTime dateTime;

  InputCubit({required this.repository}) : super(InputInitial()) {
    _logger.d("repo in input = ${repository.hashCode}");
  }

  void initState(String dateString) {
    dateTime = DateTime.parse(dateString);

    emit(InputLoading());
    final records = repository.queryDayRecords(dateTime);
    _logger.d("$dateTime, records = $records");
    emit(InputLoaded(records));
  }

  void saveRecord() {
    final addedId = repository.addOrUpdateRecord(HiveRecord()
      ..dateTime = dateTime
      ..temperature = Random().nextDouble() * 100.0);
    _logger.d("addedId = $addedId");
  }
}
