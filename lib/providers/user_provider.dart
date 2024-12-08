/*Flutter Documentation (Google), (2024) provider. 
Available at: https://pub.dev/packages/provider
(Accessed: 28 November 2024).
*/

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
