import 'package:flutter/services.dart';

import 'branding.dart';

/// Resolves optional brand assets once at startup so widgets and PDFs can
/// fall back to a monogram without triggering a failed asset request.
class BrandAssets {
  BrandAssets._();

  static bool hasLogo = false;

  static Future<void> init() async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      hasLogo = manifest.listAssets().contains(Branding.logoAsset);
    } catch (_) {
      hasLogo = false;
    }
  }

  static Future<Uint8List?> logoBytes() async {
    if (!hasLogo) return null;
    final data = await rootBundle.load(Branding.logoAsset);
    return data.buffer.asUint8List();
  }
}
