import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenProvider extends ChangeNotifier {
  String _cookie = '';
  String get cookie => _cookie;
  String ipaddress = '13.232.253.227';
  void setCookie(String cookie) {
    _cookie = cookie;
    _saveCookieToPrefs(cookie);
    notifyListeners();
  }

  Future<void> _saveCookieToPrefs(String cookie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cookie', cookie);
  }

  Future<void> loadCookieFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _cookie = prefs.getString('cookie') ?? '';
    notifyListeners();
  }

  void reset() {
    _cookie = '';
    notifyListeners();
  }
}
