import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/project.dart';

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
