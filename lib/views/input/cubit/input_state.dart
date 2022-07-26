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

class InputDateTimeSetting extends InputState {
  final DateTime dateTime;

  InputDateTimeSetting(this.dateTime);

  @override
  List<Object?> get props => [dateTime];
}

class InputLoaded extends InputState {
  final RecordModel record;
  final bool isCelsius;
  late final int decimalDigit;
  late final int floatOneDigit;
  late final int floatTwoDigit;

  InputLoaded(this.record, this.isCelsius) {
    String temperatureString = '%.2f'.format([record.temperature]);
    final _logger = getIt<Logger>();
    if (temperatureString.split('.')[0].length >= 3) {
      decimalDigit = int.parse(temperatureString.substring(0, 3));
      floatOneDigit = int.parse(temperatureString.substring(4, 5));
      floatTwoDigit = int.parse(temperatureString.substring(5, 6));
    } else {
      decimalDigit = int.parse(temperatureString.substring(0, 2));
      floatOneDigit = int.parse(temperatureString.substring(3, 4));
      floatTwoDigit = int.parse(temperatureString.substring(4, 5));
    }
  }

  @override
  List<Object?> get props =>
      [record, decimalDigit, floatOneDigit, floatTwoDigit];
}
