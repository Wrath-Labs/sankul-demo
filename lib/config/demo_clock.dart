/// Seed data is anchored to the moment the app starts, so "today",
/// "2 mins ago", "due in 3 days" and the academic session always look
/// current whenever the demo is opened.
class DemoClock {
  DemoClock._();

  static final DateTime now = DateTime.now();

  static DateTime get today => DateTime(now.year, now.month, now.day);

  static DateTime minutesAgo(int minutes) =>
      now.subtract(Duration(minutes: minutes));

  static DateTime todayAt(int hour, int minute) =>
      DateTime(now.year, now.month, now.day, hour, minute);

  /// "Now" clamped into school hours, so seeded events (fee counter, marks
  /// uploads) look like they happened during the school day even when the
  /// demo is opened early in the morning or late in the evening.
  static DateTime get schoolNow {
    final open = todayAt(9, 30);
    final close = todayAt(15, 30);
    if (now.isBefore(open)) return open;
    if (now.isAfter(close)) return close;
    return now;
  }

  static DateTime schoolMinutesAgo(int minutes) =>
      schoolNow.subtract(Duration(minutes: minutes));

  static DateTime daysAgo(int days, {int hour = 10, int minute = 0}) {
    final d = today.subtract(Duration(days: days));
    return DateTime(d.year, d.month, d.day, hour, minute);
  }

  static DateTime daysFromNow(int days) => today.add(Duration(days: days));

  /// The next [weekday] strictly after today (DateTime.monday … sunday).
  static DateTime nextWeekday(int weekday) {
    var d = today.add(const Duration(days: 1));
    while (d.weekday != weekday) {
      d = d.add(const Duration(days: 1));
    }
    return d;
  }

  /// Indian academic sessions start on 1 April.
  static DateTime get sessionStart =>
      DateTime(now.month >= 4 ? now.year : now.year - 1, 4, 1);

  /// "2026–27"
  static String get sessionLabel =>
      '${sessionStart.year}–${(sessionStart.year + 1) % 100}';

  /// "26-27", used inside receipt numbers.
  static String get sessionCode =>
      '${sessionStart.year % 100}-${(sessionStart.year + 1) % 100}';

  /// Months billed so far this session, including the current month.
  static int get monthsElapsed =>
      (now.year - sessionStart.year) * 12 + now.month - sessionStart.month + 1;

  /// First day of each of the last [count] months, oldest first, ending with
  /// the current month.
  static List<DateTime> lastMonths(int count) => [
        for (var i = count - 1; i >= 0; i--) DateTime(now.year, now.month - i),
      ];

  static String get greeting {
    final h = now.hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }
}
