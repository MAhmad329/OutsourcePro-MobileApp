import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/company.dart';
import '../models/project.dart';
import '../widgets/custom_snackbar.dart';

class CompanyProfileProvider extends ChangeNotifier {
  final CompanyProfile _profile = CompanyProfile();
  CompanyProfile get profile => _profile;
  bool _isUploading = false;
  bool get isUploading => _isUploading;
  String _ipAddress = '';
  String _cookie = '';

  void updateDependencies(String ipAddress, String cookie) {
    _ipAddress = ipAddress;
    _cookie = cookie;
    fetchCompanyDetails();
  }

  Future<void> uploadProfilePicture(BuildContext context) async {
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
          _profile.pfp = imageUrl;
          updateCompanyDetails();
          _isUploading = false;
          notifyListeners();
          ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar('Image uploaded successfully', Colors.grey));
        } else {
          _isUploading = false;
          notifyListeners();
          ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar('Failed to upload image', Colors.red));
          print(response.reasonPhrase);
        }
      } else {
        _isUploading = false;
        notifyListeners();
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar('No image selected', Colors.red));
      }
    } catch (e) {
      _isUploading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar('Error uploading profile picture', Colors.red));
      print(e.toString());
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCompanyDetails() async {
    if (_ipAddress.isEmpty || _cookie.isEmpty) {
      return;
    }
    try {
      var headers = {
        'Cookie': _cookie,
      };
      var request = http.Request(
          'GET', Uri.parse('http://$_ipAddress:3000/api/v1/company/details'));
      request.body = '''''';
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      Map<String, dynamic> jsonResponse =
          json.decode(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        _profile.id = jsonResponse['company']['_id'] ?? '';
        _profile.companyName = jsonResponse['company']['companyname'] ?? '';
        _profile.businessAddress =
            jsonResponse['company']['businessAddress'] ?? '';
        _profile.name = jsonResponse['company']['name'] ?? '';
        _profile.email = jsonResponse['company']['email'] ?? '';
        _profile.pfp = jsonResponse['company']['pfp'] ?? '';
        _profile.projects =
            (jsonResponse['company']['projects'] as List<dynamic>? ?? [])
                .map<Project?>((entry) {
                  try {
                    return Project.fromJson(entry as Map<String, dynamic>);
                  } catch (e) {
                    print("Error parsing project: $e");
                    return null;
                  }
                })
                .where((project) => project != null)
                .cast<Project>()
                .toList();

        notifyListeners();
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString);
    }
  }

  Future<void> updateCompanyDetails() async {
    if (_ipAddress.isEmpty || _cookie.isEmpty) {
      return;
    }
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': _cookie,
      };

      var request = http.Request('PUT',
          Uri.parse('http://$_ipAddress:3000/api/v1/company/updateprofile'));

      request.body = json.encode({
        "companyname": _profile.companyName,
        "businessAddress": _profile.businessAddress,
        "name": _profile.name,
        "email": _profile.email,
        "pfp": _profile.pfp,
        'projects': _profile.projects,
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
    } catch (e) {
      print(e.toString());
    }
  }
}
