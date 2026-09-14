import 'package:flutter/material.dart';

import '../../../../config/demo_clock.dart';
import '../../../../data/communication.dart';
import '../../../../models/communication.dart';
import '../../../../theme/tokens.dart';
import '../../../../utils/formatters.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/common.dart';

Color categoryColor(AnnouncementCategory c) => switch (c) {
  AnnouncementCategory.academic => AppColors.primary,
  AnnouncementCategory.fee => AppColors.warning,
  AnnouncementCategory.event => const Color(0xFF7C3AED),
  AnnouncementCategory.holiday => AppColors.success,
};

class UpcomingCard extends StatelessWidget {
  const UpcomingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final events =
        seedEvents.where((e) => !e.date.isBefore(DemoClock.today)).toList()
          ..sort((a, b) => a.date.compareTo(b.date));
    return AppCard(
      title: 'Upcoming',
      subtitle: 'Events & deadlines',
      expand: true,
      child: FadeBottom(
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: events.length,
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemBuilder: (_, i) => _EventTile(event: events[i]),
        ),
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event});

  final SchoolEvent event;

  @override
  Widget build(BuildContext context) {
    final color = categoryColor(event.category);
    final days = event.date.difference(DemoClock.today).inDays;
    final when = days == 0
        ? 'Today'
        : days == 1
        ? 'Tomorrow'
        : 'In $days days · ${Fmt.weekday(event.date)}';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: AppRadius.mdAll,
          ),
          child: Column(
            children: [
              Text(
                '${event.date.day}',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: color,
                  height: 1.1,
                ),
              ),
              Text(
                Fmt.month(event.date).toUpperCase(),
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: color,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.title, style: AppText.title.copyWith(fontSize: 13.5)),
              const SizedBox(height: 2),
              Text(
                event.detail,
                style: AppText.caption,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                when,
                style: AppText.caption.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
