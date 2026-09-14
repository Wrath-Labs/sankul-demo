import 'dart:math' as math;

enum FeeStatus { paid, partial, overdue }

enum PaymentMode { cash, upi, cheque, online }

extension PaymentModeX on PaymentMode {
  String get label => switch (this) {
        PaymentMode.cash => 'Cash',
        PaymentMode.upi => 'UPI',
        PaymentMode.cheque => 'Cheque',
        PaymentMode.online => 'Online (App)',
      };
}

extension FeeStatusX on FeeStatus {
  String get label => switch (this) {
        FeeStatus.paid => 'Paid',
        FeeStatus.partial => 'Partial',
        FeeStatus.overdue => 'Overdue',
      };
}

class FeeHead {
  const FeeHead(this.id, this.name);
  final String id;
  final String name;
}

class TransportRoute {
  const TransportRoute(this.id, this.name, this.monthlyFee);
  final String id;
  final String name;
  final int monthlyFee;
}

/// A student's fee position for the session to date.
class FeeAccount {
  const FeeAccount({
    required this.studentId,
    required this.monthlyFee,
    required this.totalDue,
    required this.paid,
    this.dueDate,
    this.overdueDays = 0,
  });

  final String studentId;

  /// Tuition + transport per month.
  final int monthlyFee;

  /// All charges raised this session so far.
  final int totalDue;
  final int paid;

  /// When the outstanding balance falls due (future for partial balances).
  final DateTime? dueDate;

  /// Days past due; > 0 means the student is a defaulter.
  final int overdueDays;

  int get balance => math.max(0, totalDue - paid);

  FeeStatus get status {
    if (balance == 0) return FeeStatus.paid;
    return overdueDays > 0 ? FeeStatus.overdue : FeeStatus.partial;
  }

  FeeAccount copyWith({int? paid}) => FeeAccount(
        studentId: studentId,
        monthlyFee: monthlyFee,
        totalDue: totalDue,
        paid: paid ?? this.paid,
        dueDate: dueDate,
        overdueDays: overdueDays,
      );
}

class Payment {
  const Payment({
    required this.receiptNo,
    required this.studentId,
    required this.amount,
    required this.head,
    required this.period,
    required this.mode,
    required this.date,
    required this.collectedBy,
    this.reference,
  });

  /// SPS/26-27/04812
  final String receiptNo;
  final String studentId;
  final int amount;

  /// Fee head name, e.g. "Tuition + Transport".
  final String head;

  /// Months or term covered, e.g. "Jul – Sep 2026".
  final String period;
  final PaymentMode mode;
  final DateTime date;
  final String collectedBy;

  /// UPI transaction id / cheque number.
  final String? reference;
}
