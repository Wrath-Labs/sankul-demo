import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Lays children out side by side with flex ratios, stacking them vertically
/// below [breakpoint]. Give a [height] when children need bounded height
/// (charts, scrolling lists).
class ResponsiveRow extends StatelessWidget {
  const ResponsiveRow({
    super.key,
    required this.children,
    this.flex,
    this.height,
    this.breakpoint = 900,
    this.gap = AppSpacing.xl,
  });

  final List<Widget> children;
  final List<int>? flex;
  final double? height;
  final double breakpoint;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      if (box.maxWidth < breakpoint) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) SizedBox(height: gap),
              if (height != null)
                SizedBox(height: height, child: children[i])
              else
                children[i],
            ],
          ],
        );
      }
      final row = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(width: gap),
            Expanded(flex: flex?[i] ?? 1, child: children[i]),
          ],
        ],
      );
      return height != null
          ? SizedBox(height: height, child: row)
          : IntrinsicHeight(child: row);
    });
  }
}

/// Splits [children] into rows of [columns] equal-width cells.
class EqualGrid extends StatelessWidget {
  const EqualGrid({
    super.key,
    required this.children,
    required this.columnsFor,
    this.gap = AppSpacing.xl,
  });

  final List<Widget> children;

  /// Number of columns for a given available width.
  final int Function(double width) columnsFor;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      final cols = columnsFor(box.maxWidth);
      final rows = <Widget>[];
      for (var i = 0; i < children.length; i += cols) {
        if (i > 0) rows.add(SizedBox(height: gap));
        // Cells in a row share the tallest cell's height.
        rows.add(IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var j = i; j < i + cols; j++) ...[
                if (j > i) SizedBox(width: gap),
                Expanded(
                    child: j < children.length
                        ? children[j]
                        : const SizedBox.shrink()),
              ],
            ],
          ),
        ));
      }
      return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, children: rows);
    });
  }
}
