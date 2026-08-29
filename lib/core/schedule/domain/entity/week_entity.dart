import 'dart:ui';

class WeekEntity {
  final String name;
  final DateTime day;
  final Color?
  color; 
  WeekEntity({required this.name, required this.day, this.color});

  WeekEntity copyWith({String? name, DateTime? day, Color? color}) {
    return WeekEntity(
      name: name ?? this.name,
      day: day ?? this.day,
      color: color ?? this.color,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'name': name,
  //     'day': day.millisecondsSinceEpoch,
  //     'color': color.value,
  //   };
  // }

  // factory WeekEntity.fromMap(Map<String, dynamic> map) {
  //   return WeekEntity(
  //     name: map['name'] as String,
  //     day: DateTime.fromMillisecondsSinceEpoch(map['day'] as int),
  //     color: Color(map['color'] as int),
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory WeekEntity.fromJson(String source) => WeekEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'WeekEntity(name: $name, day: $day, color: $color)';

  @override
  bool operator ==(covariant WeekEntity other) {
    if (identical(this, other)) return true;

    return other.name == name && other.day == day && other.color == color;
  }
}
