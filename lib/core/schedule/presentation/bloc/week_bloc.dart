import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:remind/core/schedule/domain/entity/week_entity.dart';

part 'week_event.dart';
part 'week_state.dart';

class WeekBloc extends Bloc<WeekEvent, WeekState> {
  WeekBloc() : super(WeekInitial()) {
    on<GetWeeks>(_onGetWeeks);
    on<PlusWeek>(_onPlusWeek);
    on<MinusWeek>(_onMinusWeek);
    on<SelectDay>(_onSelectDay);
  }

  int _week = 0;
  DateTime _selectedDay = () {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }();

  DateTime get _mondayOfCurrentWeek {
    final now = DateTime.now();
    print(
      "ТЕ що я нахуй не розумію now .subtract(Duration(days: now.weekday - 1) = ${now.subtract(Duration(days: now.weekday - 1))} і потім: now.subtract(Duration(days: now.weekday - 1)).add(Duration(days: _week * 7)) = ${now.subtract(Duration(days: now.weekday - 1)).add(Duration(days: _week * 7))}",
    );
    return now
        .subtract(Duration(days: now.weekday - 1))
        .add(Duration(days: _week * 7));
  }

  List<WeekEntity> _buildWeekList() {
    final monday = _mondayOfCurrentWeek;
    final List<WeekEntity> weeks = [];

    for (int i = 0; i < 7; i++) {
      final day = monday.add(Duration(days: i));
      final name = DateFormat('EEEE').format(day);
      final dateOnly = DateTime(day.year, day.month, day.day);

      weeks.add(
        WeekEntity(
          name: name,
          day: dateOnly,
          color: i >= 5 ? Colors.red.shade400 : null,
        ),
      );
    }
    return weeks;
  }

  void _emitLoaded(Emitter<WeekState> emit) {
    final monday = _mondayOfCurrentWeek;
    final monthName = DateFormat.MMMM().format(monday);
    emit(
      WeekLoaded(
        weekList: _buildWeekList(),
        month: monthName,
        selectedDay: _selectedDay,
      ),
    );
  }

  Future<void> _onGetWeeks(GetWeeks event, Emitter<WeekState> emit) async {
    try {
      emit(WeekLoading());
      _emitLoaded(emit);
    } catch (e) {
      emit(WeekError());
    }
  }

  Future<void> _onPlusWeek(PlusWeek event, Emitter<WeekState> emit) async {
    _week++;
    _emitLoaded(emit);
  }

  Future<void> _onMinusWeek(MinusWeek event, Emitter<WeekState> emit) async {
    _week--;
    _emitLoaded(emit);
  }

  Future<void> _onSelectDay(SelectDay event, Emitter<WeekState> emit) async {
    _selectedDay = DateTime(event.day.year, event.day.month, event.day.day);
    _emitLoaded(emit);
  }
}
