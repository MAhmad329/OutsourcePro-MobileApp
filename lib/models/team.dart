import 'package:outsourcepro/models/freelancer.dart';
import 'package:outsourcepro/models/project.dart';

class Team {
  final String id;
  final String name;
  final List<FreelancerProfile> members;
  final List<Project> projects;

  Team({
    required this.id,
    required this.name,
    required this.members,
    required this.projects,
  });

  // Factory method to create a Team object from a JSON map
  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['_id'],
      name: json['name'],
      members: List<FreelancerProfile>.from(json['members']),
      projects: List<Project>.from(json['projects']),
    );
  }

  // Method to convert a Team object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'members': members,
      'projects': projects,
    };
  }
}
