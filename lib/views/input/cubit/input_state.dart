part of 'input_cubit.dart';

abstract class InputState extends Equatable {
  const InputState();
}

class InputInitial extends InputState {
  @override
  List<Object> get props => [];
}

class InputLoading extends InputState {
  @override
  List<Object?> get props => [];
}

class InputLoaded extends InputState {
  final RecordModel record;
  late final int decimalDigit;
  late final int floatOneDigit;
  late final int floatTwoDigit;

  InputLoaded(this.record) {
    String temperatureString = '%.2f'.format([record.temperature]);
    decimalDigit = int.parse(temperatureString.substring(0, 2));
    floatOneDigit = int.parse(temperatureString.substring(3, 4));
    floatTwoDigit = int.parse(temperatureString.substring(4, 5));
  }

  @override
  List<Object?> get props => [record, decimalDigit, floatOneDigit, floatTwoDigit];
}

class InputSaved extends InputState {
  final HiveRecord record;

  const InputSaved(this.record);

  @override
  List<Object?> get props => [record];
}
