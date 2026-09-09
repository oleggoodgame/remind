part of 'day_bloc.dart';

abstract class DayEvent {}

class GetDay extends DayEvent {}

class PlusDay extends DayEvent {}

class MinusDay extends DayEvent {}

class SelectDayOne extends DayEvent {
  final DateTime day;
  SelectDayOne({required this.day});
}