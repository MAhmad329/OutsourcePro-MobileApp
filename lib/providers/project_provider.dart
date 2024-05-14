import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:outsourcepro/widgets/custom_snackbar.dart';

import '../models/project.dart';
import '../models/project_filter.dart';
import '../models/task.dart';

class ProjectProvider extends ChangeNotifier {
  List<Project> _projects = [];
  List<Project> get projects => _projects;

  List<Project> _companySoloprojects = [];
  List<Project> get companySoloProjects => _companySoloprojects;

  List<Project> _companyTeamprojects = [];
  List<Project> get companyTeamProjects => _companyTeamprojects;

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Project> _soloAssignedProjects = [];
  List<Project> _teamAssignedProjects = [];
  List<Project> _teamAppliedProjects = [];
  List<Project> get soloAssignedProjects => _soloAssignedProjects;
  List<Project> get teamAssignedProjects => _teamAssignedProjects;
  List<Project> get teamAppliedProjects => _teamAppliedProjects;
  String _ipAddress = '';
  String _cookie = '';

  ProjectProvider() {
    fetchProjects();
  }

  void reset() {
    _projects.clear();
    _companySoloprojects.clear();
    _companyTeamprojects.clear();
    _tasks.clear();
    _soloAssignedProjects.clear();
    _teamAssignedProjects.clear();
    _isLoading = false;
    notifyListeners();
  }

  void updateDependencies(String ipAddress, String cookie) {
    _ipAddress = ipAddress;
    _cookie = cookie;
    fetchProjects();
  }

  bool hasApplied(String projectId, String freelancerId, String? teamId) {
    Project project = projects.firstWhere((proj) => proj.id == projectId);
    if (project.requiresTeam) {
      return project.teamApplicants.any((team) => team.id == teamId);
    } else {
      return project.freelancerApplicants
          .any((freelancer) => freelancer.id == freelancerId);
    }
  }

  List<Project> filterProjects(ProjectFilter filter) {
    return _projects.where((project) {
      bool matchesType = filter.type == null || filter.type == project.type;
      bool matchesBudget =
          (filter.minBudget == null || project.budget >= filter.minBudget!) &&
              (filter.maxBudget == null || project.budget <= filter.maxBudget!);
      bool matchesTechnology = filter.technology == null ||
          project.requiredMembers.contains(filter.technology!);
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

  Future<void> getProjectTasks(String projectId) async {
    try {
      var headers = {
        'Cookie': _cookie,
      };
      var request = http.Request(
          'GET',
          Uri.parse(
              'http://$_ipAddress:3000/api/v1/Freelancer/$projectId/getTasks'));
      request.body = '''''';
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> responseData = json.decode(responseString);
        List<dynamic> taskData = responseData['tasks'];
        _tasks = taskData.map((data) => Task.fromJson(data)).toList();
        notifyListeners();
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getSoloAssignedProjects() async {
    try {
      var headers = {'Cookie': _cookie};
      var request = http.Request(
          'GET',
          Uri.parse(
              'http://$_ipAddress:3000/api/v1/project/mySoloAssignedProjects'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print('success');
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> responseData = json.decode(responseString);
        List<dynamic> projectsData = responseData['Projects'];
        _soloAssignedProjects =
            projectsData.map((data) => Project.fromJson(data)).toList();
        notifyListeners();
        print(responseString);
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getTeamAssignedProjects() async {
    try {
      var headers = {'Cookie': _cookie};
      var request = http.Request(
          'GET',
          Uri.parse(
              'http://$_ipAddress:3000/api/v1/project/myTeamAssignedProjects'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> responseData = json.decode(responseString);
        List<dynamic> projectsData = responseData['Projects'];
        _teamAssignedProjects =
            projectsData.map((data) => Project.fromJson(data)).toList();
        notifyListeners();
        print(responseString);
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getTeamAppliedProjects() async {
    try {
      var headers = {'Cookie': _cookie};
      var request = http.Request(
          'GET',
          Uri.parse(
              'http://$_ipAddress:3000/api/v1/project/myAppliedProjects'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> responseData = json.decode(responseString);
        List<dynamic> projectsData = responseData['Projects'];
        _teamAssignedProjects =
            projectsData.map((data) => Project.fromJson(data)).toList();
        notifyListeners();
        print(responseString);
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> applyToProject(String projectId, BuildContext context,
      {Function? onSuccess}) async {
    try {
      var headers = {'Content-Type': 'application/json', 'Cookie': _cookie};
      var request = http.Request(
          'POST',
          Uri.parse(
              'http://$_ipAddress:3000/api/v1/project/applyToProject/$projectId'));
      request.body = '''''';
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

  Future<void> applyToProjectAsTeam(String projectId, BuildContext context,
      {Function? onSuccess}) async {
    try {
      var headers = {'Content-Type': 'application/json', 'Cookie': _cookie};
      var request = http.Request(
          'POST',
          Uri.parse(
              'http://$_ipAddress:3000/api/v1/project/applyToProjectasTeam/$projectId'));
      request.body = '''''';
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

  Future<void> cancelApplication(String projectId, BuildContext context,
      {Function? onSuccess}) async {
    try {
      var headers = {'Content-Type': 'application/json', 'Cookie': _cookie};
      var request = http.Request(
          'PUT',
          Uri.parse(
              'http://$_ipAddress:3000/api/v1/project/cancelApply/$projectId'));
      request.body = '''''';
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
      var request = http.Request(
          'GET',
          Uri.parse(
              'http://$_ipAddress:3000/api/v1/project/getProjectsMobile'));
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

  Future<void> getCompanyTeamProjects() async {
    try {
      var headers = {'Cookie': _cookie};
      var request = http.Request(
          'GET',
          Uri.parse(
              'http://$_ipAddress:3000/api/v1/Project/getmyTeamprojectsWithOwner'));
      request.body = '''''';
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print('CALLED');
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> responseData = json.decode(responseString);
        List<dynamic> projectsData = responseData['data'];
        _companyTeamprojects =
            projectsData.map((data) => Project.fromJson(data)).toList();
        print(_companyTeamprojects);
        notifyListeners();
        //print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getCompanySoloProjects() async {
    try {
      var headers = {'Cookie': _cookie};
      var request = http.Request(
          'GET',
          Uri.parse(
              'http://$_ipAddress:3000/api/v1/Project/getmyFreelancerprojects'));
      request.body = '''''';
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> responseData = json.decode(responseString);
        List<dynamic> projectsData = responseData['data'];
        _companySoloprojects =
            projectsData.map((data) => Project.fromJson(data)).toList();
        print(_companySoloprojects);
        notifyListeners();
        // print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
