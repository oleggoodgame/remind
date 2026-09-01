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
      print("Викликали репозиторій");
      await scheduleDatasorource.add(scheduleModel, day);
    } catch (e) {}
  }

  @override
  Future<void> canceled(String reason, int index, String day) async {
    try {
      await scheduleDatasorource.canceled(reason, index, day);
    } catch (e) {
      print("Сталась помилка ");
      print(e.toString());
    }
  }

  @override
  Future<void> delete(String day) async {
    try {
      await scheduleDatasorource.delete(day);
    } catch (e) {
      print("Сталась помилка ");
      print(e.toString());
    }
  }

  @override
  Future<void> edit(String description, int index, String day) async {
    try {
      await scheduleDatasorource.edit(description, index, day);
    } catch (e) {
      print("Сталась помилка ");
      print(e.toString());
    }
  }

  @override
  Future<List<ScheduleEntity>> load(String day) async {
    final list = await scheduleDatasorource.load(day);
    print("${list.toString()}");
    return await scheduleDatasorource.load(day);
  }

  @override
  Future<String> complete(String day, int index) async {
    try {
      return await scheduleDatasorource.complete(day, index);
    } catch (e) {
      print(e.toString());
      throw (Exception(e));
    }
  }
}
