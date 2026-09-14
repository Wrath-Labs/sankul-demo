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

const double kTopBarHeight = 68;

class TopBar extends StatelessWidget {
  const TopBar({super.key, required this.title, this.onMenu});

  final String title;
  final VoidCallback? onMenu;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      height: kTopBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (onMenu != null) ...[
            IconButton(onPressed: onMenu, icon: const Icon(Icons.menu_rounded)),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppText.h2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(
                  '${Branding.schoolName} · ${Branding.board} Affiliation No. ${Branding.affiliationNo}',
                  style: AppText.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (width >= 1280) ...[const _SearchBox(), const SizedBox(width: 12)],
          if (width >= 820) ...[const _DateChip(), const SizedBox(width: 4)],
          const _NotificationBell(),
          Container(
            width: 1,
            height: 28,
            color: AppColors.border,
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
          _AccountMenu(compact: width < 900),
        ],
      ),
    );
  }
}

class _SearchBox extends StatefulWidget {
  const _SearchBox();

  @override
  State<_SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<_SearchBox> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderRadius: AppRadius.mdAll,
      borderSide: BorderSide(color: AppColors.border),
    );
    return SizedBox(
      width: 240,
      child: TextField(
        controller: _controller,
        style: AppText.bodySm.copyWith(color: AppColors.textPrimary),
        onSubmitted: (q) {
          if (q.trim().isEmpty) return;
          context.go('${Routes.students}?q=${Uri.encodeQueryComponent(q.trim())}');
          _controller.clear();
        },
        decoration: const InputDecoration(
          hintText: 'Search students…',
          prefixIcon: Icon(Icons.search_rounded, size: 18),
          fillColor: AppColors.surfaceMuted,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: border,
          enabledBorder: border,
        ),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_today_outlined,
              size: 14, color: AppColors.textMuted),
          const SizedBox(width: 6),
          Text(
            Fmt.shortWeekdayDate(DemoClock.today),
            style: AppText.bodySm.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _NotificationBell extends ConsumerWidget {
  const _NotificationBell();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fee = ref.watch(feeSummaryProvider);

    PopupMenuItem<String> item(String path, IconData icon, Color color,
            String title, String body, String time) =>
        PopupMenuItem<String>(
          value: path,
          height: 72,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBadge(icon: icon, color: color, size: 34),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.title),
                    const SizedBox(height: 2),
                    Text(body,
                        style: AppText.caption
                            .copyWith(color: AppColors.textSecondary),
                        maxLines: 2),
                    const SizedBox(height: 2),
                    Text(time, style: AppText.caption.copyWith(fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        );

    return PopupMenuButton<String>(
      tooltip: 'Notifications',
      offset: const Offset(0, 50),
      constraints: const BoxConstraints(minWidth: 360, maxWidth: 360),
      onSelected: (path) => context.go(path),
      itemBuilder: (_) => [
        const PopupMenuItem<String>(
          enabled: false,
          height: 40,
          child: Row(
            children: [
              Text('Notifications', style: AppText.h3),
              Spacer(),
              StatusChip('3 new', tone: StatusTone.info),
            ],
          ),
        ),
        const PopupMenuDivider(),
        item(
          Routes.fees,
          Icons.warning_amber_rounded,
          AppColors.danger,
          '${fee.overdue.length} fee defaulters',
          '${Fmt.rupee(fee.overdueAmount)} overdue — send reminders in one click',
          '12 mins ago',
        ),
        item(
          Routes.communication,
          Icons.sms_failed_outlined,
          AppColors.warning,
          'SMS not delivered',
          "Absence alert to Myra Jain's parent (V-B) — resent on WhatsApp",
          '23 mins ago',
        ),
        item(
          Routes.exams,
          Icons.workspace_premium_outlined,
          AppColors.primary,
          'Report cards ready',
          'Half-Yearly results for X-A, VIII-A and V-B are complete',
          '1 hr ago',
        ),
      ],
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: Badge(
          label: Text('3'),
          backgroundColor: AppColors.danger,
          child: Icon(Icons.notifications_outlined,
              color: AppColors.textSecondary, size: 22),
        ),
      ),
    );
  }
}

class _AccountMenu extends ConsumerWidget {
  const _AccountMenu({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionProvider);

    PopupMenuItem<String> item(String value, IconData icon, String label) =>
        PopupMenuItem<String>(
          value: value,
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Text(label, style: AppText.body),
            ],
          ),
        );

    return PopupMenuButton<String>(
      tooltip: 'Account',
      offset: const Offset(0, 54),
      onSelected: (v) {
        final session = ref.read(sessionProvider.notifier);
        switch (v) {
          case 'teacher':
            session.signIn(UserRole.teacher);
            context.go(Routes.teacher);
          case 'parent':
            session.signIn(UserRole.parent);
            context.go(Routes.parent);
          case 'logout':
            context.go(Routes.login);
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem<String>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name, style: AppText.title),
              Text(user.loginId, style: AppText.caption),
            ],
          ),
        ),
        const PopupMenuDivider(),
        item('teacher', Icons.co_present_outlined, 'Switch to Teacher view'),
        item('parent', Icons.phone_iphone_rounded, 'Open Parent app'),
        const PopupMenuDivider(),
        item('logout', Icons.logout_rounded, 'Sign out'),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InitialsAvatar(user.name, size: 36),
            if (!compact) ...[
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name,
                      style: AppText.title.copyWith(fontSize: 13)),
                  Text(user.title, style: AppText.caption),
                ],
              ),
            ],
            const SizedBox(width: 4),
            const Icon(Icons.expand_more_rounded,
                size: 18, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
