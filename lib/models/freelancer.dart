import 'package:outsourcepro/models/education_entry.dart';
import 'package:outsourcepro/models/experience_entry.dart';
import 'package:outsourcepro/models/project.dart';

class FreelancerProfile {
  String id;
  String firstname;
  String lastname;
  String username;
  String aboutMe;
  String pfp;
  List<String> skills;
  List<EducationEntry> educationEntries;
  List<ExperienceEntry> experienceEntries;
  List<Project> appliedProjects;

  FreelancerProfile({
    this.id = '',
    this.firstname = '',
    this.lastname = '',
    this.username = '',
    this.aboutMe = '',
    this.pfp = '',
    this.skills = const [],
    this.educationEntries = const [],
    this.experienceEntries = const [],
    this.appliedProjects = const [],
  });

  factory FreelancerProfile.fromJson(Map<String, dynamic> json) {
    return FreelancerProfile(
      id: json['_id'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      username: json['username'] ?? '',
      aboutMe: json['aboutMe'] ?? '',
      pfp: json['pfp'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      educationEntries: (json['education'] as List? ?? [])
          .map((e) =>
              e is Map<String, dynamic> ? EducationEntry.fromJson(e) : null)
          .where((e) => e != null)
          .cast<EducationEntry>()
          .toList(),
      experienceEntries: (json['experience'] as List? ?? [])
          .map((e) =>
              e is Map<String, dynamic> ? ExperienceEntry.fromJson(e) : null)
          .where((e) => e != null)
          .cast<ExperienceEntry>()
          .toList(),
      appliedProjects: (json['appliedProjects'] as List? ?? [])
          .map((e) => e is Map<String, dynamic> ? Project.fromJson(e) : null)
          .where((e) => e != null)
          .cast<Project>()
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'aboutMe': aboutMe,
      'pfp': pfp,
      'skills': skills,
      'education': educationEntries.map((e) => e.toJson()).toList(),
      'experience': experienceEntries.map((e) => e.toJson()).toList(),
      'appliedProjects': appliedProjects.map((e) => e.toJson()).toList(),
    };
  }
}
