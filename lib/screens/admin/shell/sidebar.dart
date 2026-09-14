import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/branding.dart';
import '../../../config/demo_clock.dart';
import '../../../providers/fee_provider.dart';
import '../../../providers/session_provider.dart';
import '../../../router/routes.dart';
import '../../../theme/tokens.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/common.dart';
import '../admin_nav.dart';
import 'top_bar.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key, required this.location, this.inDrawer = false});

  static const double width = 252;

  final String location;
  final bool inDrawer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bg = AppColors.primaryDeep;
    final fg = ThemeData.estimateBrightnessForColor(bg) == Brightness.dark
        ? Colors.white
        : AppColors.textPrimary;
    final defaulters =
        ref.watch(feeSummaryProvider.select((s) => s.overdue.length));

    return Container(
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [bg, Color.lerp(bg, Colors.black, 0.22)!],
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: kTopBarHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  const SchoolLogo(size: 38, onDark: true),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Branding.schoolName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: fg,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Session ${DemoClock.sessionLabel}',
                          style: TextStyle(
                              color: fg.withValues(alpha: 0.6), fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: fg.withValues(alpha: 0.08)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              children: [
                for (final section in adminNav) ...[
                  if (section.title != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 18, 12, 8),
                      child: Text(
                        section.title!.toUpperCase(),
                        style: AppText.overline
                            .copyWith(color: fg.withValues(alpha: 0.45)),
                      ),
                    ),
                  for (final item in section.items)
                    _NavTile(
                      item: item,
                      fg: fg,
                      selected: location.startsWith(item.path),
                      badge: item.path == Routes.fees && defaulters > 0
                          ? '$defaulters'
                          : null,
                      onTap: () {
                        if (inDrawer) Navigator.of(context).pop();
                        context.go(item.path);
                      },
                    ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: _UserCard(fg: fg),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatefulWidget {
  const _NavTile({
    required this.item,
    required this.fg,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final NavItem item;
  final Color fg;
  final bool selected;
  final VoidCallback onTap;
  final String? badge;

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final fg = widget.fg;
    final selected = widget.selected;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            height: 42,
            decoration: BoxDecoration(
              color: selected
                  ? fg.withValues(alpha: 0.13)
                  : _hover
                      ? fg.withValues(alpha: 0.06)
                      : Colors.transparent,
              borderRadius: AppRadius.mdAll,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  width: 3,
                  height: 18,
                  margin: const EdgeInsets.only(right: 11),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.accent : Colors.transparent,
                    borderRadius: AppRadius.pill,
                  ),
                ),
                Icon(widget.item.icon,
                    size: 19, color: fg.withValues(alpha: selected ? 1 : 0.7)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: fg.withValues(alpha: selected ? 1 : 0.78),
                      fontSize: 13.5,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
                if (widget.badge != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: const BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: AppRadius.pill,
                    ),
                    child: Text(
                      widget.badge!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserCard extends ConsumerWidget {
  const _UserCard({required this.fg});

  final Color fg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionProvider);
    final onAccent =
        ThemeData.estimateBrightnessForColor(AppColors.accent) == Brightness.dark
            ? Colors.white
            : const Color(0xFF1F2937);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
      decoration: BoxDecoration(
        color: fg.withValues(alpha: 0.07),
        borderRadius: AppRadius.lgAll,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: AppColors.accent, shape: BoxShape.circle),
                child: Text(
                  Fmt.initials(user.name),
                  style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: onAccent),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.formalName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: fg,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                    Text(user.title,
                        style: TextStyle(
                            color: fg.withValues(alpha: 0.6), fontSize: 11.5)),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Switch role',
                onPressed: () => context.go(Routes.login),
                icon: Icon(Icons.swap_horiz_rounded,
                    size: 20, color: fg.withValues(alpha: 0.7)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                    color: AppColors.accent, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Text(
                'DEMO MODE · SAMPLE DATA',
                style: AppText.overline.copyWith(
                    color: fg.withValues(alpha: 0.5), fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
