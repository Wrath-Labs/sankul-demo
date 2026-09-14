import 'dart:math';

import '../config/branding.dart';
import '../config/demo_clock.dart';
import '../models/school_class.dart';
import '../models/student.dart';
import 'classes.dart';
import 'names.dart';

/// Compact profile spec; expanded into a full [Student] by [_buildStudents].
class _Spec {
  const _Spec(
    this.first,
    this.last,
    this.gender,
    this.father,
    this.mother,
    this.occupation,
    this.locality,
    this.admittedIn, {
    this.route,
    this.att,
    this.blood,
    this.phone,
    this.newAdmission = false,
  });

  final String first;
  final String last;
  final Gender gender;
  final String father;
  final String mother;
  final String occupation;
  final String locality;

  /// Admission year; 0 = the current session.
  final int admittedIn;
  final String? route;
  final double? att;
  final String? blood;
  final String? phone;
  final bool newAdmission;
}

const _m = Gender.male;
const _f = Gender.female;

/// Showcase classes — every student hand-written. These are the classes the
/// demo drills into: attendance marking, marks entry, report cards and the
/// parent app (Aarav & Anaya Sharma are siblings).
const Map<String, List<_Spec>> _showcase = {
  'X-A': [
    _Spec('Aarav', 'Sharma', _m, 'Rajesh', 'Pooja', 'Business (Marble & Handicrafts)', 'Kamla Nagar', 2016, route: 'R2', att: 96.2, blood: 'B+', phone: '+91 98370 45612'),
    _Spec('Ananya', 'Gupta', _f, 'Sanjay', 'Neha', 'Chartered Accountant', 'Dayal Bagh', 2016, att: 97.8, blood: 'O+'),
    _Spec('Arjun', 'Singh Chauhan', _m, 'Vikram', 'Rekha', 'Indian Army (Subedar)', 'Sikandra', 2018, route: 'R1', att: 91.4, blood: 'A+'),
    _Spec('Diya', 'Maheshwari', _f, 'Amit', 'Swati', 'Business (Footwear)', 'Civil Lines', 2016, route: 'R6', att: 95.1, blood: 'B+'),
    _Spec('Harshit', 'Yadav', _m, 'Manoj', 'Sarita', 'Government Service (UPPCL)', 'Bodla', 2017, route: 'R1', att: 84.1, blood: 'O+'),
    _Spec('Ishita', 'Jain', _f, 'Ashok', 'Shalini', 'Jeweller', 'Lohamandi', 2016, att: 95.9, blood: 'AB+'),
    _Spec('Kabir', 'Khan', _m, 'Imran', 'Nazia', 'Doctor (Orthopaedic Surgeon)', 'Sanjay Place', 2019, route: 'R6', att: 90.6, blood: 'B-'),
    _Spec('Kavya', 'Mishra', _f, 'Vivek', 'Anjali', 'Bank Officer (SBI)', 'Shastripuram', 2016, route: 'R4', att: 94.3, blood: 'A+'),
    _Spec('Mohit', 'Kushwaha', _m, 'Ramesh', 'Geeta', 'Shopkeeper', 'Sikandra', 2017, att: 88.7, blood: 'O+'),
    _Spec('Nandini', 'Goyal', _f, 'Pradeep', 'Ritu', 'Business (Petha Manufacturer)', 'Kamla Nagar', 2016, route: 'R2', att: 96.8, blood: 'B+'),
    _Spec('Pranav', 'Tiwari', _m, 'Deepak', 'Kavita', 'Advocate', 'Civil Lines', 2016, att: 93.5, blood: 'A-'),
    _Spec('Rohan', 'Rajput', _m, 'Sunil', 'Seema', 'Transport Business', 'Trans Yamuna Colony', 2018, route: 'R5', att: 86.2, blood: 'O+', phone: '+91 97190 22871'),
    _Spec('Saanvi', 'Agarwal', _f, 'Nitin', 'Deepti', 'Software Engineer', 'Dayal Bagh', 2016, att: 98.4, blood: 'B+'),
    _Spec('Shreya', 'Bansal', _f, 'Rakesh', 'Monika', 'Business (Leather Exports)', 'Kamla Nagar', 2017, route: 'R2', att: 92.9, blood: 'O-'),
    _Spec('Siddharth', 'Tomar', _m, 'Arvind', 'Preeti', 'Government Service (Railways)', 'Awas Vikas Colony', 2016, route: 'R4', att: 93.8, blood: 'A+'),
    _Spec('Tanvi', 'Saxena', _f, 'Gaurav', 'Rashmi', 'Teacher', 'Shastripuram', 2017, att: 91.2, blood: 'B+'),
  ],
  'VIII-A': [
    _Spec('Aditi', 'Verma', _f, 'Sandeep', 'Nidhi', 'Business (Garments)', 'Kamla Nagar', 2019, route: 'R2', att: 95.4, blood: 'B+'),
    _Spec('Ansh', 'Garg', _m, 'Naveen', 'Poonam', 'Chartered Accountant', 'Civil Lines', 2019, att: 93.1, blood: 'O+'),
    _Spec('Avni', 'Chaudhary', _f, 'Yogesh', 'Sunita', 'Farmer & Landowner', 'Khandari', 2020, route: 'R3', att: 94.0, blood: 'A+'),
    _Spec('Dhruv', 'Bansal', _m, 'Harish', 'Archana', 'Business (Hardware)', 'Lohamandi', 2019, att: 89.5, blood: 'B+'),
    _Spec('Ishaan', 'Mittal', _m, 'Rahul', 'Shweta', 'Doctor (Paediatrician)', 'Sanjay Place', 2019, route: 'R6', att: 96.1, blood: 'AB+'),
    _Spec('Khushi', 'Singhal', _f, 'Mukesh', 'Vandana', 'Business (Sweets)', 'Dayal Bagh', 2019, att: 97.2, blood: 'O+'),
    _Spec('Kunal', 'Saxena', _m, 'Dinesh', 'Rachna', 'Private Service', 'Bodla', 2021, route: 'R1', att: 87.3, blood: 'B+'),
    _Spec('Lakshya', 'Pandey', _m, 'Alok', 'Meena', 'Government Service (Income Tax)', 'Awas Vikas Colony', 2019, route: 'R4', att: 94.7, blood: 'A+'),
    _Spec('Mahi', 'Rathore', _f, 'Vinod', 'Seema', 'Police (Sub-Inspector)', 'Shahganj', 2020, att: 92.4, blood: 'O+'),
    _Spec('Naman', 'Agarwal', _m, 'Sachin', 'Priya', 'Business (Shoe Exports)', 'Kamla Nagar', 2019, route: 'R2', att: 95.8, blood: 'B+'),
    _Spec('Palak', 'Dubey', _f, 'Ajay', 'Kavita', 'Teacher', 'Shastripuram', 2019, route: 'R4', att: 96.5, blood: 'A-'),
    _Spec('Rehan', 'Siddiqui', _m, 'Arif', 'Farah', 'Business (Carpets)', 'Tajganj', 2020, att: 90.9, blood: 'O+'),
    _Spec('Riya', 'Chauhan', _f, 'Pankaj', 'Anita', 'Pharmacist', 'Sikandra', 2019, route: 'R1', att: 88.4, blood: 'B+'),
    _Spec('Shaurya', 'Bhardwaj', _m, 'Rohit', 'Swati', 'Engineer (PWD)', 'Civil Lines', 2019, att: 93.6, blood: 'AB-'),
    _Spec('Vanshika', 'Soni', _f, 'Sumit', 'Pooja', 'Jeweller', 'Rawatpara', 2019, att: 94.9, blood: 'B+'),
    _Spec('Yash', 'Kapoor', _m, 'Vivek', 'Neha', 'Hotelier', 'Fatehabad Road', 2021, route: 'R5', att: 89.1, blood: 'O+'),
  ],
  'V-B': [
    _Spec('Aadhya', 'Tyagi', _f, 'Sandeep', 'Ritu', 'Private Service', 'Kamla Nagar', 2022, route: 'R2', att: 95.2, blood: 'A+'),
    _Spec('Anaya', 'Sharma', _f, 'Rajesh', 'Pooja', 'Business (Marble & Handicrafts)', 'Kamla Nagar', 2022, route: 'R2', att: 97.1, blood: 'B+', phone: '+91 98370 45612'),
    _Spec('Atharv', 'Jaiswal', _m, 'Manish', 'Kiran', 'Business (Transport)', 'Bodla', 2022, route: 'R1', att: 92.8, blood: 'O+'),
    _Spec('Charvi', 'Agarwal', _f, 'Anuj', 'Shikha', 'Chartered Accountant', 'Dayal Bagh', 2022, att: 96.3, blood: 'B+'),
    _Spec('Devansh', 'Yadav', _m, 'Rakesh', 'Suman', 'Government Service (Nagar Nigam)', 'Shahganj', 2023, att: 91.7, blood: 'O+'),
    _Spec('Inaya', 'Qureshi', _f, 'Faisal', 'Rukhsar', 'Business (Leather Goods)', 'Tajganj', 2022, att: 93.4, blood: 'A+'),
    _Spec('Krishna', 'Varshney', _m, 'Lalit', 'Madhu', 'Wholesale Trader', 'Lohamandi', 2022, att: 94.1, blood: 'B-'),
    _Spec('Myra', 'Jain', _f, 'Sanjeev', 'Ruchi', 'Business (Textiles)', 'Civil Lines', 2022, route: 'R6', att: 90.2, blood: 'AB+'),
    _Spec('Om', 'Tiwari', _m, 'Hemant', 'Sadhna', 'Priest & Astrologer', 'Balkeshwar', 2023, route: 'R2', att: 88.6, blood: 'O+'),
    _Spec('Pari', 'Rajput', _f, 'Sunil', 'Seema', 'Transport Business', 'Trans Yamuna Colony', 2022, route: 'R5', att: 87.9, blood: 'O+', phone: '+91 97190 22871'),
    _Spec('Reyansh', 'Gupta', _m, 'Abhishek', 'Nisha', 'Doctor (Dentist)', 'Sanjay Place', 2022, route: 'R6', att: 96.0, blood: 'A+'),
    _Spec('Siya', 'Bhatnagar', _f, 'Kapil', 'Megha', 'Advocate', 'Civil Lines', 2022, att: 95.5, blood: 'B+'),
    _Spec('Vivaan', 'Mishra', _m, 'Saurabh', 'Pallavi', 'Bank Officer (PNB)', 'Shastripuram', 2022, route: 'R4', att: 93.9, blood: 'O+'),
    _Spec('Yashika', 'Chauhan', _f, 'Deepak', 'Sonal', 'Business (Electronics)', 'Sikandra', 2023, route: 'R1', att: 94.6, blood: 'B+'),
  ],
};

