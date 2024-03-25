import 'package:flutter/material.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/providers/project_provider.dart';

class SearchProvider extends ChangeNotifier {
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void updateProjectSearchQuery(String query, ProjectProvider projectProvider) {
    if (query.isEmpty) {
      projectProvider.fetchProjects();
    }
    _searchQuery = query;
    projectProvider.searchProjectsApi(query);
    notifyListeners();
  }

  void updateFreelancerSearchQuery(
      String query, FreelancerProfileProvider freelanceProvider) {
    // if (query.isEmpty) {
    //   return;
    // }
    _searchQuery = query;
    freelanceProvider.searchFreelancer(query);
    notifyListeners();
  }
}
