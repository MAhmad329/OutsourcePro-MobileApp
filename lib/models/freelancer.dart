import 'education_entry.dart';
import 'experience_entry.dart';

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
