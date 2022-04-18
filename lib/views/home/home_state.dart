part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeDateState extends HomeState {
  final int currentDaysOfMonth;
  final int currentYear;
  final int currentMonth;
  final int? currentDay;

  const HomeDateState(
      {required this.currentYear,
      required this.currentMonth,
      required this.currentDay,
      required this.currentDaysOfMonth});

  @override
  List<Object> get props => [currentYear, currentMonth, currentDay ?? -1];

  @override
  String toString() {
    return "$currentYear/$currentMonth($currentDaysOfMonth)/${currentDay ?? ''}";
  }
}
