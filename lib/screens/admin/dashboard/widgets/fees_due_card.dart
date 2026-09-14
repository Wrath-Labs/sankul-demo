import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/demo_clock.dart';
import '../../../../data/students.dart';
import '../../../../models/communication.dart';
import '../../../../models/student.dart';
import '../../../../providers/communication_provider.dart';
import '../../../../providers/fee_provider.dart';
import '../../../../router/routes.dart';
import '../../../../theme/tokens.dart';
import '../../../../utils/formatters.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/common.dart';

class FeesDueCard extends ConsumerStatefulWidget {
  const FeesDueCard({super.key});

  @override
  ConsumerState<FeesDueCard> createState() => _FeesDueCardState();
}

class _FeesDueCardState extends ConsumerState<FeesDueCard> {
  final _reminded = <String>{};

  void _remind(Student s) {
    ref.read(communicationProvider.notifier).logMessages([
      parentMessage(s, Channel.whatsapp, 'Fee Reminder'),
    ]);
    setState(() => _reminded.add(s.id));
    showAppSnack(
      context,
      'Fee reminder sent to Mr. ${s.fatherName} on WhatsApp',
    );
  }

  @override
  Widget build(BuildContext context) {
    final fee = ref.watch(feeSummaryProvider);
    final due = fee.dueThisWeek;
    return AppCard(
      title: 'Fees Due This Week',
      subtitle: '${due.length} students · ${Fmt.rupee(fee.dueThisWeekAmount)}',
      trailing: TextButton(
        onPressed: () => context.go(Routes.fees),
        child: const Text('View all'),
      ),
      expand: true,
      child: FadeBottom(
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: math.min(due.length, 12),
          separatorBuilder: (_, _) => const Divider(height: 18),
          itemBuilder: (_, i) {
            final account = due[i];
            final s = studentById[account.studentId]!;
            final days = account.dueDate!.difference(DemoClock.today).inDays;
            final dueLabel = days <= 0
                ? 'Due today'
                : days == 1
                ? 'Due tomorrow'
                : 'Due in $days days';
            final reminded = _reminded.contains(s.id);
            return Row(
              children: [
                InitialsAvatar(s.name, size: 34),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.name,
                        style: AppText.title.copyWith(fontSize: 13.5),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Class ${s.classId} · $dueLabel',
                        style: AppText.caption.copyWith(
                          color: days <= 2
                              ? AppColors.warningFg
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  Fmt.rupee(account.balance),
                  style: AppText.number.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 2),
                IconButton(
                  tooltip: reminded ? 'Reminder sent' : 'Send reminder',
                  visualDensity: VisualDensity.compact,
                  onPressed: reminded ? null : () => _remind(s),
                  icon: Icon(
                    reminded
                        ? Icons.check_circle_rounded
                        : Icons.notifications_active_outlined,
                    size: 18,
                    color: reminded ? AppColors.success : AppColors.textMuted,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
