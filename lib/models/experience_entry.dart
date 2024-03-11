class ExperienceEntry {
  final String jobtitle;
  final String company;
  final String startDate;
  final String endDate;

  ExperienceEntry({
    required this.jobtitle,
    required this.company,
    required this.startDate,
    required this.endDate,
  });
  Map<String, dynamic> toMap() {
    return {
      'jobtitle': jobtitle,
      'company': company,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
