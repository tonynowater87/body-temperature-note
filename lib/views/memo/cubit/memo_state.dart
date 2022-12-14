import 'package:body_temperature_note/data/model/memo_ui_model.dart';
import 'package:equatable/equatable.dart';

abstract class MemoState extends Equatable {
  const MemoState();
}

class MemoInitialState extends MemoState {
  @override
  List<Object> get props => [];
}

class MemoLoadedState extends MemoState {
  late MemoModel memo;
  late String formattedDateString;

  MemoLoadedState(this.memo, this.formattedDateString);

  @override
  List<Object> get props => [memo, formattedDateString];

  @override
  String toString() {
    return "$formattedDateString ${memo.memo}";
  }
}
