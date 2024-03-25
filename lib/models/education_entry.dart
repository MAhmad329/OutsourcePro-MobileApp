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
  Map<String, dynamic> toJson() {
    return {
      'institution': institution,
      'course': course,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  factory EducationEntry.fromJson(Map<String, dynamic> json) {
    return EducationEntry(
      institution: json['institution'],
      course: json['course'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }
}
