/// A class section, e.g. VIII-A.
class SchoolClass {
  const SchoolClass({
    required this.grade,
    required this.section,
    required this.order,
    required this.strength,
    this.stream,
  });

  /// 'Nursery', 'LKG', 'UKG', 'I' … 'XII'
  final String grade;
  final String section;

  /// 0 = Nursery … 14 = XII. Used for sorting and age calculations.
  final int order;

  /// Number of active students on the rolls.
  final int strength;

  /// 'Science' / 'Commerce' for XI–XII.
  final String? stream;

  String get id => '$grade-$section';
  String get label => stream == null ? id : '$id · $stream';
  bool get isPrePrimary => order <= 2;
  bool get isPrimary => order >= 3 && order <= 7;
}
