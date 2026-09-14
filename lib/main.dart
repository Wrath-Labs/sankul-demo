import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'config/brand_assets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BrandAssets.init();
  runApp(const ProviderScope(child: SankulApp()));
}
