class Project {
  final String id;
  final String title;
  final String description;
  final String type;
  final String technologyStack;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.technologyStack,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      technologyStack: json['technologystack'],
    );
  }
}
