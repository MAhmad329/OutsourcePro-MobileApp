class FreelancerProfile {
  String firstname;
  String lastname;
  String username;
  String aboutMe;
  List<String> skills;
  List<EducationEntry> educationEntries;
  List<ExperienceEntry> experienceEntries;

  FreelancerProfile({
    this.firstname = '',
    this.lastname = '',
    this.username = '',
    this.aboutMe = '',
    this.skills = const [],
    this.educationEntries = const [],
    this.experienceEntries = const [],
  });
}

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
