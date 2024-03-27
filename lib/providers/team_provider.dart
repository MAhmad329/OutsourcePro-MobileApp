import 'dart:convert'; // Import for json decoding

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:outsourcepro/models/team.dart'; // Import your Team model

class TeamProvider extends ChangeNotifier {
  Team? _team;
  Team? get team => _team;
  String _cookie = '';
  String _ipAddress = '';
  TeamProvider() {
    fetchTeam();
  }
  void updateDependencies(String ipAddress, String cookie) {
    _ipAddress = ipAddress;
    _cookie = cookie;
    fetchTeam();
  }

  Future<void> fetchTeam() async {
    if (_ipAddress.isEmpty || _cookie.isEmpty) {
      return;
    }
    try {
      var headers = {'Cookie': _cookie};
      var request = http.Request('GET',
          Uri.parse('http://$_ipAddress:3000/api/v1/Freelancer/fetchteam'));

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
}
