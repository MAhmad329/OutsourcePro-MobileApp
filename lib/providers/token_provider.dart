import 'package:flutter/material.dart';

class TokenProvider extends ChangeNotifier {
  String cookie = '';
  String ipaddress = '192.168.0.113';
  void setCookie(String value) {
    cookie = value;
    notifyListeners();
  }
}
