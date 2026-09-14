import 'package:flutter/material.dart';

/// ───────────────────────────────────────────────────────────────────────────
///  WHITE-LABEL CONFIGURATION
///
///  Every school-specific value in the app is read from this one file: the
///  login screen, sidebar, top bar, PDF letterheads (receipts and report
///  cards), receipt and admission numbers, SMS templates and staff e-mails.
///
///  To rebrand for a new school, edit the values below and hot-restart.
///  Nothing else in the codebase names a school or hardcodes a brand colour.
/// ───────────────────────────────────────────────────────────────────────────
class Branding {
  Branding._();

  // ── Identity ────────────────────────────────────────────────────────────
  static const String productName = 'Sankul';
  static const String schoolName = 'Sunrise Public School';
  static const String schoolTagline = 'Excellence in Education • Est. 1998';
  static const String schoolAddress = 'Sikandra, Agra, Uttar Pradesh 282007';
  static const String schoolPhone = '+91 98370 12345';
  static const String schoolEmail = 'office@sunrisepublic.edu.in';

  /// Drop a square PNG at this path to use a real logo. If the file is
  /// missing, a monogram of the school's initials is drawn instead.
  static const String logoAsset = 'assets/logo.png';

  // ── Colours ─────────────────────────────────────────────────────────────
  static const Color primaryColor = Color(0xFF1E3A8A);
  static const Color secondaryColor = Color(0xFF0EA5E9);
  static const Color accentColor = Color(0xFFF59E0B);

  // ── Documents (report cards, receipts, admission numbers) ───────────────
  /// Prefix for admission numbers (SPS/2019/0142) and receipts.
  static const String schoolCode = 'SPS';
  static const String board = 'CBSE';
  static const String affiliationNo = '2132457';
  static const String principalName = 'Dr. Meenakshi Agarwal';

  // ── Derived — no need to edit ───────────────────────────────────────────
  /// Monogram used when there is no logo asset: "Sunrise Public School" → "SPS".
  static String get initials {
    const skip = {'of', 'the', 'and', '&'};
    final letters = schoolName
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty && !skip.contains(w.toLowerCase()))
        .map((w) => w[0].toUpperCase())
        .take(3)
        .join();
    return letters.isEmpty ? '?' : letters;
  }

  /// Domain used for staff e-mail addresses, taken from [schoolEmail].
  static String get emailDomain => schoolEmail.split('@').last;
}
