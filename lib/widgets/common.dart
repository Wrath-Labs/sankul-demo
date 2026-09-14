import 'package:flutter/material.dart';

import '../config/brand_assets.dart';
import '../config/branding.dart';
import '../models/attendance.dart';
import '../models/fee.dart';
import '../theme/tokens.dart';
import '../utils/formatters.dart';

// ── Icon badge ────────────────────────────────────────────────────────────

class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 40,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(icon, color: color, size: size * 0.5),
    );
  }
}

// ── Status chip ───────────────────────────────────────────────────────────

enum StatusTone { success, warning, danger, info, neutral }

(Color bg, Color fg) toneColors(StatusTone tone) => switch (tone) {
      StatusTone.success => (AppColors.successBg, AppColors.successFg),
      StatusTone.warning => (AppColors.warningBg, AppColors.warningFg),
      StatusTone.danger => (AppColors.dangerBg, AppColors.dangerFg),
      StatusTone.info => (AppColors.infoBg, AppColors.infoFg),
      StatusTone.neutral => (AppColors.neutralBg, AppColors.neutralFg),
    };

class StatusChip extends StatelessWidget {
  const StatusChip(
    this.label, {
    super.key,
    this.tone = StatusTone.neutral,
    this.icon,
    this.dot = false,
  });

  factory StatusChip.fee(FeeStatus status) => switch (status) {
        FeeStatus.paid =>
          const StatusChip('Paid', tone: StatusTone.success, dot: true),
        FeeStatus.partial =>
          const StatusChip('Partial', tone: StatusTone.warning, dot: true),
        FeeStatus.overdue =>
          const StatusChip('Overdue', tone: StatusTone.danger, dot: true),
      };

  factory StatusChip.attendance(AttendanceStatus status) => StatusChip(
        status.label,
        dot: true,
        tone: switch (status) {
          AttendanceStatus.present => StatusTone.success,
          AttendanceStatus.late => StatusTone.warning,
          AttendanceStatus.absent => StatusTone.danger,
          AttendanceStatus.leave => StatusTone.info,
        },
      );

  final String label;
  final StatusTone tone;
  final IconData? icon;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = toneColors(tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.pill),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
          ],
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(label,
              style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: fg,
                  height: 1.3)),
        ],
      ),
    );
  }
}

// ── Delta badge (↑ 8.4%) ──────────────────────────────────────────────────

class DeltaBadge extends StatelessWidget {
  const DeltaBadge({
    super.key,
    required this.value,
    this.suffix = '%',
    this.positiveIsGood = true,
  });

  final double value;
  final String suffix;
  final bool positiveIsGood;

  @override
  Widget build(BuildContext context) {
    final up = value >= 0;
    final good = up == positiveIsGood;
    final fg = good ? AppColors.successFg : AppColors.dangerFg;
    final bg = good ? AppColors.successBg : AppColors.dangerBg;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.pill),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(up ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              size: 12, color: fg),
          const SizedBox(width: 2),
          Text(
            '${value.abs().toStringAsFixed(1)}$suffix',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: fg,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

// ── School logo / monogram ────────────────────────────────────────────────

/// The school's logo from [Branding.logoAsset], or a monogram of its
/// initials in the brand colours when no logo file exists.
class SchoolLogo extends StatelessWidget {
  const SchoolLogo({super.key, this.size = 40, this.onDark = false});

  final double size;

  /// Use a white tile so the mark stands out on the dark sidebar.
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(size * 0.26);
    if (BrandAssets.hasLogo) {
      return Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(onDark ? size * 0.1 : 0),
        decoration: BoxDecoration(
            color: onDark ? Colors.white : null, borderRadius: radius),
        child: ClipRRect(
          borderRadius: radius,
          child: Image.asset(Branding.logoAsset, fit: BoxFit.contain),
        ),
      );
    }
    final initials = Branding.initials;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: radius,
        color: onDark ? Colors.white : null,
        gradient: onDark
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  Color.lerp(AppColors.primary, AppColors.secondary, 0.55)!,
                ],
              ),
        boxShadow: onDark
            ? null
            : [
                BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: size * 0.3,
                    offset: Offset(0, size * 0.08)),
              ],
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: onDark ? AppColors.primary : Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: size * (initials.length > 2 ? 0.32 : 0.4),
          letterSpacing: 0.5,
          height: 1,
        ),
      ),
    );
  }
}

// ── Initials avatar ───────────────────────────────────────────────────────

class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar(this.name, {super.key, this.size = 36});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.avatarPalette;
    final color =
        palette[name.codeUnits.fold(0, (a, b) => a + b) % palette.length];
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        shape: BoxShape.circle,
      ),
      child: Text(
        Fmt.initials(name),
        style: TextStyle(
          color: color,
          fontSize: size * 0.36,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}

// ── Small building blocks ─────────────────────────────────────────────────

class LegendDot extends StatelessWidget {
  const LegendDot({super.key, required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppText.caption.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}

class InfoStrip extends StatelessWidget {
  const InfoStrip({
    super.key,
    required this.icon,
    required this.text,
    this.color = AppColors.textSecondary,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadius.mdAll,
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: AppText.bodySm.copyWith(fontSize: 12.5),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

/// A thin horizontal bar split into coloured segments.
class SegmentBar extends StatelessWidget {
  const SegmentBar({super.key, required this.segments, this.height = 6});

  final List<(double value, Color color)> segments;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.pill,
      child: Container(
        height: height,
        color: AppColors.neutralBg,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (value, color) in segments)
              if (value > 0)
                Expanded(
                  flex: (value * 1000).round().clamp(1, 1 << 30),
                  child: ColoredBox(color: color),
                ),
          ],
        ),
      ),
    );
  }
}

/// Fades the bottom edge of a scrolling list so a partly visible row reads
/// as "more below" rather than as clipped content.
class FadeBottom extends StatelessWidget {
  const FadeBottom({super.key, required this.child, this.extent = 32});

  final Widget child;
  final double extent;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [Colors.black, Colors.black, Colors.transparent],
        stops: [0, (1 - extent / rect.height).clamp(0.0, 1.0), 1],
      ).createShader(rect),
      child: child,
    );
  }
}

/// Compact segmented control used for view toggles on cards.
class SegmentedToggle<T> extends StatelessWidget {
  const SegmentedToggle({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final T value;
  final List<(T value, String label)> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        color: AppColors.neutralBg,
        borderRadius: AppRadius.mdAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (v, label) in options)
            GestureDetector(
              onTap: () => onChanged(v),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: v == value ? AppColors.surface : Colors.transparent,
                    borderRadius: BorderRadius.circular(7),
                    boxShadow: v == value ? AppShadows.card : null,
                  ),
                  child: Text(
                    label,
                    style: AppText.label.copyWith(
                      color: v == value
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Shows a floating confirmation snackbar with a leading icon.
void showAppSnack(
  BuildContext context,
  String message, {
  IconData icon = Icons.check_circle_rounded,
  Color iconColor = const Color(0xFF4ADE80),
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      duration: const Duration(seconds: 4),
      content: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
    ));
}
