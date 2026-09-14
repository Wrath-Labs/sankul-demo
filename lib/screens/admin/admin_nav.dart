import 'package:flutter/material.dart';

import '../../router/routes.dart';

class NavItem {
  const NavItem(this.label, this.icon, this.path);
  final String label;
  final IconData icon;
  final String path;
}

class NavSection {
  const NavSection(this.title, this.items);
  final String? title;
  final List<NavItem> items;
}

/// Sidebar navigation, ordered by what matters most in the pitch.
const adminNav = <NavSection>[
  NavSection(null, [
    NavItem('Dashboard', Icons.space_dashboard_outlined, Routes.dashboard),
  ]),
  NavSection('Finance', [
    NavItem('Fee Management', Icons.account_balance_wallet_outlined, Routes.fees),
  ]),
  NavSection('Academics', [
    NavItem('Exams & Report Cards', Icons.workspace_premium_outlined, Routes.exams),
    NavItem('Attendance', Icons.fact_check_outlined, Routes.attendance),
    NavItem('Students', Icons.school_outlined, Routes.students),
    NavItem('Staff', Icons.badge_outlined, Routes.staff),
    NavItem('Timetable', Icons.calendar_view_week_outlined, Routes.timetable),
  ]),
  NavSection('Engage', [
    NavItem('Communication', Icons.campaign_outlined, Routes.communication),
  ]),
];

String titleForLocation(String location) {
  for (final section in adminNav) {
    for (final item in section.items) {
      if (location.startsWith(item.path)) return item.label;
    }
  }
  return 'Dashboard';
}
