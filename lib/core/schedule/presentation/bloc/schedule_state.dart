part of 'schedule_bloc.dart';

abstract class ScheduleState {}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<ScheduleEntity> schedules;
  final int? editingIndex; 
  ScheduleLoaded({required this.schedules, this.editingIndex});
}

class ScheduleError extends ScheduleState {
  final String message;
  ScheduleError({required this.message});
}
