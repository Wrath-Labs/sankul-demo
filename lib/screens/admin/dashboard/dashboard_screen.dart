import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/branding.dart';
import '../../../config/demo_clock.dart';
import '../../../data/attendance.dart';
import '../../../data/classes.dart';
import '../../../models/student.dart';
import '../../../providers/attendance_provider.dart';
import '../../../providers/fee_provider.dart';
import '../../../providers/school_providers.dart';
import '../../../providers/session_provider.dart';
import '../../../router/routes.dart';
import '../../../theme/tokens.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/common.dart';
import '../../../widgets/kpi_card.dart';
import '../../../widgets/responsive_row.dart';
import '../fees/record_payment_dialog.dart';
import 'widgets/activity_card.dart';
import 'widgets/attendance_card.dart';
import 'widgets/fee_collection_card.dart';
import 'widgets/fees_due_card.dart';
import 'widgets/quick_actions.dart';
import 'widgets/upcoming_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.page),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Greeting(),
          SizedBox(height: AppSpacing.xxl),
          _KpiGrid(),
          SizedBox(height: AppSpacing.xl),
          QuickActions(),
          SizedBox(height: AppSpacing.xl),
          ResponsiveRow(
            height: 372,
            flex: [3, 2],
            children: [FeeCollectionCard(), AttendanceCard()],
          ),
          SizedBox(height: AppSpacing.xl),
          ResponsiveRow(
            height: 430,
            flex: [4, 4, 3],
            breakpoint: 1000,
            children: [ActivityCard(), FeesDueCard(), UpcomingCard()],
          ),
          SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _Greeting extends ConsumerStatefulWidget {
  const _Greeting();

  @override
  ConsumerState<_Greeting> createState() => _GreetingState();
}

class _GreetingState extends ConsumerState<_Greeting> {
  DateTime _updated = DateTime.now().subtract(const Duration(minutes: 2));
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    // Keep "Updated x mins ago" honest while the dashboard stays open.
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(sessionProvider);
    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${DemoClock.greeting}, ${user.formalName}', style: AppText.h1),
        const SizedBox(height: 4),
        const Text(
          "Here's what's happening at ${Branding.schoolName} today.",
          style: AppText.bodySm,
        ),
      ],
    );
    final actions = Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Tooltip(
          message: 'Refresh',
          child: InkWell(
            borderRadius: AppRadius.mdAll,
            onTap: () {
              setState(() => _updated = DateTime.now());
              showAppSnack(context, 'Dashboard refreshed with the latest data');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.sync_rounded,
                    size: 15,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Updated ${Fmt.relative(_updated).toLowerCase()}',
                    style: AppText.caption,
                  ),
                ],
              ),
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => context.go(Routes.communication),
          icon: const Icon(Icons.campaign_outlined, size: 18),
          label: const Text('Announce'),
        ),
        FilledButton.icon(
          onPressed: () => showRecordPaymentDialog(context),
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Record Payment'),
        ),
      ],
    );
    return LayoutBuilder(
      builder: (context, box) => box.maxWidth > 820
          ? Row(
              children: [
                Expanded(child: title),
                actions,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [title, const SizedBox(height: 16), actions],
            ),
    );
  }
}

class _KpiGrid extends ConsumerWidget {
  const _KpiGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fee = ref.watch(feeSummaryProvider);
    final att = ref.watch(schoolAttendanceProvider);
    final students = ref.watch(activeStudentsProvider);
    final boys = students.where((s) => s.gender == Gender.male).length;
    final girls = students.length - boys;
    final lastMonth = DemoClock.lastMonths(2).first;

    return EqualGrid(
      columnsFor: (w) => w >= 980 ? 4 : (w >= 560 ? 2 : 1),
      children: [
        KpiCard(
          label: 'Total Students',
          value: Fmt.number(students.length),
          icon: Icons.groups_2_outlined,
          color: AppColors.primary,
          delta: const DeltaBadge(value: 3.2),
          caption: 'vs last session',
          segments: [
            (boys.toDouble(), AppColors.primary),
            (girls.toDouble(), AppColors.secondary),
          ],
          footerLabel:
              '$boys boys · $girls girls · ${schoolClasses.length} sections',
          onTap: () => context.go(Routes.students),
        ),
        KpiCard(
          label: 'Collected This Month',
          value: Fmt.rupee(fee.collectedMtd),
          icon: Icons.account_balance_wallet_outlined,
          color: AppColors.success,
          delta: DeltaBadge(value: fee.deltaPct),
          caption: 'vs ${Fmt.month(lastMonth)}, same period',
          segments: [
            (fee.monthProgress, AppColors.success),
            (1 - fee.monthProgress, AppColors.neutralBg),
          ],
          footerLabel:
              '${(fee.monthProgress * 100).round()}% of ${Fmt.rupeeCompact(fee.monthlyDemand)} billed this month',
          onTap: () => context.go(Routes.fees),
        ),
        KpiCard(
          label: 'Fees Pending',
          value: Fmt.rupee(fee.pending),
          icon: Icons.pending_actions_outlined,
          color: AppColors.danger,
          delta: const DeltaBadge(value: -4.6, positiveIsGood: false),
          caption: 'vs last month',
          segments: [
            (fee.overdueAmount.toDouble(), AppColors.danger),
            (fee.dueThisWeekAmount.toDouble(), AppColors.warning),
          ],
          footerLabel:
              '${fee.overdue.length} defaulters · ${fee.dueThisWeek.length} due this week',
          onTap: () => context.go('${Routes.fees}?tab=defaulters'),
        ),
        KpiCard(
          label: 'Attendance Today',
          value: Fmt.percent(att.pct),
          icon: Icons.how_to_reg_outlined,
          color: AppColors.secondary,
          delta: DeltaBadge(value: att.pct - yesterdayAttendancePct),
          caption: 'vs yesterday',
          segments: [
            (att.present.toDouble(), AppColors.success),
            (att.late.toDouble(), AppColors.warning),
            (att.absent.toDouble(), AppColors.danger),
          ],
          footerLabel:
              '${att.attended} of ${att.total} present · ${att.absent} absent',
          onTap: () => context.go(Routes.attendance),
        ),
      ],
    );
  }
}
