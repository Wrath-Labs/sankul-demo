import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../router/routes.dart';
import '../../../../theme/tokens.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/common.dart';
import '../../../../widgets/responsive_row.dart';
import '../../fees/record_payment_dialog.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return EqualGrid(
      columnsFor: (w) => w >= 980 ? 4 : (w >= 560 ? 2 : 1),
      children: [
        _QuickAction(
          icon: Icons.receipt_long_outlined,
          color: AppColors.success,
          title: 'Record Payment',
          subtitle: 'Cash · UPI · Cheque',
          onTap: () => showRecordPaymentDialog(context),
        ),
        _QuickAction(
          icon: Icons.campaign_outlined,
          color: AppColors.primary,
          title: 'Send Announcement',
          subtitle: 'SMS · WhatsApp · App',
          onTap: () => context.go(Routes.communication),
        ),
        _QuickAction(
          icon: Icons.fact_check_outlined,
          color: AppColors.secondary,
          title: 'Mark Attendance',
          subtitle: 'Parents alerted instantly',
          onTap: () => context.go(Routes.attendance),
        ),
        _QuickAction(
          icon: Icons.workspace_premium_outlined,
          color: AppColors.accent,
          title: 'Generate Report Card',
          subtitle: 'Branded PDF, one click',
          onTap: () => context.go(Routes.exams),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          IconBadge(icon: icon, color: color, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppText.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
