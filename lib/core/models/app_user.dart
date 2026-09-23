import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_role.dart';

/// The Firestore-backed profile stored at `users/{uid}`.
class AppUser {
  final String uid;
  final String email;
  final String displayName;
  final UserRole role;
  final List<String> savedTempleIds;

  const AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    this.savedTempleIds = const [],
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String? ?? 'Seeker',
      role: (map['role'] as String?) == 'temple'
          ? UserRole.temple
          : UserRole.devotee,
      savedTempleIds: List<String>.from(map['savedTempleIds'] as List? ?? const []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role.name,
      'savedTempleIds': savedTempleIds,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