/// Specific students placed into otherwise generated classes.
const Map<String, List<_Spec>> _pinned = {
  'UKG-A': [
    _Spec('Kiara', 'Bansal', _f, 'Mukesh', 'Ritu', 'Business (Marble)', 'Kamla Nagar', 0, att: 100, blood: 'O+', newAdmission: true),
  ],
};

/// Students who have left (not counted in class strength).
const _tcIssued = <String, _Spec>{
  'VII-B': _Spec('Aditya', 'Rawat', _m, 'Sanjay', 'Kusum', 'Indian Army', 'Sikandra', 2021, att: 91.0, blood: 'B+'),
  'IX-A': _Spec('Simran', 'Kaur', _f, 'Harpreet', 'Jaspreet', 'Business (Automobiles)', 'Civil Lines', 2019, att: 93.0, blood: 'A+'),
};

final List<Student> seedStudents = _buildStudents();

final Map<String, Student> studentById = {
  for (final s in seedStudents) s.id: s,
};

List<Student> studentsInClass(String classId) => seedStudents
    .where((s) => s.classId == classId && s.isActive)
    .toList()
  ..sort((a, b) => a.rollNo.compareTo(b.rollNo));

Student studentNamed(String name) =>
    seedStudents.firstWhere((s) => s.name == name);

