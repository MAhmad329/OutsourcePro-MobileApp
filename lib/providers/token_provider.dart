import 'package:flutter/material.dart';

class TokenProvider extends ChangeNotifier {
  String cookie = '';
  String ipaddress = '52.66.159.154';
  void setCookie(String value) {
    cookie = value;
    notifyListeners();
  }
}
