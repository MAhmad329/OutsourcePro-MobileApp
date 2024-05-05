import 'package:intl/intl.dart';

import 'company.dart';

class Project {
  final String id;
  final String title;
  final String description;
  final String type;

  final Company owner;

  final List<String> requiredMembers;
  final int budget;
  final List<dynamic> freelancerApplicants;
  final List<dynamic> teamApplicants;
  final bool requiresTeam;
  final String? selectedApplicant;
  final DateTime createdAt;
  final DateTime deadline;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.budget,
    required this.requiredMembers,
    required this.freelancerApplicants,
    required this.teamApplicants,
    required this.requiresTeam,
    required this.owner,
    this.selectedApplicant,
    required this.createdAt,
    required this.deadline,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      budget: json['budget'],
      requiredMembers: List<String>.from(json['requiredMembers'] ?? []),
      owner: json['owner'] is Map<String, dynamic>
          ? Company.fromJson(json['owner'])
          : Company(id: json['owner']),
      freelancerApplicants:
          List<dynamic>.from(json['freelancerApplicants'] ?? []),
      teamApplicants: List<dynamic>.from(json['teamApplicants'] ?? []),
      requiresTeam: json['requiresTeam'] ?? false,
      selectedApplicant: json['selectedApplicant'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'type': type,
      'requiredMembers': requiredMembers,
      'budget': budget,
      'owner': owner.toJson(),
      'freelancerApplicants': freelancerApplicants,
      'teamApplicants': teamApplicants,
      'requiresTeam': requiresTeam,
      'selectedApplicant': selectedApplicant,
      'createdAt': createdAt.toIso8601String(),
      'deadline': deadline.toIso8601String(),
    };
  }

  String timeAgo() {
    if (deadline.toIso8601String() == null) {
      return 'Unknown';
    }
    // Format the timestamp to only include the time
    return DateFormat('dd-MM-yyyy').format(deadline!);
  }

  String timeElapsed() {
    final duration = DateTime.now().difference(createdAt);
    if (duration.inDays > 365) {
      return '${(duration.inDays / 365).floor()} years ago';
    } else if (duration.inDays > 30) {
      return '${(duration.inDays / 30).floor()} months ago';
    } else if (duration.inDays > 7) {
      return '${(duration.inDays / 7).floor()} weeks ago';
    } else if (duration.inDays > 0) {
      return '${duration.inDays} days ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hours ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
