import 'package:remind/core/schedule/domain/entity/schedule_entity.dart';

abstract class ScheduleRepository{
  Future<void> add(ScheduleEntity scheduleEntity);
  Future<void> delete();
  Future<void> edit();
  Future<void> canceled();
  Future<List<ScheduleEntity>> load();
}