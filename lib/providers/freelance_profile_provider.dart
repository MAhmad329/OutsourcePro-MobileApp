import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/education_entry.dart';
import '../models/experience_entry.dart';
import '../models/freelancer.dart';

class FreelancerProfileProvider extends ChangeNotifier {
  final FreelancerProfile _profile = FreelancerProfile();
  String _ipAddress = '';
  bool _isUploading = false;
  bool get isUploading => _isUploading;
  String _cookie = '';

  FreelancerProfile get profile => _profile;

  FreelancerProfileProvider() {
    fetchFreelancerDetails();
  }

  void updateDependencies(String ipAddress, String cookie) {
    _ipAddress = ipAddress;
    _cookie = cookie;
    fetchFreelancerDetails();
  }

  Future<void> fetchFreelancerDetails() async {
    if (_ipAddress.isEmpty || _cookie.isEmpty) {
      return;
    }
    var headers = {
      'Cookie': _cookie,
    };
    var request = http.Request(
        'GET', Uri.parse('http://$_ipAddress:3000/api/v1/freelancer/details'));
    request.body = '''''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    Map<String, dynamic> jsonResponse =
        json.decode(await response.stream.bytesToString());
    if (response.statusCode == 200) {
      _profile.firstname = jsonResponse['freelancer']['firstname'] ?? '';
      _profile.lastname = jsonResponse['freelancer']['lastname'] ?? '';
      _profile.username = jsonResponse['freelancer']['username'] ?? '';
      _profile.aboutMe = jsonResponse['freelancer']['aboutme'] ?? '';
      _profile.pfp = jsonResponse['freelancer']['pfp'] ?? '';
      _profile.skills =
          List<String>.from(jsonResponse['freelancer']['skills'] ?? []);
      _profile.educationEntries =
          (jsonResponse['freelancer']['education'] ?? [])
              .map<EducationEntry>((entry) => EducationEntry(
                    institution: entry['institution'] ?? '',
                    course: entry['course'] ?? '',
                    startDate: entry['startDate'] ?? '',
                    endDate: entry['endDate'] ?? '',
                  ))
              .toList();
      _profile.experienceEntries =
          (jsonResponse['freelancer']['experience'] ?? [])
              .map<ExperienceEntry>((entry) => ExperienceEntry(
                    jobtitle: entry['jobtitle'] ?? '',
                    company: entry['company'] ?? '',
                    startDate: entry['startDate'] ?? '',
                    endDate: entry['endDate'] ?? '',
                  ))
              .toList();
      notifyListeners();
    }
  }

  Future<void> uploadProfilePicture() async {
    if (_ipAddress.isEmpty || _cookie.isEmpty) {
      return;
    }

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        _isUploading = true;
        notifyListeners();
        var headers = {
          'Cookie': _cookie,
        };
        var request = http.MultipartRequest(
            'POST', Uri.parse('http://$_ipAddress:3000/api/v1/uploadFile'));
        request.files.add(
            await http.MultipartFile.fromPath('filename', pickedFile.path));
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          String responseBody = await response.stream.bytesToString();
          Map<String, dynamic> jsonResponse = json.decode(responseBody);
          String imageUrl = jsonResponse['url'];
          print(imageUrl);
          _profile.pfp = imageUrl;
          updateFreelancerDetails();
          _isUploading = false;
          notifyListeners();
        } else {
          _isUploading = false;
          notifyListeners();
          print('Failed to upload image: ${response.reasonPhrase}');
        }
      } else {
        _isUploading = false;
        notifyListeners();
        print('No image selected.');
      }
    } catch (e) {
      _isUploading = false;
      notifyListeners();
      print('Error uploading profile picture: $e');
    }
  }

  Future<void> updateFreelancerDetails() async {
    if (_ipAddress.isEmpty || _cookie.isEmpty) {
      return;
    }
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': _cookie,
    };

    var request = http.Request('PUT',
        Uri.parse('http://$_ipAddress:3000/api/v1/freelancer/updateprofile'));

    // Convert education entries and experience entries to map format
    List<Map<String, dynamic>> existingEducationEntries =
        _profile.educationEntries.map((entry) => entry.toMap()).toList();

    List<Map<String, dynamic>> existingExperienceEntries =
        _profile.experienceEntries.map((entry) => entry.toMap()).toList();

    request.body = json.encode({
      "firstname": _profile.firstname,
      "lastname": _profile.lastname,
      "aboutme": _profile.aboutMe,
      "skills": _profile.skills,
      "education": existingEducationEntries,
      "experience": existingExperienceEntries,
      "pfp": _profile.pfp,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // Handle successful update
      print(await response.stream.bytesToString());
    } else {
      // Handle error
      print(response.reasonPhrase);
    }
  }

  // void updateProfile(FreelancerProfile newProfile) {
  //   _profile = newProfile;
  //   notifyListeners();
  // }

  void updateName(String firstname, String lastname) {
    _profile.firstname = firstname;
    _profile.lastname = lastname;
    updateFreelancerDetails();
    notifyListeners();
  }

  void updateUsername(String username) {
    _profile.username = username;
    notifyListeners();
  }

  void updateAboutMe(String aboutMe) {
    _profile.aboutMe = aboutMe;
    updateFreelancerDetails();
    notifyListeners();
  }

  void updateSkills(List<String> skills) {
    _profile.skills = skills;
    notifyListeners();
  }

  void addSkill(String skill) {
    _profile.skills.add(skill);
    updateFreelancerDetails();
    notifyListeners();
  }

  void removeSkill(int index) {
    _profile.skills.removeAt(index);
    updateFreelancerDetails();
    notifyListeners();
  }

  void updateEducationEntries(List<EducationEntry> educationEntries) {
    _profile.educationEntries = educationEntries;
    notifyListeners();
  }

  void addEducationEntry(EducationEntry entry) {
    _profile.educationEntries.add(entry);
    updateFreelancerDetails();
    notifyListeners();
  }

  void updateEducationEntry(int index, EducationEntry updatedEntry) {
    _profile.educationEntries[index] = updatedEntry;
    updateFreelancerDetails();
    notifyListeners();
  }

  void updateExperienceEntries(List<ExperienceEntry> experienceEntries) {
    _profile.experienceEntries = experienceEntries;
    notifyListeners();
  }

  void updateExperienceEntry(int index, ExperienceEntry updatedEntry) {
    _profile.experienceEntries[index] = updatedEntry;
    notifyListeners();
  }

  void addExperienceEntry(ExperienceEntry entry) {
    _profile.experienceEntries.add(entry);
    updateFreelancerDetails();
    notifyListeners();
  }

// Add more methods to update other fields of the profile as needed
}
