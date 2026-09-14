import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'app_card.dart';
import 'common.dart';

/// Headline metric card: label, big value, trend and a segment-bar footer.
class KpiCard extends StatelessWidget {
  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.footerLabel,
    required this.segments,
    this.delta,
    this.caption,
    this.valueColor,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Widget? delta;
  final String? caption;
  final Color? valueColor;
  final String footerLabel;
  final List<(double, Color)> segments;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: AppText.label)),
              IconBadge(icon: icon, color: color, size: 34),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value,
                style: AppText.kpi.copyWith(color: valueColor)),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (delta != null) ...[delta!, const SizedBox(width: 8)],
              if (caption != null)
                Expanded(
                  child: Text(caption!,
                      style: AppText.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SegmentBar(segments: segments),
          const SizedBox(height: 8),
          Text(footerLabel,
              style: AppText.caption.copyWith(color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
