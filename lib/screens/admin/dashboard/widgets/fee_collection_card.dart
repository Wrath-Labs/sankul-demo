import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/fee_provider.dart';
import '../../../../theme/tokens.dart';
import '../../../../utils/formatters.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/charts/fee_collection_chart.dart';
import '../../../../widgets/common.dart';

class FeeCollectionCard extends ConsumerStatefulWidget {
  const FeeCollectionCard({super.key});

  @override
  ConsumerState<FeeCollectionCard> createState() => _FeeCollectionCardState();
}

class _FeeCollectionCardState extends ConsumerState<FeeCollectionCard> {
  FeeChartMode _mode = FeeChartMode.monthly;

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(feeSummaryProvider);
    final monthly = _mode == FeeChartMode.monthly;
    return AppCard(
      title: 'Fee Collection',
      subtitle: monthly
          ? 'Collected vs billed · last 6 months'
          : 'Collected vs billed this month, by class',
      trailing: SegmentedToggle<FeeChartMode>(
        value: _mode,
        options: const [
          (FeeChartMode.monthly, 'Monthly'),
          (FeeChartMode.byClass, 'By class'),
        ],
        onChanged: (m) => setState(() => _mode = m),
      ),
      expand: true,
      child: Column(
        children: [
          Expanded(child: FeeCollectionChart(mode: _mode)),
          const SizedBox(height: 12),
          Row(
            children: [
              const LegendDot(color: AppColors.primary, label: 'Collected'),
              const SizedBox(width: 16),
              LegendDot(
                color: AppColors.tint(AppColors.primary, 0.14),
                label: 'Billed',
              ),
              if (monthly) ...[
                const SizedBox(width: 16),
                const LegendDot(
                  color: AppColors.secondary,
                  label: 'This month so far',
                ),
              ],
              const Spacer(),
              Flexible(
                child: Text(
                  'Today: ${Fmt.rupee(s.todayTotal)} · ${s.todayCount} receipts',
                  style: AppText.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
