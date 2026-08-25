import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remind/core/schedule/data/model/schedule_model.dart';

abstract class ScheduleDatasorource {
  Future<void> add(ScheduleModel scheduleModel, String day);
  Future<void> delete(String day);
  Future<void> edit();
  Future<void> canceled(String reason, int index, String day);
  Future<List<ScheduleModel>> load();
}

class ScheduleImplementedDatasource implements ScheduleDatasorource {
  @override
  Future<void> add(ScheduleModel scheduleModel, String day) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('days').doc(day).set({
      'schedule': FieldValue.arrayUnion([scheduleModel.toMap()]),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> canceled(String reason, int index, String day) async {
    final firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection('days').doc(day);
    final getDay = await docRef.get();
    final dayMap = getDay.data();
    final dayLists =
        (dayMap?['schedule'] as List<dynamic>?)
            ?.map((e) => ScheduleModel.fromMap(e as Map<String, dynamic>))
            .toList() ??
        [];
    final updatedList =
        dayLists.map((schedule) {
              if (schedule.index == index) {
                return schedule.copyWith(reason: reason);
              }
              return schedule;
            }).toList()
            as List<ScheduleModel>;

    await docRef.set({
      'schedule': updatedList.map((s) => s.toMap()).toList(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> delete(String day) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('days').doc(day).delete();
  }

  @override
  Future<void> edit() {
    // TODO: implement edit
    throw UnimplementedError();
  }

  @override
  Future<List<ScheduleModel>> load() {
    // TODO: implement load
    throw UnimplementedError();
  }
}
