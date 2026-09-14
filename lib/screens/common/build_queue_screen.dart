import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/routes.dart';
import '../../theme/tokens.dart';
import '../../widgets/app_card.dart';

/// Temporary stand-in for screens not yet built at the dashboard review
/// checkpoint. Removed once every screen is implemented.
class BuildQueueScreen extends StatelessWidget {
  const BuildQueueScreen({
    super.key,
    required this.title,
    this.standalone = false,
  });

  final String title;
  final bool standalone;

  @override
  Widget build(BuildContext context) {
    final body = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: AppCard(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.construction_outlined,
                  size: 36, color: AppColors.textMuted),
              const SizedBox(height: 12),
              Text(title, style: AppText.h2),
              const SizedBox(height: 6),
              const Text(
                'Queued for the next build pass, after dashboard review.',
                style: AppText.bodySm,
                textAlign: TextAlign.center,
              ),
              if (standalone) ...[
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () => context.go(Routes.login),
                  child: const Text('Back to login'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
    return standalone ? Scaffold(body: body) : body;
  }
}
