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
  Map<String, dynamic> toJson() {
    return {
      'jobtitle': jobtitle,
      'company': company,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  factory ExperienceEntry.fromJson(Map<String, dynamic> json) {
    return ExperienceEntry(
      jobtitle: json['jobtitle'],
      company: json['company'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }
}
