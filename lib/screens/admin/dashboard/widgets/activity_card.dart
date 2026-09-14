import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/activity.dart';
import '../../../../providers/activity_provider.dart';
import '../../../../theme/tokens.dart';
import '../../../../utils/formatters.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/common.dart';

class ActivityCard extends ConsumerWidget {
  const ActivityCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(activityProvider);
    return AppCard(
      title: 'Recent Activity',
      subtitle: 'Fees, attendance & messages',
      trailing: const _LiveBadge(),
      expand: true,
      child: FadeBottom(
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: math.min(items.length, 12),
          separatorBuilder: (_, _) => const SizedBox(height: 14),
          itemBuilder: (_, i) => _ActivityTile(item: items[i]),
        ),
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: const BoxDecoration(
        color: AppColors.successBg,
        borderRadius: AppRadius.pill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            'Live',
            style: AppText.label.copyWith(color: AppColors.successFg),
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.item});

  final ActivityItem item;

  static (IconData, Color) _style(ActivityType type) => switch (type) {
    ActivityType.feePaid => (Icons.currency_rupee_rounded, AppColors.success),
    ActivityType.admission => (
      Icons.person_add_alt_1_outlined,
      AppColors.primary,
    ),
    ActivityType.announcement => (
      Icons.campaign_outlined,
      const Color(0xFF7C3AED),
    ),
    ActivityType.attendance => (Icons.fact_check_outlined, AppColors.secondary),
    ActivityType.message => (Icons.sms_outlined, AppColors.warning),
    ActivityType.exam => (Icons.edit_note_rounded, const Color(0xFF4F46E5)),
  };

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _style(item.type);
    final when = Fmt.relative(item.time);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconBadge(icon: icon, color: color, size: 34),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: AppText.title.copyWith(fontSize: 13.5),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                item.subtitle,
                style: AppText.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          when.startsWith('Yesterday') ? 'Yesterday' : when,
          style: AppText.caption.copyWith(fontSize: 11.5),
        ),
      ],
    );
  }
}
