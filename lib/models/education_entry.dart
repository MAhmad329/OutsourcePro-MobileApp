class EducationEntry {
  final String institution;
  final String course;
  final String startDate;
  final String endDate;

  EducationEntry({
    required this.institution,
    required this.course,
    required this.startDate,
    required this.endDate,
  });
  Map<String, dynamic> toMap() {
    return {
      'institution': institution,
      'course': course,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
