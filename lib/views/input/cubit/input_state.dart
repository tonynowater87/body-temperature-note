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
  final List<HiveRecord> record;

  const InputLoaded(this.record);

  @override
  List<Object?> get props => [record];
}

class InputSaved extends InputState {
  final double temperature;

  const InputSaved(this.temperature);

  @override
  List<Object?> get props => [temperature];
}
