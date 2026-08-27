part of 'schedule_bloc.dart';

abstract class ScheduleState {}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<ScheduleEntity> schedules;
  ScheduleLoaded({required this.schedules});
}

class ScheduleError extends ScheduleState {
  final String message;
  ScheduleError({required this.message});
}
