import 'dart:math';

import '../config/demo_clock.dart';
import '../models/exam.dart';
import 'students.dart';

const subjectsByGrade = <String, List<String>>{
  'V': ['English', 'Hindi', 'Mathematics', 'EVS', 'Computer', 'G.K.'],
  'VIII': ['English', 'Hindi', 'Sanskrit', 'Mathematics', 'Science', 'Social Science', 'Computer'],
  'X': ['English', 'Hindi', 'Mathematics', 'Science', 'Social Science', 'Information Tech.'],
};

/// Classes with complete marks for the half-yearly exam.
const examClassIds = ['X-A', 'VIII-A', 'V-B'];

final Exam halfYearlyExam = Exam(
  id: 'half-yearly',
  name: 'Half-Yearly Examination ${DemoClock.sessionStart.year}',
  startDate: DemoClock.daysAgo(26),
  endDate: DemoClock.daysAgo(14),
);

/// Working days so far this session, used on report cards.
const int sessionWorkingDays = 112;

/// Overall ability per student; subject marks vary around it.
const _ability = <String, int>{
  // X-A
  'Saanvi Agarwal': 95, 'Ananya Gupta': 92, 'Ishita Jain': 89,
  'Aarav Sharma': 86, 'Pranav Tiwari': 84, 'Nandini Goyal': 82,
  'Kavya Mishra': 80, 'Siddharth Tomar': 77, 'Diya Maheshwari': 76,
  'Shreya Bansal': 74, 'Tanvi Saxena': 72, 'Arjun Singh Chauhan': 70,
  'Kabir Khan': 69, 'Mohit Kushwaha': 63, 'Rohan Rajput': 59,
  'Harshit Yadav': 56,
  // VIII-A
  'Khushi Singhal': 93, 'Palak Dubey': 90, 'Ishaan Mittal': 88,
  'Aditi Verma': 85, 'Naman Agarwal': 83, 'Lakshya Pandey': 81,
  'Vanshika Soni': 80, 'Ansh Garg': 78, 'Avni Chaudhary': 76,
  'Shaurya Bhardwaj': 74, 'Mahi Rathore': 72, 'Dhruv Bansal': 69,
  'Rehan Siddiqui': 67, 'Riya Chauhan': 65, 'Yash Kapoor': 62,
  'Kunal Saxena': 58,
  // V-B
  'Charvi Agarwal': 94, 'Anaya Sharma': 91, 'Siya Bhatnagar': 89,
  'Reyansh Gupta': 87, 'Aadhya Tyagi': 85, 'Vivaan Mishra': 83,
  'Krishna Varshney': 80, 'Inaya Qureshi': 79, 'Myra Jain': 77,
  'Atharv Jaiswal': 75, 'Devansh Yadav': 72, 'Yashika Chauhan': 71,
  'Om Tiwari': 66, 'Pari Rajput': 63,
};

const _subjectBias = <String, int>{
  'English': 2, 'Hindi': 4, 'Sanskrit': 3, 'Mathematics': -4, 'Science': -1,
  'Social Science': 0, 'Information Tech.': 5, 'Computer': 5, 'EVS': 2,
  'G.K.': 3,
};

/// studentId → subject → marks (out of 100).
final Map<String, Map<String, int>> seedMarks = _buildMarks();

int abilityOf(String studentName) => _ability[studentName] ?? 75;

Map<String, Map<String, int>> _buildMarks() {
  final out = <String, Map<String, int>>{};
  var seed = 1000;
  for (final classId in examClassIds) {
    final grade = classId.split('-').first;
    for (final s in studentsInClass(classId)) {
      final rng = Random(seed++);
      final a = abilityOf(s.name);
      out[s.id] = {
        for (final subject in subjectsByGrade[grade]!)
          subject: (a + (_subjectBias[subject] ?? 0) + rng.nextInt(15) - 8)
              .clamp(36, 99),
      };
    }
  }
  return out;
}
