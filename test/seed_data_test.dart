import 'package:flutter_test/flutter_test.dart';
import 'package:sankul/data/attendance.dart';
import 'package:sankul/data/classes.dart';
import 'package:sankul/data/communication.dart';
import 'package:sankul/data/exams.dart';
import 'package:sankul/data/fees.dart';
import 'package:sankul/data/staff.dart';
import 'package:sankul/data/students.dart';
import 'package:sankul/models/attendance.dart';
import 'package:sankul/models/fee.dart';
import 'package:sankul/models/student.dart';
import 'package:sankul/utils/formatters.dart';

void main() {
  test('seed data is internally consistent', () {
    final active = seedStudents.where((s) => s.isActive).toList();
    expect(active.length, 620);
    expect(totalStrength, 620);
    for (final c in schoolClasses) {
      expect(studentsInClass(c.id).length, c.strength, reason: c.id);
      expect(classTeacherFor(c.id), isNotNull, reason: c.id);
    }
    expect(seedStudents.map((s) => s.name).toSet().length, seedStudents.length,
        reason: 'student names unique');
    expect(seedStudents.map((s) => s.admissionNo).toSet().length,
        seedStudents.length,
        reason: 'admission numbers unique');

    final accounts = FeeSeed.accounts.values;
    final overdue = accounts.where((a) => a.status == FeeStatus.overdue);
    final partial = accounts.where((a) => a.status == FeeStatus.partial);
    final pending = accounts.fold(0, (s, a) => s + a.balance);
    final today = FeeSeed.todaysPayments.fold(0, (s, p) => s + p.amount);
    final mtd = FeeSeed.collectedBeforeTodayByGrade.values
            .fold(0, (a, b) => a + b) +
        today;

    for (final p in FeeSeed.todaysPayments) {
      expect(FeeSeed.accounts[p.studentId]!.status, FeeStatus.paid,
          reason: 'payer ${studentById[p.studentId]!.name} should be paid up');
    }

    final att = seedTodayAttendance.values;
    final absent = att.where((s) => s == AttendanceStatus.absent).length;
    final late = att.where((s) => s == AttendanceStatus.late).length;

    // ignore: avoid_print
    print('''
students        ${active.length} (boys ${active.where((s) => s.gender == Gender.male).length})
staff           ${seedStaff.length}
monthly demand  ${Fmt.rupee(FeeSeed.monthlyDemand)}
collected MTD   ${Fmt.rupee(mtd)}  (today ${Fmt.rupee(today)}, ${FeeSeed.todaysPayments.length} receipts)
prev months     ${FeeSeed.previousMonthsCollected.map(Fmt.rupeeCompact).join(', ')}
pending         ${Fmt.rupee(pending)}
  overdue       ${overdue.length} students, ${Fmt.rupee(overdue.fold(0, (s, a) => s + a.balance))}
  partial       ${partial.length} students, ${Fmt.rupee(partial.fold(0, (s, a) => s + a.balance))}
attendance      absent $absent, late $late, pct ${((620 - absent) / 620 * 100).toStringAsFixed(1)}
marks           ${seedMarks.length} students
announcements   ${seedAnnouncements.length}, log ${seedMessageLog.length}
words           ${Fmt.amountInWords(124500)}
''');
    expect(overdue.length, 18);
    expect(absent, 47);
    expect(late, 11);
  });
}
