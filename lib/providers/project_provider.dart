import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:outsourcepro/widgets/custom_snackbar.dart';

import '../models/project.dart';
import '../models/project_filter.dart';

class ProjectProvider extends ChangeNotifier {
  List<Project> _projects = [];
  List<Project> get projects => _projects;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _ipAddress = '';
  String _cookie = '';

  ProjectProvider() {
    fetchProjects();
  }
  void updateDependencies(String ipAddress, String cookie) {
    _ipAddress = ipAddress;
    _cookie = cookie;
    fetchProjects();
  }

  bool hasApplied(String projectId, String freelancerId) {
    Project project = projects.firstWhere((proj) => proj.id == projectId);
    return project.freelancerApplicants.contains(freelancerId);
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

  Future<void> searchProjectsApi(String query) async {
    if (_ipAddress.isEmpty || _cookie.isEmpty) {
      return;
    }
    _isLoading = true;
    notifyListeners();
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST',
        Uri.parse('http://$_ipAddress:3000/api/v1/project/searchProject'));
    request.body = json.encode({"title": query});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("search api working correctly");
      // Decode the JSON response and update the projects list
      Map<String, dynamic> responseData =
          json.decode(await response.stream.bytesToString());
      print(responseData);

      if (responseData['success'] == true) {
        List<dynamic> projectsData = responseData['project'];
        _projects = projectsData.map((data) => Project.fromJson(data)).toList();
        notifyListeners();
      } else {
        print('API request was not successful');
      }
    } else {
      print(response.reasonPhrase);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> applyToProject(
      String projectId, String freelancerId, BuildContext context,
      {Function? onSuccess}) async {
    try {
      var headers = {'Content-Type': 'application/json', 'Cookie': _cookie};
      var request = http.Request(
          'POST',
          Uri.parse(
              'http://$_ipAddress:3000/api/v1/project/applyToProject/$projectId'));
      request.body = json.encode({"freelancerID": freelancerId});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // Decode the JSON response
        Map<String, dynamic> responseData =
            json.decode(await response.stream.bytesToString());
        print(responseData);

        if (responseData['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar('Project Applied Successfully', Colors.grey));
          fetchProjects();
          if (onSuccess != null) {
            onSuccess(); // Call the callback function
          }
        } else {
          print('API request was not successful: ${responseData['message']}');
          ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
              'There was an error applying to project', Colors.red));
        }
      } else {
        print(response.reasonPhrase);
        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
            'You have already applied to this project', Colors.grey));
      }
    } catch (error) {
      print('Error applying to project: $error');
      ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar('There was an error applying to project', Colors.red));
    }
  }

  Future<void> cancelApplication(
      String projectId, String freelancerId, BuildContext context,
      {Function? onSuccess}) async {
    try {
      var headers = {'Content-Type': 'application/json', 'Cookie': _cookie};
      var request = http.Request(
          'PUT',
          Uri.parse(
              'http://$_ipAddress:3000/api/v1/project/cancelApply/$projectId'));
      request.body = json.encode({"freelancerID": freelancerId});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // Decode the JSON response
        Map<String, dynamic> responseData =
            json.decode(await response.stream.bytesToString());
        print(responseData);

        if (responseData['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
              'Project Application Cancelled Successfully', Colors.grey));
          fetchProjects();
          if (onSuccess != null) {
            onSuccess(); // Call the callback function
          }
        } else {
          print('API request was not successful: ${responseData['message']}');
          ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar('There was an error cancelling!', Colors.red));
        }
      } else {
        print(response.reasonPhrase);
        ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar('There was an error cancelling!', Colors.grey));
      }
    } catch (error) {
      print('Error applying to project: $error');
      ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar('There was an error cancelling!', Colors.red));
    }
  }

  Future<void> fetchProjects() async {
    if (_ipAddress.isEmpty || _cookie.isEmpty) {
      return;
    }
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
