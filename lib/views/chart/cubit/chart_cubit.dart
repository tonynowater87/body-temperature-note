import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chart_state.dart';

class ChartCubit extends Cubit<ChartState> {
  ChartCubit() : super(ChartInitial());
}
