part of 'day_bloc.dart';

abstract class DayState {}

class DayInital extends DayState {}

class DayLoading extends DayState {}

class DayError extends DayState {}

class DayLoadded extends DayState {
  final String name;
  final String month;
  final DateTime selectedDay;
  final String information;
  DayLoadded({
    required this.name,
    required this.month,
    required this.selectedDay,
    required this.information,
  });
}