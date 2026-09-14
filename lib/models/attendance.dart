enum AttendanceStatus { present, absent, late, leave }

extension AttendanceStatusX on AttendanceStatus {
  String get label => switch (this) {
        AttendanceStatus.present => 'Present',
        AttendanceStatus.absent => 'Absent',
        AttendanceStatus.late => 'Late',
        AttendanceStatus.leave => 'Leave',
      };

  String get short => switch (this) {
        AttendanceStatus.present => 'P',
        AttendanceStatus.absent => 'A',
        AttendanceStatus.late => 'L',
        AttendanceStatus.leave => 'LV',
      };

  /// Late counts as attended; leave and absent do not.
  bool get attended =>
      this == AttendanceStatus.present || this == AttendanceStatus.late;
}

class AttendanceSummary {
  const AttendanceSummary({
    required this.total,
    required this.present,
    required this.absent,
    required this.late,
  });

  final int total;
  final int present;
  final int absent;
  final int late;

  int get attended => present + late;
  double get pct => total == 0 ? 0 : attended / total * 100;
}
