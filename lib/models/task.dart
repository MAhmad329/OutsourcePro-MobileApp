import 'package:outsourcepro/models/freelancer.dart';

class Task {
  String? id;
  String? description;
  List<FreelancerProfile>? assignee;
  String? owner;
  List<dynamic>? submittedWork;
  DateTime? deadline;
  String? status;
  String? team;
  String? project;

  Task({
    this.id,
    this.description,
    this.assignee,
    this.owner,
    this.submittedWork,
    this.deadline,
    this.status,
    this.team,
    this.project,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      description: json['description'],
      assignee: json['assignee'] != null
          ? List<FreelancerProfile>.from(
              json['assignee'].map((x) => FreelancerProfile.fromJson(x)))
          : [],
      owner: json['owner'],
      submittedWork: json['submittedWork'] ?? [],
      deadline: DateTime.parse(json['deadline']),
      status: json['status'],
      team: json['team'],
      project: json['project'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'description': description,
      'assignee': assignee?.map((x) => x.toJson()).toList(),
      'owner': owner,
      'submittedWork': submittedWork,
      'deadline': deadline?.toIso8601String(),
      'status': status,
      'team': team,
      'project': project,
    };
  }
}
