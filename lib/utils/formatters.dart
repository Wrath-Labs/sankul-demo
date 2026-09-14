import 'package:intl/intl.dart';

/// Indian-locale formatting: ₹1,24,500 (lakh grouping), DD/MM/YYYY dates.
class Fmt {
  Fmt._();

  static final NumberFormat _rupee =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
  static final NumberFormat _number = NumberFormat.decimalPattern('en_IN');
  static final DateFormat _date = DateFormat('dd/MM/yyyy');
  static final DateFormat _time = DateFormat('hh:mm a');

  static String rupee(num v) => _rupee.format(v);
  static String number(num v) => _number.format(v);

  /// ₹10.48 L, ₹1.2 Cr, ₹48.5K — for chart axes and compact tiles.
  static String rupeeCompact(num v) {
    final a = v.abs();
    if (a >= 1e7) return '₹${_trim(v / 1e7, 2)} Cr';
    if (a >= 1e5) return '₹${_trim(v / 1e5, 2)} L';
    if (a >= 1e3) return '₹${_trim(v / 1e3, 1)}K';
    return rupee(v);
  }

  static String _trim(num v, int digits) {
    var s = v.toStringAsFixed(digits);
    if (s.contains('.')) {
      s = s.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
    }
    return s;
  }

  static String date(DateTime d) => _date.format(d);
  static String time(DateTime d) => _time.format(d);
  static String dateTime(DateTime d) => '${date(d)}, ${time(d)}';
  static String weekdayDate(DateTime d) =>
      DateFormat('EEEE, d MMMM yyyy').format(d);
  static String shortWeekdayDate(DateTime d) =>
      DateFormat('EEE, d MMM yyyy').format(d);
  static String dayMonth(DateTime d) => DateFormat('d MMM').format(d);
  static String weekday(DateTime d) => DateFormat('EEEE').format(d);
  static String month(DateTime d) => DateFormat('MMM').format(d);
  static String monthYear(DateTime d) => DateFormat('MMMM yyyy').format(d);

  static String relative(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) {
      return diff.inMinutes == 1 ? '1 min ago' : '${diff.inMinutes} mins ago';
    }
    final days = DateTime(now.year, now.month, now.day)
        .difference(DateTime(t.year, t.month, t.day))
        .inDays;
    if (days == 0) return diff.inHours == 1 ? '1 hr ago' : '${diff.inHours} hrs ago';
    if (days == 1) return 'Yesterday, ${time(t)}';
    if (days < 7) return '$days days ago';
    return date(t);
  }

  static String percent(num v, {int digits = 1}) =>
      '${v.toStringAsFixed(digits)}%';

  static String ordinal(int n) {
    if (n % 100 >= 11 && n % 100 <= 13) return '${n}th';
    return switch (n % 10) {
      1 => '${n}st',
      2 => '${n}nd',
      3 => '${n}rd',
      _ => '${n}th',
    };
  }

  /// "Mrs. Kavita Saxena" → "KS"
  static String initials(String name) {
    const honorifics = {'mr.', 'mrs.', 'ms.', 'dr.', 'mr', 'mrs', 'ms', 'dr'};
    final parts = name
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty && !honorifics.contains(p.toLowerCase()))
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  // ── Amount in words (Indian numbering: thousand, lakh, crore) ───────────
  static const _ones = [
    '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine',
    'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen',
    'Seventeen', 'Eighteen', 'Nineteen',
  ];
  static const _tens = [
    '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy',
    'Eighty', 'Ninety',
  ];

  static String _below100(int n) => n < 20
      ? _ones[n]
      : '${_tens[n ~/ 10]}${n % 10 > 0 ? ' ${_ones[n % 10]}' : ''}';

  static String _below1000(int n) {
    final h = n ~/ 100, r = n % 100;
    return [if (h > 0) '${_ones[h]} Hundred', if (r > 0) _below100(r)]
        .join(' ');
  }

  /// 12500 → "Rupees Twelve Thousand Five Hundred Only"
  static String amountInWords(int amount) {
    if (amount <= 0) return 'Rupees Zero Only';
    final crore = amount ~/ 10000000;
    final lakh = (amount ~/ 100000) % 100;
    final thousand = (amount ~/ 1000) % 100;
    final rest = amount % 1000;
    final parts = [
      if (crore > 0) '${_below1000(crore)} Crore',
      if (lakh > 0) '${_below100(lakh)} Lakh',
      if (thousand > 0) '${_below100(thousand)} Thousand',
      if (rest > 0) _below1000(rest),
    ];
    return 'Rupees ${parts.join(' ')} Only';
  }

  /// "+91 98370 45612" → "+91 98370 •••12"
  static String maskPhone(String phone) {
    if (phone.length < 4) return phone;
    return '${phone.substring(0, phone.length - 5)}•••${phone.substring(phone.length - 2)}';
  }
}
