import 'package:body_temperature_note/data/model/memo_ui_model.dart';
import 'package:body_temperature_note/data/model/record_ui_model.dart';

class DateListModel {
  late List<List<RecordModel>> outputRecords;
  late List<MemoModel?> outputMemos;

  DateListModel({required this.outputRecords, required this.outputMemos});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateListModel &&
          runtimeType == other.runtimeType &&
          outputRecords == other.outputRecords &&
          outputMemos == other.outputMemos;

  @override
  int get hashCode => outputRecords.hashCode ^ outputMemos.hashCode;
}
