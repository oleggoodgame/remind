// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'schedule_bloc.dart';

abstract class ScheduleEvent {}

// class StartToSchedule
class AddToSchedule extends ScheduleEvent {
  final int index;
  final String description;
  final String? time;
  final String day;
  AddToSchedule({
    required this.index,
    required this.description,
    this.time,
    required this.day,
  });
}

class NewSchedule extends ScheduleEvent {
  NewSchedule();
}

class DeleteShedule extends ScheduleEvent {
  final String day;
  final int index;
  DeleteShedule({required this.day, required this.index});
}

class CanceledSchedule extends ScheduleEvent {
  final String reason;
  final String day;
  final int index;
  CanceledSchedule({
    required this.reason,
    required this.day,
    required this.index,
  });
}

class LoadSchedule extends ScheduleEvent {}
