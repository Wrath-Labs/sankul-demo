import '../config/demo_clock.dart';
import '../models/activity.dart';
import '../models/fee.dart';
import '../utils/formatters.dart';
import 'fees.dart';
import 'staff.dart';
import 'students.dart';

/// Attendance is marked by 9 AM; absence alerts go out right after.
DateTime get absenceAlertTime => DemoClock.todayAt(9, 4);

/// Recent activity shown on the dashboard, newest first.
List<ActivityItem> buildSeedActivity() {
  final payments = FeeSeed.todaysPayments;
  ActivityItem paid(Payment p) {
    final s = studentById[p.studentId]!;
    return ActivityItem(
      type: ActivityType.feePaid,
      title: 'Fee received · ${Fmt.rupee(p.amount)}',
      subtitle: '${s.name} (${s.classId}) · ${p.mode.label}',
      time: p.date,
    );
  }

  final kiara = studentNamed('Kiara Bansal');
  final items = [
    paid(payments[0]),
    paid(payments[1]),
    ActivityItem(
      type: ActivityType.message,
      title: 'Absence alerts sent',
      subtitle: '47 parents notified via SMS + WhatsApp',
      time: absenceAlertTime,
    ),
    ActivityItem(
      type: ActivityType.attendance,
      title: 'Attendance marked · X-A',
      subtitle: '15 of 16 present · ${demoTeacher.name}',
      time: DemoClock.todayAt(8, 52),
    ),
    paid(payments[2]),
    ActivityItem(
      type: ActivityType.exam,
      title: 'Marks uploaded · Science, X-A',
      subtitle: 'Half-Yearly · ${staffById['T02']!.name}',
      time: DemoClock.schoolMinutesAgo(52),
    ),
    ActivityItem(
      type: ActivityType.admission,
      title: 'New admission · ${kiara.name}',
      subtitle: '${kiara.classId} · ${kiara.admissionNo}',
      time: DemoClock.schoolMinutesAgo(84),
    ),
    ActivityItem(
      type: ActivityType.announcement,
      title: 'Announcement sent · PTM notice',
      subtitle: 'Delivered to 509 parents',
      time: DemoClock.daysAgo(1, hour: 17, minute: 30),
    ),
  ];
  items.sort((a, b) => b.time.compareTo(a.time));
  return items;
}
