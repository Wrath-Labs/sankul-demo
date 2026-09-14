import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/demo_clock.dart';
import '../../data/classes.dart';
import '../../data/fees.dart';
import '../../providers/fee_provider.dart';
import '../../theme/tokens.dart';
import '../../utils/formatters.dart';

enum FeeChartMode { monthly, byClass }

/// Collected-vs-billed bars, either for the last six months or per class
/// for the current month. Each bar sits on a faint "billed" background.
class FeeCollectionChart extends ConsumerWidget {
  const FeeCollectionChart({super.key, required this.mode});

  final FeeChartMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(feeSummaryProvider);
    return mode == FeeChartMode.monthly ? _monthly(s) : _byClass(s);
  }

  Widget _monthly(FeeSummary s) {
    final months = DemoClock.lastMonths(6);
    final collected = [...FeeSeed.previousMonthsCollected, s.collectedMtd];
    final billed = s.monthlyDemand / 1e5;
    final maxY = (billed / 5).ceil() * 5.0;
    return _chart(
      maxY: maxY,
      interval: 5,
      barWidth: 30,
      leftLabel: (v) => v == 0 ? '0' : '₹${v.toInt()}L',
      bottomLabel: (i) => Fmt.month(months[i]),
      bars: [
        for (var i = 0; i < 6; i++)
          (collected[i] / 1e5, billed, i == 5 ? AppColors.secondary : AppColors.primary),
      ],
      tooltip: (i) => (
        i == 5 ? '${Fmt.monthYear(months[i])} (so far)' : Fmt.monthYear(months[i]),
        'Collected ${Fmt.rupee(collected[i])}\nBilled ${Fmt.rupee(s.monthlyDemand)}',
      ),
    );
  }

  Widget _byClass(FeeSummary s) {
    final demand = FeeSeed.demandByGrade;
    final maxDemand = demand.values.reduce((a, b) => a > b ? a : b) / 1e5;
    final maxY = (maxDemand * 2).ceil() / 2 + 0.5;
    return _chart(
      maxY: maxY,
      interval: 0.5,
      barWidth: 16,
      leftLabel: (v) => v == 0 ? '0' : '₹${v.toStringAsFixed(1)}L',
      bottomLabel: (i) => gradeOrder[i] == 'Nursery' ? 'Nur' : gradeOrder[i],
      bars: [
        for (final g in gradeOrder)
          (s.collectedByGrade[g]! / 1e5, demand[g]! / 1e5, AppColors.primary),
      ],
      tooltip: (i) {
        final g = gradeOrder[i];
        return (
          g == 'Nursery' ? 'Nursery' : 'Class $g',
          'Collected ${Fmt.rupee(s.collectedByGrade[g]!)}\nBilled ${Fmt.rupee(demand[g]!)}',
        );
      },
    );
  }

  Widget _chart({
    required double maxY,
    required double interval,
    required double barWidth,
    required String Function(double) leftLabel,
    required String Function(int) bottomLabel,
    required List<(double value, double background, Color color)> bars,
    required (String, String) Function(int) tooltip,
  }) {
    final radius = BorderRadius.vertical(top: Radius.circular(barWidth / 4));
    return BarChart(
      duration: const Duration(milliseconds: 350),
      BarChartData(
        maxY: maxY,
        alignment: BarChartAlignment.spaceAround,
        barGroups: [
          for (var i = 0; i < bars.length; i++)
            BarChartGroupData(x: i, barRods: [
              BarChartRodData(
                toY: bars[i].$1,
                color: bars[i].$3,
                width: barWidth,
                borderRadius: radius,
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: bars[i].$2,
                  color: AppColors.tint(AppColors.primary, 0.1),
                ),
              ),
            ]),
        ],
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (_) => const FlLine(
            color: AppColors.border,
            strokeWidth: 1,
            dashArray: [4, 4],
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 46,
              interval: interval,
              getTitlesWidget: (v, meta) => SideTitleWidget(
                meta: meta,
                child: Text(leftLabel(v), style: AppText.caption),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (v, meta) => SideTitleWidget(
                meta: meta,
                child: Text(bottomLabel(v.toInt()),
                    style: AppText.caption
                        .copyWith(color: AppColors.textSecondary)),
              ),
            ),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => AppColors.textPrimary,
            tooltipPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            tooltipMargin: 8,
            fitInsideVertically: true,
            fitInsideHorizontally: true,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final (title, body) = tooltip(group.x);
              return BarTooltipItem(
                '$title\n',
                const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                    fontFamily: AppText.family),
                textAlign: TextAlign.left,
                children: [
                  TextSpan(
                    text: body,
                    style: const TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        height: 1.5,
                        fontFamily: AppText.family),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
