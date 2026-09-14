import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/fees.dart';
import '../data/students.dart';
import '../models/activity.dart';
import '../models/communication.dart';
import '../models/fee.dart';
import '../utils/formatters.dart';
import 'activity_provider.dart';
import 'communication_provider.dart';

class FeeState {
  const FeeState({
    required this.accounts,
    required this.todaysPayments,
    required this.nextReceiptSeq,
  });

  final Map<String, FeeAccount> accounts;

  /// Newest first.
  final List<Payment> todaysPayments;
  final int nextReceiptSeq;
}

class FeeNotifier extends Notifier<FeeState> {
  @override
  FeeState build() => FeeState(
        accounts: Map.of(FeeSeed.accounts),
        todaysPayments: List.of(FeeSeed.todaysPayments),
        nextReceiptSeq:
            FeeSeed.firstReceiptSeq + FeeSeed.todaysPayments.length,
      );

  String get nextReceiptNo => FeeSeed.receiptNo(state.nextReceiptSeq);

  /// Records a payment, updates the student's balance, logs the activity and
  /// "sends" the receipt to the parent on WhatsApp.
  Payment recordPayment({
    required String studentId,
    required String head,
    required int amount,
    required PaymentMode mode,
    String? period,
    String? reference,
  }) {
    final seq = state.nextReceiptSeq;
    final payment = Payment(
      receiptNo: FeeSeed.receiptNo(seq),
      studentId: studentId,
      amount: amount,
      head: head,
      period: period ?? periodLabel(1),
      mode: mode,
      date: DateTime.now(),
      collectedBy: mode == PaymentMode.online
          ? 'Parent App (Razorpay)'
          : 'Accounts Office',
      reference: reference ?? paymentReference(mode, seq),
    );
    final account = state.accounts[studentId];
    state = FeeState(
      accounts: {
        ...state.accounts,
        if (account != null)
          studentId: account.copyWith(paid: account.paid + amount),
      },
      todaysPayments: [payment, ...state.todaysPayments],
      nextReceiptSeq: seq + 1,
    );

    final s = studentById[studentId]!;
    ref.read(activityProvider.notifier).add(ActivityItem(
          type: ActivityType.feePaid,
          title: 'Fee received · ${Fmt.rupee(amount)}',
          subtitle: '${s.name} (${s.classId}) · ${mode.label}',
          time: payment.date,
        ));
    ref
        .read(communicationProvider.notifier)
        .logMessages([parentMessage(s, Channel.whatsapp, 'Fee Receipt')]);
    return payment;
  }
}

final feeProvider = NotifierProvider<FeeNotifier, FeeState>(FeeNotifier.new);

/// Headline fee numbers, recomputed live as payments are recorded.
class FeeSummary {
  const FeeSummary({
    required this.collectedMtd,
    required this.collectedByGrade,
    required this.todayTotal,
    required this.todayCount,
    required this.pending,
    required this.overdue,
    required this.dueThisWeek,
    required this.monthlyDemand,
    required this.lastMonthSamePeriod,
  });

  final int collectedMtd;
  final Map<String, int> collectedByGrade;
  final int todayTotal;
  final int todayCount;
  final int pending;

  /// Defaulters, most overdue amount first.
  final List<FeeAccount> overdue;

  /// Partial balances, soonest due first.
  final List<FeeAccount> dueThisWeek;
  final int monthlyDemand;
  final int lastMonthSamePeriod;

  int get overdueAmount => overdue.fold(0, (s, a) => s + a.balance);
  int get dueThisWeekAmount => dueThisWeek.fold(0, (s, a) => s + a.balance);
  double get monthProgress => collectedMtd / monthlyDemand;
  double get deltaPct =>
      (collectedMtd - lastMonthSamePeriod) / lastMonthSamePeriod * 100;
}

final feeSummaryProvider = Provider<FeeSummary>((ref) {
  final st = ref.watch(feeProvider);
  final byGrade = Map.of(FeeSeed.collectedBeforeTodayByGrade);
  var today = 0;
  for (final p in st.todaysPayments) {
    final grade = studentById[p.studentId]!.grade;
    byGrade[grade] = (byGrade[grade] ?? 0) + p.amount;
    today += p.amount;
  }
  final accounts = st.accounts.values;
  final overdue = accounts.where((a) => a.status == FeeStatus.overdue).toList()
    ..sort((a, b) => b.balance.compareTo(a.balance));
  final due = accounts.where((a) => a.status == FeeStatus.partial).toList()
    ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
  return FeeSummary(
    collectedMtd: byGrade.values.fold(0, (a, b) => a + b),
    collectedByGrade: byGrade,
    todayTotal: today,
    todayCount: st.todaysPayments.length,
    pending: accounts.fold(0, (s, a) => s + a.balance),
    overdue: overdue,
    dueThisWeek: due,
    monthlyDemand: FeeSeed.monthlyDemand,
    lastMonthSamePeriod: FeeSeed.lastMonthSamePeriod,
  );
});
