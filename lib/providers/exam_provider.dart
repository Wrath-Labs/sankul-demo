import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/exams.dart';
import '../data/students.dart';
import '../models/exam.dart';

class MarksNotifier extends Notifier<Map<String, Map<String, int>>> {
  @override
  Map<String, Map<String, int>> build() => {
        for (final e in seedMarks.entries) e.key: Map.of(e.value),
      };

  void setMark(String studentId, String subject, int marks) {
    state = {
      ...state,
      studentId: {...?state[studentId], subject: marks},
    };
  }
}

final marksProvider =
    NotifierProvider<MarksNotifier, Map<String, Map<String, int>>>(
        MarksNotifier.new);

/// Totals, percentages and ranks for a class — recomputed on every edit.
final classResultsProvider =
    Provider.family<List<StudentResult>, String>((ref, classId) {
  final marks = ref.watch(marksProvider);
  final subjects = subjectsByGrade[classId.split('-').first] ?? const [];
  final roster = studentsInClass(classId);
  final totals = {
    for (final s in roster)
      s.id: subjects.fold(0, (sum, sub) => sum + (marks[s.id]?[sub] ?? 0)),
  };
  final ranked = totals.values.toList()..sort((a, b) => b.compareTo(a));
  return [
    for (final s in roster)
      StudentResult(
        studentId: s.id,
        marks: {for (final sub in subjects) sub: marks[s.id]?[sub] ?? 0},
        total: totals[s.id]!,
        maxTotal: subjects.length * halfYearlyExam.maxMarks,
        rank: ranked.indexOf(totals[s.id]!) + 1,
      ),
  ];
});