/// Resolves either a full name ("Aarav Sharma") or a roll reference
/// ("IX-B#3" — class IX-B, roll number 3).
Student studentByKey(String key) {
  if (key.contains('#')) {
    final parts = key.split('#');
    final roll = int.parse(parts[1]);
    return seedStudents.firstWhere(
        (s) => s.classId == parts[0] && s.rollNo == roll && s.isActive);
  }
  return studentNamed(key);
}

List<Student> _buildStudents() {
  final rng = Random(2026);
  final startYear = DemoClock.sessionStart.year;
  T pick<T>(List<T> items) => items[rng.nextInt(items.length)];

  final usedNames = <String>{
    for (final list in [..._showcase.values, ..._pinned.values])
      for (final s in list) '${s.first} ${s.last}',
    for (final s in _tcIssued.values) '${s.first} ${s.last}',
  };
  final usedFathers = <String>{
    for (final list in _showcase.values)
      for (final s in list) '${s.father} ${s.last}',
  };

  final bloodPool = [
    for (final e in bloodGroupWeights.entries)
      for (var i = 0; i < e.value; i++) e.key,
  ];
  final localityNames = localities.keys.toList();
  const routeIds = ['R1', 'R2', 'R3', 'R4', 'R5', 'R6'];

  final seqByYear = <int, int>{};
  String admissionNo(int year) {
    final next = (seqByYear[year] ?? (18 + (year % 7) * 11)) + 1 + rng.nextInt(3);
    seqByYear[year] = next;
    return '${Branding.schoolCode}/$year/${next.toString().padLeft(4, '0')}';
  }

  String phone() =>
      '+91 ${pick(phonePrefixes)} ${(10000 + rng.nextInt(90000))}';

  List<_Spec> generate(SchoolClass c, int count) {
    final out = <_Spec>[];
    while (out.length < count) {
      final muslim = rng.nextDouble() < 0.06;
      final male = rng.nextDouble() < 0.53;
      final first = pick(muslim
          ? (male ? muslimBoyNames : muslimGirlNames)
          : (male ? boyNames : girlNames));
      final last = pick(muslim ? muslimSurnames : surnames);
      final father = pick(muslim ? muslimFatherNames : fatherNames);
      if (usedFathers.contains('$father $last')) continue;
      if (!usedNames.add('$first $last')) continue;
      out.add(_Spec(
        first,
        last,
        male ? _m : _f,
        father,
        pick(muslim ? muslimMotherNames : motherNames),
        pick(occupations),
        pick(localityNames),
        startYear - rng.nextInt(min(c.order, 8) + 1),
        route: rng.nextDouble() < 0.3 ? pick(routeIds) : null,
        att: 82 + rng.nextInt(176) / 10,
        blood: pick(bloodPool),
      ));
    }
    return out;
  }

  var counter = 0;
  Student build(_Spec s, SchoolClass c, int roll,
      {StudentStatus status = StudentStatus.active}) {
    final year = s.admittedIn == 0 ? startYear : s.admittedIn;
    final dob = DateTime(startYear - c.order - 4, 4, 1)
        .add(Duration(days: rng.nextInt(365)));
    final admitted = s.newAdmission
        ? DemoClock.today
        : DateTime(year, rng.nextBool() ? 3 : 4, 1 + rng.nextInt(27));
    final surname = s.last.split(' ').last.toLowerCase();
    const mailHosts = ['gmail.com', 'gmail.com', 'gmail.com', 'yahoo.co.in', 'rediffmail.com', 'outlook.com'];
    counter++;
    return Student(
      id: 'stu-${counter.toString().padLeft(4, '0')}',
      admissionNo: admissionNo(year),
      rollNo: roll,
      firstName: s.first,
      lastName: s.last,
      gender: s.gender,
      dob: dob,
      classId: c.id,
      fatherName: '${s.father} ${s.last}',
      motherName: '${s.mother} ${s.last}',
      fatherOccupation: s.occupation,
      phone: s.phone ?? phone(),
      email: '${s.father.toLowerCase()}.$surname${10 + rng.nextInt(89)}@${pick(mailHosts)}',
      address: '${1 + rng.nextInt(240)}, ${s.locality}, Agra – ${localities[s.locality] ?? '282005'}',
      bloodGroup: s.blood ?? pick(bloodPool),
      admissionDate: admitted,
      attendancePct: s.att ?? 92,
      status: status,
      routeId: status == StudentStatus.active ? s.route : null,
    );
  }

  final out = <Student>[];
  for (final c in schoolClasses) {
    final pinned = _pinned[c.id] ?? const <_Spec>[];
    final specs = [
      ...?_showcase[c.id],
      if (!_showcase.containsKey(c.id)) ...generate(c, c.strength - pinned.length),
      ...pinned,
    ]..sort((a, b) => '${a.first} ${a.last}'.compareTo('${b.first} ${b.last}'));
    assert(specs.length == c.strength, '${c.id}: ${specs.length} != ${c.strength}');
    for (var i = 0; i < specs.length; i++) {
      out.add(build(specs[i], c, i + 1));
    }
  }
  for (final e in _tcIssued.entries) {
    out.add(build(e.value, classById[e.key]!, 0, status: StudentStatus.tcIssued));
  }
  return out;
}
