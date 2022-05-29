import 'package:bloc/bloc.dart';
import 'package:body_temperature_note/constants.dart';
import 'package:body_temperature_note/data/model/memo_ui_model.dart';
import 'package:body_temperature_note/data/repository/repository.dart';
import 'package:body_temperature_note/main.dart';
import 'package:body_temperature_note/views/memo/cubit/memo_state.dart';
import 'package:date_format/date_format.dart';
import 'package:logger/logger.dart';

class MemoCubit extends Cubit<MemoState> {
  Repository recordRepository;
  String? updateMemo;
  final _logger = getIt<Logger>();

  MemoCubit({required this.recordRepository}) : super(MemoInitialState());

  void load(String dateStringIso8601) async {
    var dateTime = DateTime.parse(dateStringIso8601);
    final formattedDateString = formatDate(dateTime, titleDayFormatyyyymmddDD);
    MemoModel? memoModel = recordRepository.queryMemo(dateTime);
    if (memoModel == null) {
      emit(MemoLoadedState(
          MemoModel(memo: "", dateTime: dateTime), formattedDateString));
    } else {
      emit(MemoLoadedState(memoModel, formattedDateString));
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
