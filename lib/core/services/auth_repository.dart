import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';
import '../models/user_role.dart';

/// Thin wrapper around [FirebaseAuth] + the `users/{uid}` Firestore profile.
///
/// Translates Firebase's exception codes into short, user-facing messages so
/// the UI layer never has to know about `FirebaseAuthException`.
class AuthRepository {
  AuthRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _firestore.collection('users').doc(uid);

  Stream<AppUser?> watchProfile(String uid) {
    return _userDoc(uid).snapshots().map(
          (doc) => doc.exists ? AppUser.fromMap(uid, doc.data()!) : null,
        );
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e.code));
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw AuthException('Something went wrong creating your account.');
      }
      await user.updateDisplayName(displayName.trim());
      final profile = AppUser(
        uid: user.uid,
        email: email.trim(),
        displayName: displayName.trim().isEmpty ? 'Seeker' : displayName.trim(),
        role: role,
      );
      await _userDoc(user.uid).set(profile.toMap());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e.code));
    }
  }

  Future<void> signOut() => _auth.signOut();

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e.code));
    }
  }

  Future<void> toggleSavedTemple(String uid, String templeId) {
    return _userDoc(uid).update({
      'savedTempleIds': FieldValue.arrayUnion([templeId]),
    });
  }

  Future<void> removeSavedTemple(String uid, String templeId) {
    return _userDoc(uid).update({
      'savedTempleIds': FieldValue.arrayRemove([templeId]),
    });
  }

  String _messageFor(String code) {
    switch (code) {
      case 'invalid-email':
        return 'That email address doesn\'t look right.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with that email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists with that email.';
      case 'weak-password':
        return 'Please choose a password with at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}
