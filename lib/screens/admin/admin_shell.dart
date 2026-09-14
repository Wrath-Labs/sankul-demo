import 'package:flutter/material.dart';

import 'admin_nav.dart';
import 'shell/sidebar.dart';
import 'shell/top_bar.dart';

/// Fixed sidebar + top bar around every admin screen. Below 1100px the
/// sidebar collapses into a drawer.
class AdminShell extends StatelessWidget {
  const AdminShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      final wide = box.maxWidth >= 1100;
      return Scaffold(
        drawer: wide
            ? null
            : Drawer(
                width: Sidebar.width,
                shape: const RoundedRectangleBorder(),
                child: Sidebar(location: location, inDrawer: true),
              ),
        body: Row(
          children: [
            if (wide) Sidebar(location: location),
            Expanded(
              child: Column(
                children: [
                  Builder(
                    builder: (ctx) => TopBar(
                      title: titleForLocation(location),
                      onMenu: wide ? null : () => Scaffold.of(ctx).openDrawer(),
                    ),
                  ),
                  Expanded(child: child),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
