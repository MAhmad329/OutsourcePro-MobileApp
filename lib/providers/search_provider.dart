import 'package:flutter/material.dart';
import 'package:outsourcepro/providers/project_provider.dart';

class SearchProvider extends ChangeNotifier {
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void updateSearchQuery(String query, ProjectProvider projectProvider) {
    if (query.isEmpty) {
      projectProvider.fetchProjects();
    }
    _searchQuery = query;
    projectProvider.searchProjectsApi(query);
    notifyListeners();
  }
}
