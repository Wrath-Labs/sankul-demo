import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/branding.dart';
import '../../data/classes.dart';
import '../../data/staff.dart';
import '../../providers/session_provider.dart';
import '../../router/routes.dart';
import '../../theme/tokens.dart';
import '../../widgets/common.dart';
import '../../widgets/powered_by.dart';

const _roles = [
  (UserRole.admin, Icons.admin_panel_settings_outlined, 'Principal / Admin', 'Complete school dashboard'),
  (UserRole.teacher, Icons.co_present_outlined, 'Teacher', 'Attendance, marks & timetable'),
  (UserRole.parent, Icons.family_restroom_rounded, 'Parent', 'The parent mobile app'),
];

/// Branded sign-in. No real authentication: the chosen role decides where
/// the demo goes, and any password is accepted.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  UserRole _role = UserRole.admin;
  late final _id =
      TextEditingController(text: SessionUser.forRole(UserRole.admin).loginId);
  final _password = TextEditingController(text: 'demo@1234');
  bool _obscure = true;
  bool _remember = true;
  bool _loading = false;

  @override
  void dispose() {
    _id.dispose();
    _password.dispose();
    super.dispose();
  }

  void _pick(UserRole role) => setState(() {
        _role = role;
        _id.text = SessionUser.forRole(role).loginId;
      });

  Future<void> _signIn() async {
    if (_loading) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    ref.read(sessionProvider.notifier).signIn(_role);
    context.go(switch (_role) {
      UserRole.admin => Routes.dashboard,
      UserRole.teacher => Routes.teacher,
      UserRole.parent => Routes.parent,
      UserRole.superAdmin => Routes.superAdmin,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: LayoutBuilder(builder: (context, box) {
        final wide = box.maxWidth >= 980;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (wide) const Expanded(flex: 11, child: _BrandPanel()),
            Expanded(
              flex: 9,
              child: Center(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: _form(wide),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _form(bool wide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!wide) ...[
          const Center(child: SchoolLogo(size: 60)),
          const SizedBox(height: 14),
          const Text(Branding.schoolName,
              style: AppText.h1, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          const Text(Branding.schoolTagline,
              style: AppText.caption, textAlign: TextAlign.center),
          const SizedBox(height: 32),
        ],
        Text('Welcome back', style: AppText.display.copyWith(fontSize: 26)),
        const SizedBox(height: 6),
        const Text('Sign in to the ${Branding.schoolName} portal',
            style: AppText.bodySm),
        const SizedBox(height: 26),
        const Text('SIGN IN AS', style: AppText.overline),
        const SizedBox(height: 10),
        for (final (role, icon, title, subtitle) in _roles) ...[
          _RoleOption(
            icon: icon,
            title: title,
            subtitle: subtitle,
            selected: _role == role,
            onTap: () => _pick(role),
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 14),
        Text(
          _role == UserRole.parent ? 'Registered mobile number' : 'Email address',
          style: AppText.label,
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _id,
          onSubmitted: (_) => _signIn(),
          decoration: InputDecoration(
            prefixIcon: Icon(
              _role == UserRole.parent
                  ? Icons.phone_iphone_rounded
                  : Icons.alternate_email_rounded,
              size: 18,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            const Text('Password', style: AppText.label),
            const Spacer(),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () => showAppSnack(
                context,
                'A reset link has been sent to the registered mobile number',
                icon: Icons.lock_reset_rounded,
              ),
              child: Text('Forgot password?',
                  style: AppText.label.copyWith(color: AppColors.primary)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _password,
          obscureText: _obscure,
          onSubmitted: (_) => _signIn(),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18),
            suffixIcon: IconButton(
              icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: _remember,
                onChanged: (v) => setState(() => _remember = v ?? true),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Keep me signed in on this device',
                style: AppText.bodySm),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 48,
          child: FilledButton(
            onPressed: _signIn,
            child: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.2, color: Colors.white),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Sign in'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 14),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline_rounded,
                size: 14, color: AppColors.textMuted),
            SizedBox(width: 6),
            Text('Demo mode — any password works', style: AppText.caption),
          ],
        ),
        const SizedBox(height: 36),
        const Center(child: PoweredBy()),
      ],
    );
  }
}

class _RoleOption extends StatelessWidget {
  const _RoleOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdAll,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.tint(AppColors.primary, 0.06)
                : AppColors.surface,
            borderRadius: AppRadius.mdAll,
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              IconBadge(
                icon: icon,
                color: selected ? AppColors.primary : AppColors.textSecondary,
                size: 36,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.title),
                    Text(subtitle, style: AppText.caption),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        selected ? AppColors.primary : AppColors.borderStrong,
                    width: selected ? 5 : 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    final fg = AppColors.onPrimary;
    TextStyle style(double size,
            {double alpha = 1, FontWeight weight = FontWeight.w400}) =>
        TextStyle(
          color: fg.withValues(alpha: alpha),
          fontSize: size,
          fontWeight: weight,
          fontFamily: AppText.family,
        );

    Widget stat(String value, String label) => Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: style(24, weight: FontWeight.w800)
                      .copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
              const SizedBox(height: 2),
              Text(label, style: style(12.5, alpha: 0.7)),
            ],
          ),
        );

    Widget feature(IconData icon, String text) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: fg.withValues(alpha: 0.12),
                  borderRadius: AppRadius.smAll,
                ),
                child: Icon(icon, size: 16, color: fg),
              ),
              const SizedBox(width: 12),
              Text(text, style: style(14.5, alpha: 0.9, weight: FontWeight.w500)),
            ],
          ),
        );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDeep,
            AppColors.primary,
            Color.lerp(AppColors.primary, AppColors.secondary, 0.45)!,
          ],
          stops: const [0, 0.6, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -150,
            right: -130,
            child: _Ring(size: 440, color: fg.withValues(alpha: 0.06)),
          ),
          Positioned(
            bottom: -190,
            left: -150,
            child: _Ring(size: 480, color: fg.withValues(alpha: 0.05)),
          ),
          Positioned(
            top: 190,
            right: 80,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: fg.withValues(alpha: 0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(56, 44, 56, 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SchoolLogo(size: 46, onDark: true),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(Branding.schoolName,
                              style: style(17, weight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text(
                            '${Branding.board} Affiliated · No. ${Branding.affiliationNo}',
                            style: style(12.5, alpha: 0.7),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text('Welcome to the digital campus of',
                    style: style(16, alpha: 0.75, weight: FontWeight.w500)),
                const SizedBox(height: 8),
                Text(
                  Branding.schoolName,
                  style: style(38, weight: FontWeight.w800)
                      .copyWith(letterSpacing: -1, height: 1.1),
                ),
                const SizedBox(height: 12),
                Text(Branding.schoolTagline, style: style(15, alpha: 0.75)),
                const SizedBox(height: 30),
                feature(Icons.account_balance_wallet_outlined,
                    'Fees, receipts & defaulter tracking'),
                feature(Icons.workspace_premium_outlined,
                    'Report cards generated in one click'),
                feature(Icons.forum_outlined,
                    'Instant SMS & WhatsApp to every parent'),
                feature(Icons.phone_iphone_rounded,
                    'A mobile app for every family'),
                const SizedBox(height: 28),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                  decoration: BoxDecoration(
                    color: fg.withValues(alpha: 0.08),
                    borderRadius: AppRadius.lgAll,
                    border: Border.all(color: fg.withValues(alpha: 0.12)),
                  ),
                  child: Row(
                    children: [
                      stat('$totalStrength', 'Students'),
                      stat('${seedStaff.length}', 'Teachers'),
                      stat('${schoolClasses.length}', 'Sections'),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  '${Branding.schoolAddress}   ·   ${Branding.schoolPhone}   ·   ${Branding.schoolEmail}',
                  style: style(12, alpha: 0.55),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 56),
      ),
    );
  }
}
