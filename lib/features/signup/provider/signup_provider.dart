import 'package:flutter/material.dart';
import '../../../core/models/user_role.dart';

class SignupProvider extends ChangeNotifier {
  UserRole _role = UserRole.devotee;
  bool _passwordVisible = false;

  UserRole get role => _role;
  bool get passwordVisible => _passwordVisible;

  void selectRole(UserRole role) {
    if (_role == role) return;
    _role = role;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }
}
