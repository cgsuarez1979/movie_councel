import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  final String currentUserkey = "co.fullstacklabs.blog.awspersonalize.user";

  String? _currentUser;

  bool get isAuth {
    return _currentUser != null;
  }

  String? get userName {
    return _currentUser;
  }

  Future<String?> getCurentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(currentUserkey);
  }

  Future<void> setCurrentUser(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentUser = userName;
    await prefs.setString(currentUserkey, userName);
    notifyListeners();
  }

  Future<void> authenticate(String login) async {
    _currentUser = login;
    await setCurrentUser(login);
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(currentUserkey)) {
      return false;
    }

    _currentUser = await getCurentUser();

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(currentUserkey);
    _currentUser = null;
    notifyListeners();
  }
}
