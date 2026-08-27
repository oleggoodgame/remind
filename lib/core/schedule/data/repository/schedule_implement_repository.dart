import 'package:remind/core/schedule/data/datasource/schedule_datasorource.dart';
import 'package:remind/core/schedule/data/model/schedule_model.dart';
import 'package:remind/core/schedule/domain/entity/schedule_entity.dart';
import 'package:remind/core/schedule/domain/repository/schedule_repository.dart';

class ScheduleImplementRepository implements ScheduleRepository {
  final ScheduleDatasorource scheduleDatasorource;
  const ScheduleImplementRepository({required this.scheduleDatasorource});
  @override
  Future<void> add(ScheduleEntity scheduleEntity, String day) async {
    try {
      final ScheduleModel scheduleModel = ScheduleModel.fromEntity(
        scheduleEntity,
      );
      await scheduleDatasorource.add(scheduleModel, day);
    } catch (e) {}
  }

  @override
  Future<void> canceled(String reason, int index, String day) async {
    await scheduleDatasorource.canceled(reason, index, day);
  }

  @override
  Future<void> delete(String day) async {
    await scheduleDatasorource.delete(day);
  }

  @override
  Future<void> edit() {
    // TODO: implement edit
    throw UnimplementedError();
  }

  @override
  Future<List<ScheduleEntity>> load(String day) async {
    return await scheduleDatasorource.load(day);
  }
}
