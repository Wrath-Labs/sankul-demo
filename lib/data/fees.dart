import 'dart:math';

import 'package:intl/intl.dart';

import '../config/branding.dart';
import '../config/demo_clock.dart';
import '../models/fee.dart';
import '../models/student.dart';
import 'classes.dart';
import 'students.dart';

// ── Fee structure ─────────────────────────────────────────────────────────

const monthlyTuition = <String, int>{
  'Nursery': 1800, 'LKG': 1900, 'UKG': 2000, 'I': 2300, 'II': 2400,
  'III': 2500, 'IV': 2600, 'V': 2800, 'VI': 3000, 'VII': 3200, 'VIII': 3400,
  'IX': 3700, 'X': 3900, 'XI': 4300, 'XII': 4500,
};

int annualChargesFor(String grade) {
  final o = gradeOrder.indexOf(grade);
  if (o <= 2) return 4500;
  if (o <= 7) return 5500;
  if (o <= 10) return 6500;
  if (o <= 12) return 7500;
  return 8500;
}

int examFeeFor(String grade) {
  final o = gradeOrder.indexOf(grade);
  if (o <= 2) return 600;
  if (o <= 7) return 800;
  if (o <= 10) return 1000;
  return 1500;
}

const admissionFee = 15000;

const transportRoutes = <TransportRoute>[
  TransportRoute('R1', 'Route 1 · Sikandra – Bodla', 1100),
  TransportRoute('R2', 'Route 2 · Kamla Nagar – Balkeshwar', 1300),
  TransportRoute('R3', 'Route 3 · Dayal Bagh – Khandari', 1300),
  TransportRoute('R4', 'Route 4 · Shastripuram – Awas Vikas', 1400),
  TransportRoute('R5', 'Route 5 · Trans Yamuna – Rambagh', 1600),
  TransportRoute('R6', 'Route 6 · Civil Lines – Sanjay Place', 1500),
];

final Map<String, TransportRoute> routeById = {
  for (final r in transportRoutes) r.id: r,
};

const feeHeads = <FeeHead>[
  FeeHead('tuition_transport', 'Tuition + Transport'),
  FeeHead('tuition', 'Tuition Fee'),
  FeeHead('transport', 'Transport Fee'),
  FeeHead('exam', 'Examination Fee'),
  FeeHead('annual', 'Annual Charges'),
  FeeHead('admission', 'Admission Fee'),
];

int monthlyFeeFor(Student s) =>
    monthlyTuition[s.grade]! +
    (s.routeId == null ? 0 : routeById[s.routeId]!.monthlyFee);

/// Everything billed to the student so far this session.
int sessionChargesFor(Student s) =>
    monthlyFeeFor(s) * DemoClock.monthsElapsed +
    annualChargesFor(s.grade) +
    examFeeFor(s.grade);

/// "Jul – Sep 2026" for the last [months] months, or "Sep 2026".
String periodLabel(int months) {
  final ms = DemoClock.lastMonths(months);
  final end = DateFormat('MMM yyyy').format(ms.last);
  if (months == 1) return end;
  return '${DateFormat('MMM').format(ms.first)} – $end';
}

// ── Seeded fee positions ──────────────────────────────────────────────────

class _Due {
  const _Due(this.key, this.months, this.days);
  final String key;
  final int months;
  final int days;
}

/// 18 defaulters: months of fee overdue and days past due date.
const _defaulters = [
  _Due('Rohan Rajput', 4, 108),
  _Due('Pari Rajput', 4, 108),
  _Due('XI-B#2', 5, 139),
  _Due('XII-B#3', 4, 111),
  _Due('III-A#9', 3, 81),
  _Due('IX-B#3', 3, 76),
  _Due('IV-B#8', 3, 73),
  _Due('VIII-C#10', 3, 79),
  _Due('XII-A#5', 2, 52),
  _Due('UKG-B#6', 2, 49),
  _Due('Kunal Saxena', 2, 47),
  _Due('VI-B#4', 2, 44),
  _Due('IX-A#11', 3, 72),
  _Due('X-B#14', 1, 23),
  _Due('I-B#2', 1, 21),
  _Due('VII-A#7', 1, 19),
  _Due('Nursery-A#4', 1, 18),
  _Due('II-A#12', 1, 16),
];

