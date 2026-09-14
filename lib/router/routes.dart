/// Route paths. Admin screens live under /admin inside the dashboard shell.
class Routes {
  Routes._();

  static const login = '/login';
  static const dashboard = '/admin/dashboard';
  static const fees = '/admin/fees';
  static const students = '/admin/students';
  static const staff = '/admin/staff';
  static const attendance = '/admin/attendance';
  static const exams = '/admin/exams';
  static const communication = '/admin/communication';
  static const timetable = '/admin/timetable';
  static const teacher = '/teacher';
  static const parent = '/parent';
  static const superAdmin = '/super-admin';

  static String student(String id) => '$students/$id';
}
