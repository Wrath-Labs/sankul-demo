import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/branding.dart';
import '../data/staff.dart';
import '../data/students.dart';

enum UserRole { admin, teacher, parent, superAdmin }

class SessionUser {
  const SessionUser({
    required this.role,
    required this.name,
    required this.title,
    required this.loginId,
  });

  final UserRole role;
  final String name;
  final String title;
  final String loginId;

  /// "Dr. Meenakshi Agarwal" → "Dr. Agarwal"
  String get formalName {
    final parts = name.split(' ');
    if (parts.length >= 3 && parts.first.endsWith('.')) {
      return '${parts.first} ${parts.last}';
    }
    return name;
  }

  factory SessionUser.forRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return SessionUser(
          role: role,
          name: Branding.principalName,
          title: 'Principal',
          loginId: 'principal@${Branding.emailDomain}',
        );
      case UserRole.teacher:
        final t = demoTeacher;
        return SessionUser(
          role: role,
          name: t.name,
          title: 'Class Teacher · ${t.classTeacherOf}',
          loginId: t.email,
        );
      case UserRole.parent:
        final child = studentNamed('Aarav Sharma');
        return SessionUser(
          role: role,
          name: 'Mr. ${child.fatherName}',
          title: 'Parent',
          loginId: child.phone,
        );
      case UserRole.superAdmin:
        return SessionUser(
          role: role,
          name: '${Branding.productName} Operations',
          title: 'Super Admin',
          loginId: 'ops@${Branding.productName.toLowerCase()}.in',
        );
    }
  }
}

class SessionNotifier extends Notifier<SessionUser> {
  @override
  SessionUser build() => SessionUser.forRole(UserRole.admin);

  void signIn(UserRole role) => state = SessionUser.forRole(role);
}

final sessionProvider =
    NotifierProvider<SessionNotifier, SessionUser>(SessionNotifier.new);