class _Partial {
  const _Partial(this.key, this.dueInDays, {this.half = false});
  final String key;
  final int dueInDays;
  final bool half;
}

/// Current-month balances falling due within the week.
const _partials = [
  _Partial('Aarav Sharma', 3),
  _Partial('Ishaan Mittal', 2),
  _Partial('Charvi Agarwal', 5, half: true),
  _Partial('I-A#5', 1),
  _Partial('II-B#9', 4, half: true),
  _Partial('III-B#14', 2),
  _Partial('IV-A#3', 6),
  _Partial('V-A#11', 3, half: true),
  _Partial('V-C#6', 1),
  _Partial('VI-A#17', 5),
  _Partial('VI-B#8', 4, half: true),
  _Partial('VII-B#12', 2),
  _Partial('VIII-B#4', 6),
  _Partial('VIII-C#15', 3, half: true),
  _Partial('IX-A#19', 1),
  _Partial('IX-B#10', 5),
  _Partial('X-B#7', 2, half: true),
  _Partial('XI-A#13', 4),
  _Partial('XII-A#9', 6),
  _Partial('LKG-A#6', 3),
  _Partial('UKG-B#11', 5, half: true),
  _Partial('Nursery-B#8', 6),
];

class _Paid {
  const _Paid(this.key, this.months, this.mode, this.minutesAgo);
  final String key;
  final int months;
  final PaymentMode mode;
  final int minutesAgo;
}

/// Payments received today, most recent first.
const _todaysPayments = [
  _Paid('IX-B#6', 3, PaymentMode.upi, 6),
  _Paid('Nandini Goyal', 3, PaymentMode.cash, 19),
  _Paid('III-A#12', 3, PaymentMode.cash, 34),
  _Paid('XII-B#10', 2, PaymentMode.cheque, 48),
  _Paid('VI-A#4', 3, PaymentMode.upi, 61),
  _Paid('LKG-B#9', 3, PaymentMode.online, 73),
  _Paid('Khushi Singhal', 1, PaymentMode.upi, 88),
  _Paid('XI-A#6', 3, PaymentMode.upi, 102),
  _Paid('II-A#17', 3, PaymentMode.cash, 118),
  _Paid('V-C#12', 2, PaymentMode.online, 131),
  _Paid('X-B#19', 3, PaymentMode.cheque, 146),
  _Paid('I-B#15', 3, PaymentMode.cash, 159),
  _Paid('VIII-C#7', 1, PaymentMode.upi, 171),
  _Paid('IV-B#16', 3, PaymentMode.upi, 188),
  _Paid('UKG-A#2', 3, PaymentMode.cash, 203),
  _Paid('VII-B#18', 2, PaymentMode.online, 217),
  _Paid('XII-A#15', 1, PaymentMode.upi, 231),
  _Paid('Nursery-B#11', 3, PaymentMode.cash, 246),
];

/// Share of each grade's monthly demand collected this month before today.
const _mtdRatio = <String, double>{
  'Nursery': .47, 'LKG': .44, 'UKG': .46, 'I': .45, 'II': .43, 'III': .46,
  'IV': .42, 'V': .44, 'VI': .41, 'VII': .43, 'VIII': .45, 'IX': .40,
  'X': .44, 'XI': .39, 'XII': .42,
};

/// Collection efficiency of the five months before this one (oldest first).
const _previousMonthRatios = [.914, .927, .921, .943, .956];

class FeeSeed {
  FeeSeed._();

  static const int firstReceiptSeq = 4812;

  static String receiptNo(int seq) =>
      '${Branding.schoolCode}/${DemoClock.sessionCode}/${seq.toString().padLeft(5, '0')}';

  static final Map<String, FeeAccount> accounts = _buildAccounts();

  /// Newest first.
  static final List<Payment> todaysPayments = _buildTodaysPayments();

