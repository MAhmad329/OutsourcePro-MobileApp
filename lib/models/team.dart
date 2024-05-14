import 'package:outsourcepro/models/freelancer.dart';

class Team {
  final String id;
  final String name;
  final FreelancerProfile owner;
  final List<FreelancerProfile> members;
  final List<String> projects;
  final List<String> teamSkills;

  Team({
    required this.id,
    required this.name,
    required this.owner,
    required this.members,
    required this.projects,
    required this.teamSkills,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    print('Owner type: ${json['owner'].runtimeType}');
    print('Members type: ${json['members'].runtimeType}');

    return Team(
        id: json['_id'],
        name: json['name'],
        owner: FreelancerProfile.fromJson(json['owner']),
        teamSkills: List<String>.from(json['teamSkills'] ?? []),
        members: List<FreelancerProfile>.from(json['members']
            .map((member) => FreelancerProfile.fromJson(member))),
        projects: List<String>.from(json['projects'] ?? [])
        // List<Project>.from(
        //     json['projects'].map((project) => Project.fromJson(project))),
        );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'owner': owner.toJson(),
      'teamSkills': teamSkills,
      'members': members.map((e) => e.toJson()).toList(),
      'projects': projects,
    };
  }
}
