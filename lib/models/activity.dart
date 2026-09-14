enum ActivityType { feePaid, admission, announcement, attendance, message, exam }

class ActivityItem {
  const ActivityItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  final ActivityType type;
  final String title;
  final String subtitle;
  final DateTime time;
}
