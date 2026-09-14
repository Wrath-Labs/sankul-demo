import 'dart:math';

import '../config/branding.dart';
import '../models/staff.dart';

final _rng = Random(33);

Staff _t(
  int n,
  String name,
  String designation,
  List<String> subjects,
  List<String> classes,
  String qualification,
  int joined, {
  String? ct,
}) {
  final parts = name.split(' ').skip(1).toList();
  final email =
      '${parts.first.toLowerCase()}.${parts.last.toLowerCase()}@${Branding.emailDomain}';
  const prefixes = ['98370', '94120', '97190', '88810', '99270', '63971'];
  return Staff(
    id: 'T${n.toString().padLeft(2, '0')}',
    employeeId: '${Branding.schoolCode}/EMP/${(n + 11).toString().padLeft(3, '0')}',
    name: name,
    designation: designation,
    subjects: subjects,
    classes: classes,
    phone: '+91 ${prefixes[_rng.nextInt(prefixes.length)]} ${10000 + _rng.nextInt(90000)}',
    email: email,
    qualification: qualification,
    joiningYear: joined,
    classTeacherOf: ct,
    isFemale: name.startsWith('Mrs.') || name.startsWith('Ms.'),
  );
}

/// 33 teaching staff; every section has a class teacher.
final List<Staff> seedStaff = [
  _t(1, 'Mr. Rakesh Verma', 'PGT', ['Mathematics'], ['IX-A', 'X-A', 'X-B', 'XI-A', 'XII-A'], 'M.Sc. (Mathematics), B.Ed.', 2009, ct: 'X-A'),
  _t(2, 'Mrs. Kavita Saxena', 'TGT', ['Science'], ['VIII-A', 'VIII-B', 'IX-A', 'IX-B', 'X-A'], 'M.Sc. (Chemistry), B.Ed.', 2012, ct: 'IX-B'),
  _t(3, 'Mrs. Anjali Mathur', 'TGT', ['English'], ['VII-A', 'VIII-A', 'VIII-B', 'X-A', 'X-B'], 'M.A. (English), B.Ed.', 2011, ct: 'VIII-A'),
  _t(4, 'Mr. Suresh Chand Sharma', 'TGT', ['Hindi'], ['VIII-A', 'IX-A', 'IX-B', 'X-A', 'X-B'], 'M.A. (Hindi), B.Ed.', 2005, ct: 'X-B'),
  _t(5, 'Ms. Priya Khandelwal', 'PRT', ['English', 'EVS', 'Mathematics'], ['V-A', 'V-B', 'V-C'], 'B.Sc., B.Ed.', 2018, ct: 'V-B'),
  _t(6, 'Mr. Imran Qureshi', 'PGT', ['Physics'], ['IX-B', 'X-B', 'XI-A', 'XII-A'], 'M.Sc. (Physics), B.Ed.', 2014, ct: 'XII-A'),
  _t(7, 'Mrs. Neha Bansal', 'PGT', ['Chemistry'], ['XI-A', 'XII-A'], 'M.Sc. (Chemistry), B.Ed.', 2016, ct: 'XI-A'),
  _t(8, 'Dr. Alok Srivastava', 'PGT', ['Biology'], ['IX-A', 'XI-A', 'XII-A'], 'Ph.D. (Botany), B.Ed.', 2010, ct: 'IX-A'),
  _t(9, 'Mr. Vikas Tomar', 'PGT', ['Accountancy', 'Business Studies'], ['XI-B', 'XII-B'], 'M.Com., B.Ed.', 2013, ct: 'XII-B'),
  _t(10, 'Mrs. Seema Gupta', 'TGT', ['Social Science'], ['VIII-A', 'VIII-B', 'IX-A', 'IX-B', 'X-A', 'X-B'], 'M.A. (History), B.Ed.', 2008, ct: 'VIII-B'),
  _t(11, 'Mr. Pankaj Mishra', 'TGT', ['Sanskrit'], ['VI-A', 'VI-B', 'VII-A', 'VII-B', 'VIII-A'], 'Acharya (Sanskrit), B.Ed.', 2015, ct: 'VII-A'),
  _t(12, 'Ms. Ritu Agarwal', 'TGT', ['Computer Science'], ['VI-A', 'VII-A', 'VIII-A', 'IX-A', 'X-A', 'X-B'], 'MCA, B.Ed.', 2017, ct: 'VI-A'),
  _t(13, 'Mrs. Sunita Yadav', 'PRT', ['Hindi', 'EVS'], ['III-A', 'III-B', 'IV-A'], 'M.A. (Hindi), B.Ed.', 2007, ct: 'III-A'),
  _t(14, 'Mrs. Deepti Jain', 'NTT', ['Pre-Primary'], ['Nursery-A', 'Nursery-B'], 'NTT Diploma, B.A.', 2012, ct: 'Nursery-A'),
  _t(15, 'Mr. Harish Rathore', 'PET', ['Physical Education'], ['VI-A', 'VII-A', 'VIII-A', 'IX-A', 'X-A', 'XI-A', 'XII-A'], 'B.P.Ed., M.P.Ed.', 2011),
  _t(16, 'Mrs. Monika Singhal', 'TGT', ['Art & Craft', 'Music'], ['III-A', 'IV-A', 'V-B', 'VI-B', 'VII-B'], 'M.F.A. (Painting)', 2014, ct: 'VII-B'),
  _t(17, 'Mrs. Rashmi Goel', 'NTT', ['Pre-Primary'], ['Nursery-B'], 'NTT Diploma, B.Com.', 2016, ct: 'Nursery-B'),
  _t(18, 'Mrs. Swati Kulshrestha', 'NTT', ['Pre-Primary'], ['LKG-A'], 'NTT Diploma, B.A.', 2015, ct: 'LKG-A'),
  _t(19, 'Ms. Shivani Chaturvedi', 'NTT', ['Pre-Primary'], ['LKG-B'], 'NTT Diploma, B.Sc.', 2021, ct: 'LKG-B'),
  _t(20, 'Mrs. Preeti Varshney', 'NTT', ['Pre-Primary'], ['UKG-A'], 'NTT Diploma, M.A.', 2013, ct: 'UKG-A'),
  _t(21, 'Mrs. Archana Dixit', 'NTT', ['Pre-Primary'], ['UKG-B'], 'NTT Diploma, B.A.', 2018, ct: 'UKG-B'),
  _t(22, 'Mrs. Vandana Sharma', 'PRT', ['English', 'Mathematics'], ['I-A', 'I-B'], 'B.A., B.Ed.', 2010, ct: 'I-A'),
  _t(23, 'Ms. Pooja Rawat', 'PRT', ['Hindi', 'EVS'], ['I-B', 'II-A'], 'B.Sc., B.Ed.', 2022, ct: 'I-B'),
  _t(24, 'Mrs. Rachna Bhatnagar', 'PRT', ['English', 'EVS'], ['II-A', 'II-B'], 'M.A., B.Ed.', 2012, ct: 'II-A'),
  _t(25, 'Mrs. Meenu Garg', 'PRT', ['Mathematics', 'EVS'], ['II-B', 'III-B'], 'M.Sc., B.Ed.', 2014, ct: 'II-B'),
  _t(26, 'Mrs. Kiran Chauhan', 'PRT', ['English', 'Hindi'], ['III-B', 'IV-B'], 'B.A., B.Ed.', 2016, ct: 'III-B'),
  _t(27, 'Ms. Jyoti Yadav', 'PRT', ['Mathematics', 'EVS'], ['IV-A', 'IV-B'], 'B.Sc., B.Ed.', 2020, ct: 'IV-A'),
  _t(28, 'Mrs. Anita Maheshwari', 'PRT', ['English', 'Hindi'], ['IV-B', 'V-A'], 'M.A., B.Ed.', 2009, ct: 'IV-B'),
  _t(29, 'Mrs. Nidhi Agarwal', 'PRT', ['Mathematics', 'EVS'], ['V-A', 'V-C'], 'M.Sc., B.Ed.', 2015, ct: 'V-A'),
  _t(30, 'Mr. Rahul Sikarwar', 'PRT', ['Hindi', 'G.K.'], ['V-B', 'V-C'], 'M.A., B.Ed.', 2019, ct: 'V-C'),
  _t(31, 'Mr. Ravi Shankar Dubey', 'TGT', ['Mathematics'], ['VI-A', 'VI-B', 'VII-A', 'VII-B', 'VIII-A', 'VIII-B'], 'M.Sc. (Mathematics), B.Ed.', 2011, ct: 'VI-B'),
  _t(32, 'Mrs. Pallavi Jaiswal', 'TGT', ['Science'], ['VI-A', 'VI-B', 'VII-A', 'VII-B', 'VIII-C'], 'M.Sc. (Zoology), B.Ed.', 2017, ct: 'VIII-C'),
  _t(33, 'Mr. Nitin Goyal', 'PGT', ['Economics'], ['XI-A', 'XI-B', 'XII-B'], 'M.A. (Economics), B.Ed.', 2016, ct: 'XI-B'),
];

final Map<String, Staff> staffById = {for (final s in seedStaff) s.id: s};

Staff? classTeacherFor(String classId) {
  for (final s in seedStaff) {
    if (s.classTeacherOf == classId) return s;
  }
  return null;
}

/// The teacher the "Teacher" demo role logs in as.
Staff get demoTeacher => staffById['T01']!;
