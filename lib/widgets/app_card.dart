import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// The standard white card: soft shadow, rounded corners, optional header.
/// Pass [onTap] to make it interactive (lifts on hover).
class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.trailing,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
    this.onTap,
    this.expand = false,
    this.color,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  /// Let [child] fill the card's remaining height (card must be bounded).
  final bool expand;
  final Color? color;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final interactive = widget.onTap != null;
    final hovered = interactive && _hover;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (widget.title != null) ...[
          CardHeader(
            title: widget.title!,
            subtitle: widget.subtitle,
            trailing: widget.trailing,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        if (widget.expand) Expanded(child: widget.child) else widget.child,
      ],
    );

    return MouseRegion(
      onEnter: interactive ? (_) => setState(() => _hover = true) : null,
      onExit: interactive ? (_) => setState(() => _hover = false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, hovered ? -2 : 0, 0),
        decoration: BoxDecoration(
          color: widget.color ?? AppColors.surface,
          borderRadius: AppRadius.lgAll,
          border: Border.all(
            color: hovered
                ? AppColors.primary.withValues(alpha: 0.35)
                : AppColors.border,
          ),
          boxShadow: hovered ? AppShadows.raised : AppShadows.card,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: AppRadius.lgAll,
            mouseCursor:
                interactive ? SystemMouseCursors.click : MouseCursor.defer,
            child: Padding(padding: widget.padding, child: content),
          ),
        ),
      ),
    );
  }
}

class CardHeader extends StatelessWidget {
  const CardHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.h3),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!,
                    style: AppText.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}
