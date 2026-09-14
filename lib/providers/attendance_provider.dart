import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/attendance.dart';
import '../data/students.dart';
import '../models/attendance.dart';

class TodayAttendanceNotifier extends Notifier<Map<String, AttendanceStatus>> {
  @override
  Map<String, AttendanceStatus> build() => Map.of(seedTodayAttendance);

  void saveClass(Map<String, AttendanceStatus> marks) =>
      state = {...state, ...marks};
}

final todayAttendanceProvider =
    NotifierProvider<TodayAttendanceNotifier, Map<String, AttendanceStatus>>(
        TodayAttendanceNotifier.new);

AttendanceSummary summarize(Iterable<AttendanceStatus> statuses) {
  var present = 0, absent = 0, late = 0;
  for (final s in statuses) {
    switch (s) {
      case AttendanceStatus.present:
        present++;
      case AttendanceStatus.late:
        late++;
      case AttendanceStatus.absent:
      case AttendanceStatus.leave:
        absent++;
    }
  }
  return AttendanceSummary(
    total: present + absent + late,
    present: present,
    absent: absent,
    late: late,
  );
}

final schoolAttendanceProvider = Provider<AttendanceSummary>(
  (ref) => summarize(ref.watch(todayAttendanceProvider).values),
);

final classAttendanceProvider =
    Provider.family<AttendanceSummary, String>((ref, classId) {
  final today = ref.watch(todayAttendanceProvider);
  return summarize(studentsInClass(classId)
      .map((s) => today[s.id] ?? AttendanceStatus.present));
});
