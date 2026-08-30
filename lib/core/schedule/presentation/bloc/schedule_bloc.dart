import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind/core/schedule/domain/entity/schedule_entity.dart';
import 'package:remind/core/schedule/domain/repository/schedule_repository.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleRepository scheduleRepository;
  ScheduleBloc({required this.scheduleRepository}) : super(ScheduleInitial()) {
    on<LoadSchedule>(_onLoadSchedule);
    on<AddToSchedule>(_onAddSchedule);
    on<DeleteShedule>(_onDeleteSchedule);
    on<CanceledSchedule>(_onCanceledSchedule);
    on<NewSchedule>(_onNewSchedule);
  }

  Future<void> _onLoadSchedule(
    LoadSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    try {
      final schedules = await scheduleRepository.load(event.day);
      print("Load Schedule");
      print(schedules);
      emit(ScheduleLoaded(schedules: schedules));
    } catch (e) {
      emit(ScheduleError(message: e.toString()));
    }
  }

  Future<void> _onAddSchedule(
    AddToSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      print("Починаємо додавати SCHEDULE");
      final ScheduleEntity scheduleEntity = ScheduleEntity(
        index: event.index,
        time: event.time,
        description: event.description,
      );
      await scheduleRepository.add(scheduleEntity, event.day);
      print("Added Schedule");
      final current = state;
      if (current is ScheduleLoaded) {
        final updated = current.schedules.map((s) {
          return s.index == event.index
              ? s.copyWith(description: event.description, time: event.time)
              : s;
        }).toList();
        emit(ScheduleLoaded(schedules: updated));
        print("Загрузив Schdule");
      }
    } catch (e) {
      emit(ScheduleError(message: e.toString()));
    }
  }

  Future<void> _onDeleteSchedule(
    DeleteShedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      await scheduleRepository.delete(event.day);
      final current = state;
      if (current is ScheduleLoaded) {
        current.schedules.removeWhere(
          (element) => element.index == event.index,
        );
        emit(ScheduleLoaded(schedules: [...current.schedules]));
      }
    } catch (e) {
      emit(ScheduleError(message: e.toString()));
    }
  }

  Future<void> _onNewSchedule(
    NewSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    final current = state;
    if (current is ScheduleLoaded) {
      final newIndex = current.schedules.length;
      final placeholder = ScheduleEntity(
        index: newIndex,
        time: '',
        description: '',
      );
      print("Placeholder schedule");
      emit(ScheduleLoaded(schedules: [...current.schedules, placeholder]));
    }
  }

  Future<void> _onCanceledSchedule(
    CanceledSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());

    try {
      final schedules = await scheduleRepository.load(
        DateTime.now().toString(),
      ); // не добре трохи
      emit(ScheduleLoaded(schedules: schedules));
    } catch (e) {
      emit(ScheduleError(message: e.toString()));
    }
  }
}
