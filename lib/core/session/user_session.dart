import 'package:flutter/material.dart';
import '../models/user_role.dart';

/// Holds the signed-in user's identity for the lifetime of the app session.
///
/// Kept intentionally lightweight (no persistence yet) — it exists so the
/// shell and screens can adapt their UI to the chosen [UserRole].
class UserSession extends ChangeNotifier {
  UserRole _role = UserRole.devotee;
  String _displayName = 'Seeker';

  UserRole get role => _role;
  String get displayName => _displayName;

  bool get isTemple => _role == UserRole.temple;

  void signIn({required UserRole role, String? displayName}) {
    _role = role;
    if (displayName != null && displayName.trim().isNotEmpty) {
      _displayName = displayName.trim();
    }
    notifyListeners();
  }

  void setRole(UserRole role) {
    if (_role == role) return;
    _role = role;
    notifyListeners();
  }
}
