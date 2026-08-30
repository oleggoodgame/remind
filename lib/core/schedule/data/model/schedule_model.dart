import 'dart:convert';

import 'package:remind/core/schedule/domain/entity/schedule_entity.dart';

class ScheduleModel extends ScheduleEntity {
  ScheduleModel({
    required super.time,
    required super.description,
    required super.index,
    super.reason,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'time': time,
      'description': description,
      'index': index,
    };
  }

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      time: map['time'] as String,
      description: map['description'] as String,
      index: map['index'] as int,
      // reason: map['reason'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScheduleModel.fromJson(String source) =>
      ScheduleModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory ScheduleModel.fromEntity(ScheduleEntity scheduleEntity) {
    return ScheduleModel(
      time: scheduleEntity.time,
      description: scheduleEntity.description,
      index: scheduleEntity.index,
      reason: scheduleEntity.reason,
    );
  }
}
