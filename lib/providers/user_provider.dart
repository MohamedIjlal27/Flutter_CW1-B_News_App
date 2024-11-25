import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _uid;
  String? _username;

  String? get uid => _uid;
  String? get username => _username;

  void setUser(String? uid, String? username) {
    _uid = uid;
    _username = username;
    notifyListeners();
  }

  void clearUser() {
    _uid = null;
    _username = null;
    notifyListeners();
  }
}
