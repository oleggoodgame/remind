import 'package:remind/core/schedule/domain/entity/schedule_entity.dart';

abstract class ScheduleRepository{
Future<void> add(ScheduleEntity scheduleEntity, String day);
 Future<void> delete(String day);
  Future<void> edit();
  Future<void> canceled(String reason, int index, String day);
  Future<List<ScheduleEntity>> load(String day);
}
