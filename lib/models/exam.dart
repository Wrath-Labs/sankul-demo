class Exam {
  const Exam({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.maxMarks = 100,
  });

  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;

  /// Maximum marks per subject.
  final int maxMarks;
}

/// CBSE 8-point grading scale.
class CbseGrade {
  CbseGrade._();

  static const scale = <(String grade, int min, int max, String remark)>[
    ('A1', 91, 100, 'Outstanding'),
    ('A2', 81, 90, 'Excellent'),
    ('B1', 71, 80, 'Very Good'),
    ('B2', 61, 70, 'Good'),
    ('C1', 51, 60, 'Above Average'),
    ('C2', 41, 50, 'Average'),
    ('D', 33, 40, 'Satisfactory'),
    ('E', 0, 32, 'Needs Improvement'),
  ];

  static String of(num percentage) {
    final p = percentage.round();
    for (final g in scale) {
      if (p >= g.$2) return g.$1;
    }
    return 'E';
  }

  static String remarkFor(String grade) =>
      scale.firstWhere((g) => g.$1 == grade, orElse: () => scale.last).$4;
}

/// Computed result of one student in one exam.
class StudentResult {
  const StudentResult({
    required this.studentId,
    required this.marks,
    required this.total,
    required this.maxTotal,
    required this.rank,
  });

  final String studentId;

  /// subject → marks obtained
  final Map<String, int> marks;
  final int total;
  final int maxTotal;
  final int rank;

  double get percentage => maxTotal == 0 ? 0 : total / maxTotal * 100;
  String get grade => CbseGrade.of(percentage);
}
