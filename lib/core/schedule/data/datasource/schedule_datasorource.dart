import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remind/core/schedule/data/model/schedule_model.dart';

abstract class ScheduleDatasorource {
  Future<void> add(ScheduleModel scheduleModel, String day);
  Future<void> delete(String day);
  Future<void> edit(String description, int index, String day);
  Future<void> canceled(String reason, int index, String day);
  Future<String> complete(String day, int index);
  Future<List<ScheduleModel>> load(String day);
}

class ScheduleImplementedDatasource implements ScheduleDatasorource {
  @override
  Future<void> add(ScheduleModel scheduleModel, String day) async {
    try {
      print("Викликали базу даних: ДАНІ: ${scheduleModel.toString()}, ${day}");
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('days').doc(day).set({
        'schedule': FieldValue.arrayUnion([scheduleModel.toMap()]),
      }, SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
      print("сталась помилка");
    }
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
  Future<void> edit(String description, int index, String day) async {
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
                return schedule.copyWith(description: description);
              }
              return schedule;
            }).toList()
            as List<ScheduleModel>;

    await docRef.set({
      'schedule': updatedList.map((s) => s.toMap()).toList(),
    }, SetOptions(merge: true));
  }

  @override
  Future<List<ScheduleModel>> load(String day) async {
    try {
      final firestore = FirebaseFirestore.instance;
      // final snapshot = await firestore.collection('days').get();
      // або .doc(day).get(), залежно від того, чи load() для одного дня чи всіх

      // приклад для одного дня:
      final doc = await firestore.collection('days').doc(day).get();
      final data = doc.data();
      return (data?['schedule'] as List<dynamic>? ?? [])
          .map((e) => ScheduleModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e.toString());
      print("Српацювала помилка ");
      throw Exception('');
    }
  }

  @override
  Future<String> complete(String day, int index) async {
    final firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection('days').doc(day);
    final getDay = await docRef.get();
    final dayMap = getDay.data();
    final dayLists =
        (dayMap?['schedule'] as List<dynamic>?)
            ?.map((e) => ScheduleModel.fromMap(e as Map<String, dynamic>))
            .toList() ??
        [];
    // final previousSchedule = dayLists[--index];
    if (index > 0) {
      final previousSchedule = dayLists[index - 1];
      final schedule = dayLists[index];
      final fifi = schedule.time==null|| schedule.time!.isNotEmpty;
      final previousNotDone =
          previousSchedule.time == null || previousSchedule.time!.isEmpty;
      if (previousNotDone) {
        throw Exception("You did not finish the previous one");
      }
      if(fifi){
        throw Exception("You already end it ");
      }
    }
    int hour = 0;
    int minute = 0;
    if (index == 0) {
      hour = DateTime.now().hour;
      minute = DateTime.now().minute;
    } else {
      int totalMinute = 0;
      for (int i = 0; i < index; i++) {
        final previousTime = dayLists[i].time!.split(':');
        final int previousHourInMinute = int.parse(previousTime[0]) * 60;
        final int previousMinute = int.parse(previousTime[1]);
        totalMinute += previousMinute + previousHourInMinute;
      }
      final nowMinute = DateTime.now().hour * 60 + DateTime.now().minute;
      final difference = nowMinute - totalMinute;
      hour = difference ~/ 60;
      minute = difference % 60;
    }
    final String time =
        "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
    final updatedList =
        dayLists.map((schedule) {
              if (schedule.index == index) {
                return schedule.copyWith(time: time);
              }
              return schedule;
            }).toList()
            as List<ScheduleModel>;

    await docRef.set({
      'schedule': updatedList.map((s) => s.toMap()).toList(),
    }, SetOptions(merge: true));
    return time;
  }
}
