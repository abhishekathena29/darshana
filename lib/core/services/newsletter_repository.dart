import 'package:cloud_firestore/cloud_firestore.dart';

/// Newsletter sign-ups from the home screen's "Join Darshana" card, stored
/// at `newsletterSubscribers/{uid}` — one doc per signed-in user, so
/// subscribing again just updates the email instead of creating spam.
class NewsletterRepository {
  NewsletterRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> subscribe(String uid, String email) {
    return _firestore.collection('newsletterSubscribers').doc(uid).set({
      'email': email,
      'subscribedAt': FieldValue.serverTimestamp(),
    });
  }
}
