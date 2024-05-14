import 'dart:convert'; // Import for json decoding

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:outsourcepro/main.dart';
import 'package:outsourcepro/models/team.dart';

import '../widgets/custom_snackbar.dart'; // Import your Team model

class TeamProvider extends ChangeNotifier {
  Team? _team;
  Team? get team => _team;
  String _cookie = '';
  String _ipAddress = '';

  bool _isLoading = false; // New loading state property

  bool get isLoading => _isLoading; // Getter for loading state

  void setLoading(bool loading) {
    // Setter for loading state
    _isLoading = loading;
    notifyListeners(); // Notify UI of state change
  }

  void reset() {
    _team = null;
    _isLoading = false;
    notifyListeners();
  }

  void updateDependencies(String ipAddress, String cookie) {
    _ipAddress = ipAddress;
    _cookie = cookie;
  }

  Map<String, String> get teamMemberUsernames {
    return Map.fromIterable(_team?.members ?? [],
        key: (member) => member.id, value: (member) => member.username);
  }

  Future<void> fetchTeam() async {
    if (_ipAddress.isEmpty || _cookie.isEmpty) {
      return;
    }
    try {
      var headers = {'Cookie': _cookie};
      var request = http.Request(
          'GET',
          Uri.parse(
              'http://$_ipAddress:3000/api/v1/Freelancer/fetchteamMobile'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var decodedResponse =
            json.decode(responseBody); // Decode the JSON string
        _team = Team.fromJson(decodedResponse['freelancer']
            ['teams']); // Pass the decoded map to fromJson
        notifyListeners(); // Notify listeners that the data has changed
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addToTeam(
      String memberId, BuildContext context, bool isLastScreen) async {
    setLoading(true); // Start loading
    try {
      var headers = {'Content-Type': 'application/json', 'Cookie': _cookie};
      var request = http.Request('POST',
          Uri.parse('http://$_ipAddress:3000/api/v1/Freelancer/addTeamMember'));
      request.body = json.encode({"memberID": memberId});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        await fetchTeam();
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar('Team Member Added', Colors.grey));
        if (isLastScreen) {
          navigatorKey.currentState?.pop();
          navigatorKey.currentState?.pop();
        } else {
          navigatorKey.currentState?.pop();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
            'Freelancer already a part of another team!', Colors.red));
        if (isLastScreen) {
          navigatorKey.currentState?.pop();
          navigatorKey.currentState?.pop();
        } else {
          navigatorKey.currentState?.pop();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(e.toString(), Colors.grey));
      if (isLastScreen) {
        navigatorKey.currentState?.pop();
        navigatorKey.currentState?.pop();
      } else {
        navigatorKey.currentState?.pop();
      }
    } finally {
      setLoading(false); // Stop loading
    }
  }

  Future<void> exitTeam(String memberId, String userId) async {
    try {
      var headers = {'Content-Type': 'application/json', 'Cookie': _cookie};
      var request = http.Request('POST',
          Uri.parse('http://$_ipAddress:3000/api/v1/Freelancer/deleteMember'));
      print(memberId);
      request.body = json.encode({"memberID": memberId});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        if (memberId != userId) {
          await fetchTeam();
          notifyListeners();
        } else if (memberId == userId) {
          _team = null;
          notifyListeners();
        }

        print(await response.stream.bytesToString());
      } else {
        print('Error: ${response.statusCode}');
        print(await response.stream.bytesToString());
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
