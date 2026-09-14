import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/admin/admin_shell.dart';
import '../screens/admin/dashboard/dashboard_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/common/build_queue_screen.dart';
import 'routes.dart';

CustomTransitionPage<void> _fade(GoRouterState state, Widget child) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 180),
      reverseTransitionDuration: const Duration(milliseconds: 120),
      transitionsBuilder: (context, animation, secondary, child) =>
          FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      ),
    );

GoRoute _page(String path, String name, Widget screen) => GoRoute(
      path: path,
      name: name,
      pageBuilder: (context, state) => _fade(state, screen),
    );

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.login,
    routes: [
      GoRoute(path: '/', redirect: (_, _) => Routes.login),
      GoRoute(path: '/admin', redirect: (_, _) => Routes.dashboard),
      _page(Routes.login, 'login', const LoginScreen()),
      ShellRoute(
        builder: (context, state, child) =>
            AdminShell(location: state.uri.path, child: child),
        routes: [
          _page(Routes.dashboard, 'dashboard', const DashboardScreen()),
          _page(Routes.fees, 'fees',
              const BuildQueueScreen(title: 'Fee Management')),
          _page(Routes.exams, 'exams',
              const BuildQueueScreen(title: 'Exams & Report Cards')),
          _page(Routes.communication, 'communication',
              const BuildQueueScreen(title: 'Communication')),
          _page(Routes.students, 'students',
              const BuildQueueScreen(title: 'Students')),
          _page(Routes.staff, 'staff', const BuildQueueScreen(title: 'Staff')),
          _page(Routes.attendance, 'attendance',
              const BuildQueueScreen(title: 'Attendance')),
          _page(Routes.timetable, 'timetable',
              const BuildQueueScreen(title: 'Timetable')),
        ],
      ),
      _page(Routes.teacher, 'teacher',
          const BuildQueueScreen(title: 'Teacher View', standalone: true)),
      _page(Routes.parent, 'parent',
          const BuildQueueScreen(title: 'Parent App', standalone: true)),
      _page(Routes.superAdmin, 'superAdmin',
          const BuildQueueScreen(title: 'Super Admin', standalone: true)),
    ],
  );
});
