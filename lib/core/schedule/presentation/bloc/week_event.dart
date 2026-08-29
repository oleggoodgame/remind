part of 'week_bloc.dart';

abstract class WeekEvent {}

class GetWeeks extends WeekEvent {}

class PlusWeek extends WeekEvent {}

class MinusWeek extends WeekEvent {}

class SelectDay extends WeekEvent {
  final DateTime day;
  SelectDay({required this.day});
}