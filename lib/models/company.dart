import 'package:outsourcepro/models/project.dart';

class CompanyProfile {
  String id;
  String companyName;
  String businessAddress;
  String name;
  String email;
  String pfp;
  List<Project> projects;

  CompanyProfile({
    this.id = '',
    this.companyName = '',
    this.businessAddress = '',
    this.name = '',
    this.email = '',
    this.pfp = '',
    this.projects = const [],
  });

  factory CompanyProfile.fromJson(Map<String, dynamic> json) {
    return CompanyProfile(
      id: json['_id'] ?? '',
      companyName: json['companyname'] ?? '',
      businessAddress: json['businessAddress'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      pfp: json['pfp'] ?? '',
      projects: (json['projects'] as List? ?? [])
          .map((e) => e is Map<String, dynamic> ? Project.fromJson(e) : null)
          .where((e) => e != null)
          .cast<Project>()
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'companyname': companyName,
      'businessAddress': businessAddress,
      'name': name,
      'email': email,
      'pfp': pfp,
      'projects': projects.map((e) => e.toJson()).toList(),
    };
  }
}
