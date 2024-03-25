// auth_provider.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:outsourcepro/providers/token_provider.dart';
import 'package:outsourcepro/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;

  String _passwordResetEmail = '';

  String get passwordResetEmail => _passwordResetEmail;

  bool get isLoading => _isLoading;

  void setEmail(String email) {
    _passwordResetEmail = email;
    notifyListeners();
  }

  Future<void> login(
    BuildContext context,
    String ipaddress,
    String email,
    String password,
    String type,
  ) async {
    _isLoading = true;
    notifyListeners();

    final ipaddress = context.read<TokenProvider>().ipaddress;
    try {
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

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Provider.of<TokenProvider>(context, listen: false)
            .setCookie(response.headers['set-cookie']!);
        navigatorKey.currentState?.pushReplacementNamed(
            type == 'freelancer' ? 'homepage_screen' : 'homepage_screen');
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
          customSnackBar(errorMessage, Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar("Failed to sign in: ${e.toString()}", Colors.red),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendResetCode(String ipAddress, String cookie,
      BuildContext context, String type) async {
    _isLoading = true;
    notifyListeners();
    try {
      var headers = {'Content-Type': 'application/json', 'Cookie': cookie};
      var request = http.Request('POST',
          Uri.parse('http://$ipAddress:3000/api/v1/$type/forgetpassword'));
      print(_passwordResetEmail);
      request.body = json.encode({"email": _passwordResetEmail});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        print(await response.stream.bytesToString());
        if (type == 'freelancer') {
          navigatorKey.currentState?.pushNamed('reset_code_freelancer');
        } else {
          navigatorKey.currentState?.pushNamed('reset_code_company');
        }
      } else {
        _isLoading = false;
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar('Email does not exist!', Colors.red),
        );
        print(response.reasonPhrase);
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar('There was an error sending the code!', Colors.red),
      );
      print(e.toString());
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> resetPassword(String ipAddress, String cookie, String resetCode,
      BuildContext context, String type) async {
    _isLoading = true;
    notifyListeners();
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': cookie,
      };
      var request = http.Request('POST',
          Uri.parse('http://$ipAddress:3000/api/v1/$type/resetpassword'));
      request.body = json.encode({"resetPasswordToken": resetCode});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        if (type == 'freelancer') {
          navigatorKey.currentState?.pushNamed('new_password_freelancer');
        } else {
          navigatorKey.currentState?.pushNamed('new_password_company');
        }
      } else {
        _isLoading = false;
        notifyListeners();
        print(response.reasonPhrase);
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar('Code is invalid or has been expired', Colors.red),
        );
      }
      print(await response.stream.bytesToString());
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
            'There was an error processing the request!', Colors.red),
      );
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setNewPassword(String ipAddress, String cookie, String password,
      BuildContext context, String type) async {
    _isLoading = true;
    notifyListeners();
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': cookie,
      };
      var request = http.Request('PUT',
          Uri.parse('http://$ipAddress:3000/api/v1/$type/setnewpassword'));
      request.body =
          json.encode({"email": _passwordResetEmail, "password": password});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        print(await response.stream.bytesToString());
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar('Password changed successfully', Colors.grey),
        );
        navigatorKey.currentState?.pop();
        navigatorKey.currentState?.pop();
        navigatorKey.currentState?.pop();
      } else {
        _isLoading = false;
        notifyListeners();
        print(response.reasonPhrase);
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar('Password too short', Colors.red),
        );
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar('There was an error changing the password', Colors.red),
      );
    }
    _isLoading = false;
    notifyListeners();
  }
}
