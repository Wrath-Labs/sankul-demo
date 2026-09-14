enum Gender { male, female }

enum StudentStatus { active, tcIssued }

class Student {
  const Student({
    required this.id,
    required this.admissionNo,
    required this.rollNo,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dob,
    required this.classId,
    required this.fatherName,
    required this.motherName,
    required this.fatherOccupation,
    required this.phone,
    required this.email,
    required this.address,
    required this.bloodGroup,
    required this.admissionDate,
    required this.attendancePct,
    this.status = StudentStatus.active,
    this.routeId,
  });

  final String id;

  /// SPS/2019/0142
  final String admissionNo;
  final int rollNo;
  final String firstName;
  final String lastName;
  final Gender gender;
  final DateTime dob;

  /// 'VIII-A'
  final String classId;
  final String fatherName;
  final String motherName;
  final String fatherOccupation;

  /// Guardian mobile, used for SMS / WhatsApp.
  final String phone;
  final String email;
  final String address;
  final String bloodGroup;
  final DateTime admissionDate;

  /// Session-to-date attendance percentage.
  final double attendancePct;
  final StudentStatus status;

  /// Transport route, or null if the child does not use school transport.
  final String? routeId;

  String get name => '$firstName $lastName';
  String get grade => classId.substring(0, classId.lastIndexOf('-'));
  String get section => classId.substring(classId.lastIndexOf('-') + 1);
  bool get isActive => status == StudentStatus.active;
  bool get usesTransport => routeId != null;
  String get genderLabel => gender == Gender.male ? 'Male' : 'Female';
}
