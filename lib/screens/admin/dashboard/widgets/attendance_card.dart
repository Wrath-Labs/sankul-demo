import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/demo_clock.dart';
import '../../../../data/activity.dart';
import '../../../../providers/attendance_provider.dart';
import '../../../../router/routes.dart';
import '../../../../theme/tokens.dart';
import '../../../../utils/formatters.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/charts/attendance_donut.dart';
import '../../../../widgets/common.dart';

class AttendanceCard extends ConsumerWidget {
  const AttendanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = ref.watch(schoolAttendanceProvider);

    Widget row(String label, int count, Color color) => Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: AppText.bodySm),
        const Spacer(),
        Text(
          '$count',
          style: AppText.number.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 44,
          child: Text(
            Fmt.percent(a.total == 0 ? 0 : count / a.total * 100),
            style: AppText.caption,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );

    return AppCard(
      title: 'Attendance Today',
      subtitle: Fmt.weekdayDate(DemoClock.today),
      trailing: TextButton(
        onPressed: () => context.go(Routes.attendance),
        child: const Text('Register'),
      ),
      expand: true,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                AttendanceDonut(summary: a, size: 168),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      row('Present', a.present, AppColors.success),
                      const Divider(height: 22),
                      row('Late', a.late, AppColors.warning),
                      const Divider(height: 22),
                      row('Absent', a.absent, AppColors.danger),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          InfoStrip(
            icon: Icons.sms_outlined,
            color: AppColors.primary,
            text:
                'Absence alerts sent to ${a.absent} parents at ${Fmt.time(absenceAlertTime)}',
          ),
        ],
      ),
    );
  }
}
