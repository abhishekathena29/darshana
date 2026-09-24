import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';
import '../models/user_role.dart';
import '../services/auth_repository.dart';

enum AuthStatus { loading, signedOut, signedIn }

/// Holds the signed-in user's identity for the lifetime of the app session.
///
/// Backed by Firebase Auth + the `users/{uid}` Firestore profile. Screens
/// watch this via [Provider] to react to sign-in/out and role changes.
class UserSession extends ChangeNotifier {
  UserSession({AuthRepository? repository})
      : _repository = repository ?? AuthRepository() {
    _authSub = _repository.authStateChanges.listen(_onAuthChanged);
  }

  final AuthRepository _repository;
  StreamSubscription<User?>? _authSub;
  StreamSubscription<AppUser?>? _profileSub;

  AuthStatus _status = AuthStatus.loading;
  AppUser? _profile;
  bool _isBusy = false;
  String? _errorMessage;

  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.signedIn;
  bool get isBusy => _isBusy;
  String? get errorMessage => _errorMessage;

  String? get uid => _repository.currentUser?.uid;
  String? get email => _profile?.email ?? _repository.currentUser?.email;
  UserRole get role => _profile?.role ?? UserRole.devotee;
  bool get isTemple => role == UserRole.temple;
  String get displayName =>
      _profile?.displayName ?? _repository.currentUser?.displayName ?? 'Seeker';
  List<String> get savedTempleIds => _profile?.savedTempleIds ?? const [];

  void _onAuthChanged(User? user) {
    _profileSub?.cancel();
    if (user == null) {
      _profile = null;
      _status = AuthStatus.signedOut;
      notifyListeners();
      return;
    }
    _profileSub = _repository.watchProfile(user.uid).listen((profile) {
      _profile = profile;
      _status = AuthStatus.signedIn;
      notifyListeners();
    });
  }

  Future<bool> _run(Future<void> Function() action) async {
    _isBusy = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await action();
      _isBusy = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _isBusy = false;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _isBusy = false;
      _errorMessage = 'Something went wrong. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) {
    return _run(() => _repository.signIn(email: email, password: password));
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) {
    return _run(() => _repository.signUp(
          email: email,
          password: password,
          displayName: displayName,
          role: role,
        ));
  }

  Future<void> signOut() => _repository.signOut();

  Future<bool> sendPasswordReset(String email) {
    return _run(() => _repository.sendPasswordResetEmail(email));
  }

  Future<void> toggleSavedTemple(String templeId) async {
    final id = uid;
    if (id == null) return;
    if (savedTempleIds.contains(templeId)) {
      await _repository.removeSavedTemple(id, templeId);
    } else {
      await _repository.toggleSavedTemple(id, templeId);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _profileSub?.cancel();
    super.dispose();
  }
}
