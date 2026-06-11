// Manages the current mock user and authentication state.
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../data/mock_data.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _user = mockCurrentUser;
  bool _isLoggedIn = false;

  AppUser? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _user = mockCurrentUser;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
