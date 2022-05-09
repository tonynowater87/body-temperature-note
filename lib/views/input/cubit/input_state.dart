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
  final HiveRecord record;
  late final int decimalDigit;
  late final int floatOneDigit;
  late final int floatTwoDigit;

  InputLoaded(this.record) {
    String temperatureString = '%.2f'.format([record.temperature.toString()]);
    decimalDigit = temperatureString.substring(0, 2) as int;
    floatOneDigit = temperatureString.substring(3, 4) as int;
    floatTwoDigit = temperatureString.substring(4, 5) as int;
  }

  @override
  List<Object?> get props => [record];
}

class InputSaved extends InputState {
  final HiveRecord record;

  const InputSaved(this.record);

  @override
  List<Object?> get props => [record];
}
