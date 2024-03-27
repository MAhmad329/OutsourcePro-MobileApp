import 'package:outsourcepro/models/freelancer.dart';
import 'package:outsourcepro/models/project.dart';

class Team {
  final String id;
  final String name;
  final FreelancerProfile owner;
  final List<FreelancerProfile> members;
  final List<Project> projects;

  Team({
    required this.id,
    required this.name,
    required this.owner,
    required this.members,
    required this.projects,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    print('Owner type: ${json['owner'].runtimeType}');
    print('Members type: ${json['members'].runtimeType}');

    return Team(
      id: json['_id'],
      name: json['name'],
      owner: json['owner'] is Map<String, dynamic>
          ? FreelancerProfile.fromJson(json['owner'])
          : FreelancerProfile(
              id: json['owner']), // Handle the case where owner is a String
      members: List<FreelancerProfile>.from(
          json['members'].map((member) => FreelancerProfile.fromJson(member))),
      projects: List<Project>.from(
          json['projects'].map((project) => Project.fromJson(project))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'owner': owner.toJson(),
      'members': members,
      'projects': projects,
    };
  }
}
