import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/classes.dart';
import '../data/staff.dart';
import '../data/students.dart';
import '../models/school_class.dart';
import '../models/staff.dart';
import '../models/student.dart';

final studentsProvider = Provider<List<Student>>((ref) => seedStudents);

final activeStudentsProvider = Provider<List<Student>>(
  (ref) => ref.watch(studentsProvider).where((s) => s.isActive).toList(),
);

final classesProvider = Provider<List<SchoolClass>>((ref) => schoolClasses);

final staffProvider = Provider<List<Staff>>((ref) => seedStaff);
