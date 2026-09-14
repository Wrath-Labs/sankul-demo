import 'dart:math';

import '../models/attendance.dart';
import 'classes.dart';
import 'students.dart';

/// Named absentees in the showcase classes — these are the parents who get
/// the "absence SMS" in the demo.
const _showcaseToday = <String, AttendanceStatus>{
  'Harshit Yadav': AttendanceStatus.absent,
  'Tanvi Saxena': AttendanceStatus.late,
  'Riya Chauhan': AttendanceStatus.absent,
  'Yash Kapoor': AttendanceStatus.absent,
  'Dhruv Bansal': AttendanceStatus.late,
  'Myra Jain': AttendanceStatus.absent,
  'Om Tiwari': AttendanceStatus.absent,
};

const _showcaseClasses = {'X-A', 'VIII-A', 'V-B'};

/// Absent / late counts for the remaining sections (school-wide today:
/// 47 absent, 11 late → 92.4% attendance).
const _absentBySection = <String, int>{
  'Nursery-A': 2, 'Nursery-B': 3, 'LKG-A': 1, 'LKG-B': 2, 'UKG-A': 1,
  'UKG-B': 2, 'I-A': 2, 'I-B': 1, 'II-A': 2, 'II-B': 1, 'III-A': 1,
  'III-B': 2, 'IV-A': 1, 'IV-B': 2, 'V-A': 1, 'V-C': 2, 'VI-A': 1, 'VI-B': 2,
  'VII-A': 1, 'VII-B': 2, 'VIII-B': 1, 'VIII-C': 2, 'IX-A': 1, 'IX-B': 2,
  'X-B': 1, 'XI-A': 1, 'XI-B': 0, 'XII-A': 1, 'XII-B': 1,
};

const _lateBySection = <String, int>{
  'I-A': 1, 'III-B': 1, 'VI-A': 1, 'VII-B': 1, 'IX-B': 1, 'XI-A': 2,
  'XII-A': 1, 'XII-B': 1,
};

const double yesterdayAttendancePct = 91.3;

/// Today's status for every active student.
final Map<String, AttendanceStatus> seedTodayAttendance = _buildToday();

Map<String, AttendanceStatus> _buildToday() {
  final out = <String, AttendanceStatus>{};
  for (var ci = 0; ci < schoolClasses.length; ci++) {
    final c = schoolClasses[ci];
    final roster = studentsInClass(c.id);
    if (_showcaseClasses.contains(c.id)) {
      for (final s in roster) {
        out[s.id] = _showcaseToday[s.name] ?? AttendanceStatus.present;
      }
      continue;
    }
    final rng = Random(500 + ci);
    final order = [...roster]..shuffle(rng);
    final absent = _absentBySection[c.id] ?? 0;
    final late = _lateBySection[c.id] ?? 0;
    for (var i = 0; i < order.length; i++) {
      out[order[i].id] = i < absent
          ? AttendanceStatus.absent
          : i < absent + late
              ? AttendanceStatus.late
              : AttendanceStatus.present;
    }
  }
  return out;
}
