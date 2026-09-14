import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../models/attendance.dart';
import '../../theme/tokens.dart';
import '../../utils/formatters.dart';

class AttendanceDonut extends StatelessWidget {
  const AttendanceDonut({super.key, required this.summary, this.size = 180});

  final AttendanceSummary summary;
  final double size;

  @override
  Widget build(BuildContext context) {
    final ring = size * 0.14;
    final sections = [
      (summary.present, AppColors.success),
      (summary.late, AppColors.warning),
      (summary.absent, AppColors.danger),
    ];
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            duration: const Duration(milliseconds: 400),
            PieChartData(
              startDegreeOffset: -90,
              sectionsSpace: 2.5,
              centerSpaceRadius: size / 2 - ring,
              sections: [
                for (final (value, color) in sections)
                  if (value > 0)
                    PieChartSectionData(
                      value: value.toDouble(),
                      color: color,
                      radius: ring,
                      showTitle: false,
                    ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(Fmt.percent(summary.pct),
                  style: AppText.kpi.copyWith(fontSize: size * 0.14)),
              const SizedBox(height: 2),
              Text('present', style: AppText.caption),
            ],
          ),
        ],
      ),
    );
  }
}
