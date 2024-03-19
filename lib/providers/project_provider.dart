import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/project.dart';
import '../models/project_filter.dart';

class ProjectProvider extends ChangeNotifier {
  List<Project> _projects = [];
  List<Project> get projects => _projects;
  String _ipAddress = '';

  ProjectProvider() {
    fetchProjects();
  }
  void updateDependencies(String ipAddress) {
    _ipAddress = ipAddress;
    fetchProjects();
  }

  List<Project> filterProjects(ProjectFilter filter) {
    return _projects.where((project) {
      bool matchesType = filter.type == null || filter.type == project.type;
      bool matchesBudget =
          (filter.minBudget == null || project.budget >= filter.minBudget!) &&
              (filter.maxBudget == null || project.budget <= filter.maxBudget!);
      bool matchesTechnology = filter.technology == null ||
          project.technologyStack.contains(filter.technology!);
      return matchesType && matchesBudget && matchesTechnology;
    }).toList();
  }

  List<Project> searchProjects(String query) {
    return _projects.where((project) {
      final titleLower = project.title.toLowerCase();
      final queryLower = query.toLowerCase();
      return titleLower.contains(queryLower);
    }).toList();
  }

  Future<void> fetchProjects() async {
    try {
      var request = http.Request('GET',
          Uri.parse('http://$_ipAddress:3000/api/v1/project/getProjects'));
      request.body = '''''';

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // Decode the JSON response and update the projects list
        Map<String, dynamic> responseData =
            json.decode(await response.stream.bytesToString());
        print(responseData);

        if (responseData['success'] == true) {
          List<dynamic> projectsData = responseData['projects'];
          _projects =
              projectsData.map((data) => Project.fromJson(data)).toList();
          notifyListeners();
        } else {
          print('API request was not successful');
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Error fetching projects: $error');
    }
  }
}
