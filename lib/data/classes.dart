import '../models/school_class.dart';

const gradeOrder = <String>[
  'Nursery', 'LKG', 'UKG', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII',
  'IX', 'X', 'XI', 'XII',
];

/// 32 sections, 620 students on the rolls.
const schoolClasses = <SchoolClass>[
  SchoolClass(grade: 'Nursery', section: 'A', order: 0, strength: 16),
  SchoolClass(grade: 'Nursery', section: 'B', order: 0, strength: 14),
  SchoolClass(grade: 'LKG', section: 'A', order: 1, strength: 17),
  SchoolClass(grade: 'LKG', section: 'B', order: 1, strength: 16),
  SchoolClass(grade: 'UKG', section: 'A', order: 2, strength: 18),
  SchoolClass(grade: 'UKG', section: 'B', order: 2, strength: 17),
  SchoolClass(grade: 'I', section: 'A', order: 3, strength: 23),
  SchoolClass(grade: 'I', section: 'B', order: 3, strength: 21),
  SchoolClass(grade: 'II', section: 'A', order: 4, strength: 21),
  SchoolClass(grade: 'II', section: 'B', order: 4, strength: 23),
  SchoolClass(grade: 'III', section: 'A', order: 5, strength: 22),
  SchoolClass(grade: 'III', section: 'B', order: 5, strength: 20),
  SchoolClass(grade: 'IV', section: 'A', order: 6, strength: 21),
  SchoolClass(grade: 'IV', section: 'B', order: 6, strength: 21),
  SchoolClass(grade: 'V', section: 'A', order: 7, strength: 20),
  SchoolClass(grade: 'V', section: 'B', order: 7, strength: 14),
  SchoolClass(grade: 'V', section: 'C', order: 7, strength: 17),
  SchoolClass(grade: 'VI', section: 'A', order: 8, strength: 23),
  SchoolClass(grade: 'VI', section: 'B', order: 8, strength: 21),
  SchoolClass(grade: 'VII', section: 'A', order: 9, strength: 22),
  SchoolClass(grade: 'VII', section: 'B', order: 9, strength: 20),
  SchoolClass(grade: 'VIII', section: 'A', order: 10, strength: 16),
  SchoolClass(grade: 'VIII', section: 'B', order: 10, strength: 20),
  SchoolClass(grade: 'VIII', section: 'C', order: 10, strength: 19),
  SchoolClass(grade: 'IX', section: 'A', order: 11, strength: 23),
  SchoolClass(grade: 'IX', section: 'B', order: 11, strength: 21),
  SchoolClass(grade: 'X', section: 'A', order: 12, strength: 16),
  SchoolClass(grade: 'X', section: 'B', order: 12, strength: 22),
  SchoolClass(
      grade: 'XI', section: 'A', order: 13, strength: 20, stream: 'Science'),
  SchoolClass(
      grade: 'XI', section: 'B', order: 13, strength: 17, stream: 'Commerce'),
  SchoolClass(
      grade: 'XII', section: 'A', order: 14, strength: 21, stream: 'Science'),
  SchoolClass(
      grade: 'XII', section: 'B', order: 14, strength: 18, stream: 'Commerce'),
];

final Map<String, SchoolClass> classById = {
  for (final c in schoolClasses) c.id: c,
};

List<SchoolClass> sectionsOf(String grade) =>
    schoolClasses.where((c) => c.grade == grade).toList();

int get totalStrength => schoolClasses.fold(0, (sum, c) => sum + c.strength);
