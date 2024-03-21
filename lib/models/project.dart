class Project {
  final String id;
  final String title;
  final String description;
  final String type;
  final String technologyStack;
  final int budget;
  final List<dynamic> freelancerApplicants;
  final List<dynamic> teamApplicants;
  final bool requiresTeam;
  final String? selectedApplicant;
  final DateTime createdAt;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.technologyStack,
    required this.budget,
    required this.freelancerApplicants,
    required this.teamApplicants,
    required this.requiresTeam,
    this.selectedApplicant,
    required this.createdAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      technologyStack: json['technologystack'],
      budget: json['budget'],
      freelancerApplicants:
          List<dynamic>.from(json['freelancerApplicants'] ?? []),
      teamApplicants: List<dynamic>.from(json['teamApplicants'] ?? []),
      requiresTeam: json['requiresTeam'] ?? false,
      selectedApplicant: json['selectedApplicant'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
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
