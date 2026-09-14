class Staff {
  const Staff({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.designation,
    required this.subjects,
    required this.classes,
    required this.phone,
    required this.email,
    required this.qualification,
    required this.joiningYear,
    this.classTeacherOf,
    this.isFemale = false,
  });

  final String id;

  /// SPS/EMP/034
  final String employeeId;

  /// Full name with honorific, e.g. "Mr. Rakesh Verma".
  final String name;

  /// 'PGT', 'TGT', 'PRT', 'NTT', 'PET'
  final String designation;
  final List<String> subjects;
  final List<String> classes;
  final String phone;
  final String email;
  final String qualification;
  final int joiningYear;
  final String? classTeacherOf;
  final bool isFemale;

  String get primarySubject => subjects.first;
  String get role => '$designation · ${subjects.join(', ')}';
}
