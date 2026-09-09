import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:remind/core/schedule/domain/repository/one_day_repository.dart';

part 'day_event.dart';
part 'day_state.dart';

class DayBloc extends Bloc<DayEvent, DayState> {
  final OneDayRepository oneDayRepository;
  DayBloc({required this.oneDayRepository}) : super(DayInital()) {
    on<GetDay>(_onGetDay);
    on<PlusDay>(_onPlusDay);
    on<MinusDay>(_onMinusDay);
    on<SelectDayOne>(_onSelectDay);
  }
  DateTime _selectedDay = () {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }();

  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  Future<void> _emitLoaded(Emitter<DayState> emit) async {
    final name = DateFormat('EEEE').format(_selectedDay);
    final month = DateFormat.MMMM().format(_selectedDay);
    final information = await oneDayRepository.fetchOnThisDayFact(_selectedDay);
    emit(
      DayLoadded(
        name: name,
        month: month,
        selectedDay: _selectedDay,
        information: information,
      ),
    );
  }

  Future<void> _onGetDay(GetDay event, Emitter<DayState> emit) async {
    try {
      emit(DayLoading());
      await _emitLoaded(emit);
    } catch (e) {
      emit(DayError());
    }
  }

  Future<void> _onPlusDay(PlusDay event, Emitter<DayState> emit) async {
    _selectedDay = _selectedDay.add(const Duration(days: 1));
    await _emitLoaded(emit);
  }

  Future<void> _onMinusDay(MinusDay event, Emitter<DayState> emit) async {
    _selectedDay = _selectedDay.subtract(const Duration(days: 1));
    await _emitLoaded(emit);
  }

  Future<void> _onSelectDay(SelectDayOne event, Emitter<DayState> emit) async {
    _selectedDay = _normalize(event.day);
    await _emitLoaded(emit);
  }
}
