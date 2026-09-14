import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/branding.dart';
import '../router/routes.dart';
import '../theme/tokens.dart';

/// Tiny "Powered by Sankul" mark. Doubles as the discreet entry point to
/// the Super Admin console.
class PoweredBy extends StatelessWidget {
  const PoweredBy({super.key, this.color = AppColors.textMuted});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '${Branding.productName} Console',
      child: InkWell(
        onTap: () => context.go(Routes.superAdmin),
        borderRadius: AppRadius.smAll,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Powered by ', style: AppText.caption.copyWith(color: color)),
              Container(
                width: 14,
                height: 14,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  Branding.productName[0],
                  style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                Branding.productName,
                style: AppText.caption
                    .copyWith(color: color, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
