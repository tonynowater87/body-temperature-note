import 'package:bloc/bloc.dart';
import 'package:body_temperature_note/data/model/memo_ui_model.dart';
import 'package:body_temperature_note/data/repository/record_repository.dart';
import 'package:body_temperature_note/main.dart';
import 'package:body_temperature_note/views/memo/cubit/memo_state.dart';
import 'package:logger/logger.dart';

class MemoCubit extends Cubit<MemoState> {
  RecordRepository recordRepository;
  String? updateMemo;
  final _logger = getIt<Logger>();

  MemoCubit({required this.recordRepository}) : super(MemoInitialState());

  void load(String dateStringIso8601) async {
    var dateTime = DateTime.parse(dateStringIso8601);
    MemoModel? memoModel = recordRepository.queryMemo(dateTime);
    if (memoModel == null) {
      emit(MemoLoadedState(MemoModel(memo: "", dateTime: dateTime)));
    } else {
      emit(MemoLoadedState(memoModel));
    }
  }

  void updateText(String memo) {
    updateMemo = memo;
  }

  Future<void> save() async {
    if (updateMemo == null) {
      emit(MemoInitialState());
    } else {
      try {
        MemoLoadedState memoLoadedState = state as MemoLoadedState;
        await recordRepository
            .addOrUpdateMemo(memoLoadedState.memo..memo = updateMemo!);
        emit(MemoInitialState());
      } on Exception {
        emit(MemoInitialState());
      }
    }
  }
}
