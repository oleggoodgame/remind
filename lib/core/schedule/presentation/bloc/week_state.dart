part of 'week_bloc.dart';

abstract class WeekState {}

class WeekInitial extends WeekState {}

class WeekLoading extends WeekState {}

class WeekError extends WeekState {}

class WeekLoaded extends WeekState {
  final List<WeekEntity> weekList;
  final String month;
  final DateTime selectedDay;
  WeekLoaded({
    required this.weekList,
    required this.month,
    required this.selectedDay,
  });
}