  /// Monthly tuition + transport billed, per grade.
  static final Map<String, int> demandByGrade = {
    for (final g in gradeOrder)
      g: seedStudents
          .where((s) => s.isActive && s.grade == g)
          .fold(0, (sum, s) => sum + monthlyFeeFor(s)),
  };

  static final int monthlyDemand =
      demandByGrade.values.fold(0, (a, b) => a + b);

  /// Collected this month up to yesterday, per grade.
  static final Map<String, int> collectedBeforeTodayByGrade = {
    for (final g in gradeOrder)
      g: (demandByGrade[g]! * _mtdRatio[g]! / 100).round() * 100,
  };

  /// Collected in each of the previous five months (oldest first).
  static final List<int> previousMonthsCollected = [
    for (final r in _previousMonthRatios) (monthlyDemand * r / 1000).round() * 1000,
  ];

  /// Month-to-date collection at the same point last month, for the delta.
  static final int lastMonthSamePeriod = (() {
    final mtd = collectedBeforeTodayByGrade.values.fold(0, (a, b) => a + b) +
        todaysPayments.fold(0, (a, p) => a + p.amount);
    return (mtd / 1.084).round();
  })();

  static const int yesterdayCollection = 142350;
}

Map<String, FeeAccount> _buildAccounts() {
  final overdue = {for (final d in _defaulters) studentByKey(d.key).id: d};
  final partial = {for (final p in _partials) studentByKey(p.key).id: p};
  final out = <String, FeeAccount>{};
  for (final s in seedStudents.where((s) => s.isActive)) {
    final monthly = monthlyFeeFor(s);
    final total = sessionChargesFor(s);
    final d = overdue[s.id];
    final p = partial[s.id];
    final balance = d != null
        ? monthly * d.months
        : p != null
            ? (p.half ? monthly ~/ 2 : monthly)
            : 0;
    out[s.id] = FeeAccount(
      studentId: s.id,
      monthlyFee: monthly,
      totalDue: total,
      paid: total - balance,
      dueDate: d != null
          ? DemoClock.today.subtract(Duration(days: d.days))
          : p != null
              ? DemoClock.daysFromNow(p.dueInDays)
              : null,
      overdueDays: d?.days ?? 0,
    );
  }
  return out;
}

List<Payment> _buildTodaysPayments() {
  // Oldest first so receipt numbers run in time order.
  final specs = [..._todaysPayments]
    ..sort((a, b) => b.minutesAgo.compareTo(a.minutesAgo));
  final t = DemoClock.today;
  final opening = DateTime(t.year, t.month, t.day, 8, 5);
  final out = <Payment>[];
  for (var i = 0; i < specs.length; i++) {
    final p = specs[i];
    final s = studentByKey(p.key);
    var when = DemoClock.schoolMinutesAgo(p.minutesAgo);
    if (when.isBefore(opening)) when = opening.add(Duration(minutes: i * 6));
    final seq = FeeSeed.firstReceiptSeq + i;
    out.add(Payment(
      receiptNo: FeeSeed.receiptNo(seq),
      studentId: s.id,
      amount: monthlyFeeFor(s) * p.months,
      head: s.usesTransport ? 'Tuition + Transport' : 'Tuition Fee',
      period: periodLabel(p.months),
      mode: p.mode,
      date: when,
      collectedBy: p.mode == PaymentMode.online
          ? 'Parent App (Razorpay)'
          : 'Accounts Office',
      reference: paymentReference(p.mode, seq),
    ));
  }
  return out.reversed.toList();
}

/// Plausible UPI / cheque / gateway reference for a receipt.
String? paymentReference(PaymentMode mode, int seed) {
  final r = Random(seed * 7919);
  String digits(int n) =>
      List.generate(n, (_) => r.nextInt(10)).join();
  const alnum = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789';
  return switch (mode) {
    PaymentMode.cash => null,
    PaymentMode.upi => 'UPI Ref ${digits(12)}',
    PaymentMode.cheque => 'Chq ${digits(6)} · HDFC Bank',
    PaymentMode.online =>
      'pay_${List.generate(14, (_) => alnum[r.nextInt(alnum.length)]).join()}',
  };
}
