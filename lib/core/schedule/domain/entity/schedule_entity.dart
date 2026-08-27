class ScheduleEntity {
  final int index;
  final String? time;
  final String description;
  final String? reason;
  const ScheduleEntity({
    required this.index,
    this.time,
    required this.description,
    this.reason,
  });

  ScheduleEntity copyWith({
    int? index,
    String? time,
    String? description,
    String? reason,
  }) {
    return ScheduleEntity(
      index: index ?? this.index,
      time: time ?? this.time,
      description: description ?? this.description,
      reason: reason ?? this.reason,
    );
  }

  @override
  String toString() {
    return 'ScheduleEntity(index: $index, time: $time, description: $description, reason: $reason)';
  }

  @override
  bool operator ==(covariant ScheduleEntity other) {
    if (identical(this, other)) return true;

    return other.index == index &&
        other.time == time &&
        other.description == description &&
        other.reason == reason;
  }

  @override
  int get hashCode {
    return index.hashCode ^
        time.hashCode ^
        description.hashCode ^
        reason.hashCode;
  }
}
