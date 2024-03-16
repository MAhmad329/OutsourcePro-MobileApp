// auth_provider.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:outsourcepro/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> login(
    BuildContext context,
    String ipaddress,
    String email,
    String password,
    String type,
  ) async {
    _isLoading = true;
    notifyListeners();

    final ipaddress = context.read<IPAddressProvider>().ipaddress;

    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
        'POST', Uri.parse('http://$ipaddress:3000/api/v1/$type/login'));
    request.body = json.encode({
      "email": email,
      "password": password,
    });
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Provider.of<CookieProvider>(context, listen: false)
            .setCookie(response.headers['set-cookie']!);

        Navigator.pushReplacementNamed(
            context,
            type == 'freelancer'
                ? 'homepage_freelancer_screen'
                : 'homepage_screen');
      } else {
        String errorMessage = 'Login failed.';
        Map<String, dynamic> errorResponse =
            json.decode(await response.stream.bytesToString());
        if (errorResponse.containsKey('error')) {
          errorMessage = errorResponse['error'];
        } else if (errorResponse.containsKey('message')) {
          errorMessage = errorResponse['message'];
        }

        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            errorMessage,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          "Failed to sign in: ${e.toString()}",
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
