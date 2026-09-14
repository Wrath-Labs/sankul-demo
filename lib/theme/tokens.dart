import 'package:flutter/material.dart';

import '../config/branding.dart';

/// Design tokens. Every spacing, radius, shadow, colour and text style in the
/// app comes from here so screens stay visually consistent.
class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// Outer padding of admin content pages.
  static const double page = 28;
}

class AppRadius {
  AppRadius._();
  static const double sm = 6;
  static const double md = 10;
  static const double lg = 14;
  static const double xl = 20;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
}

class AppShadows {
  AppShadows._();
  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x0A0F172A), blurRadius: 18, offset: Offset(0, 6)),
    BoxShadow(color: Color(0x060F172A), blurRadius: 2, offset: Offset(0, 1)),
  ];
  static const List<BoxShadow> raised = [
    BoxShadow(color: Color(0x140F172A), blurRadius: 32, offset: Offset(0, 12)),
    BoxShadow(color: Color(0x0A0F172A), blurRadius: 4, offset: Offset(0, 2)),
  ];
}

class AppColors {
  AppColors._();

  // Brand — always read through Branding so a rebrand flows everywhere.
  static const Color primary = Branding.primaryColor;
  static const Color secondary = Branding.secondaryColor;
  static const Color accent = Branding.accentColor;

  /// A darker shade of the primary colour for the sidebar and letterheads.
  static Color get primaryDeep => Color.lerp(primary, Colors.black, 0.28)!;

  /// Foreground that stays legible on top of the primary colour, even if a
  /// school picks a light brand colour.
  static Color get onPrimary =>
      ThemeData.estimateBrightnessForColor(primary) == Brightness.dark
          ? Colors.white
          : const Color(0xFF0F172A);

  static Color tint(Color c, double amount) =>
      Color.lerp(Colors.white, c, amount)!;

  // Neutrals
  static const Color background = Color(0xFFF4F6FA);
  static const Color surface = Colors.white;
  static const Color surfaceMuted = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE5E9F0);
  static const Color borderStrong = Color(0xFFD3DAE4);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF8A96A8);

  // Status
  static const Color success = Color(0xFF16A34A);
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color successFg = Color(0xFF15803D);
  static const Color warning = Color(0xFFD97706);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color warningFg = Color(0xFFB45309);
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerBg = Color(0xFFFEE2E2);
  static const Color dangerFg = Color(0xFFB91C1C);
  static const Color info = Color(0xFF2563EB);
  static const Color infoBg = Color(0xFFDBEAFE);
  static const Color infoFg = Color(0xFF1D4ED8);
  static const Color neutralBg = Color(0xFFF1F5F9);
  static const Color neutralFg = Color(0xFF475569);

  /// Soft palette for initials avatars and category icons.
  static const List<Color> avatarPalette = [
    Color(0xFF2563EB),
    Color(0xFF0891B2),
    Color(0xFF7C3AED),
    Color(0xFFDB2777),
    Color(0xFFEA580C),
    Color(0xFF16A34A),
    Color(0xFF4F46E5),
    Color(0xFF0D9488),
  ];
}

class AppText {
  AppText._();
  static const String family = 'Inter';
  static const List<FontFeature> _tabular = [FontFeature.tabularFigures()];

  static const TextStyle display = TextStyle(
      fontFamily: family,
      fontSize: 28,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.6,
      height: 1.2,
      color: AppColors.textPrimary);
  static const TextStyle h1 = TextStyle(
      fontFamily: family,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.4,
      height: 1.25,
      color: AppColors.textPrimary);
  static const TextStyle h2 = TextStyle(
      fontFamily: family,
      fontSize: 17,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
      height: 1.3,
      color: AppColors.textPrimary);
  static const TextStyle h3 = TextStyle(
      fontFamily: family,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1.35,
      color: AppColors.textPrimary);
  static const TextStyle title = TextStyle(
      fontFamily: family,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: AppColors.textPrimary);
  static const TextStyle body = TextStyle(
      fontFamily: family,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: AppColors.textPrimary);
  static const TextStyle bodySm = TextStyle(
      fontFamily: family,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 1.45,
      color: AppColors.textSecondary);
  static const TextStyle caption = TextStyle(
      fontFamily: family,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.4,
      color: AppColors.textMuted);
  static const TextStyle label = TextStyle(
      fontFamily: family,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: AppColors.textSecondary);
  static const TextStyle overline = TextStyle(
      fontFamily: family,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8,
      height: 1.3,
      color: AppColors.textMuted);
  static const TextStyle kpi = TextStyle(
      fontFamily: family,
      fontSize: 26,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.8,
      height: 1.15,
      color: AppColors.textPrimary,
      fontFeatures: _tabular);
  static const TextStyle number = TextStyle(
      fontFamily: family,
      fontSize: 13,
      fontWeight: FontWeight.w500,
      height: 1.4,
      color: AppColors.textPrimary,
      fontFeatures: _tabular);
}
