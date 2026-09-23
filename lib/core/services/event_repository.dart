import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class EventRepository {
  EventRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('events');

  Stream<List<EventModel>> watchAll() {
    return _collection.orderBy('date').snapshots().map(
          (snap) => snap.docs.map(EventModel.fromDoc).toList(),
        );
  }

  Stream<List<EventModel>> watchOwnedBy(String ownerId) {
    return _collection.where('ownerId', isEqualTo: ownerId).snapshots().map(
          (snap) => snap.docs.map(EventModel.fromDoc).toList()
            ..sort((a, b) => a.date.compareTo(b.date)),
        );
  }

  Stream<EventModel?> watchById(String id) {
    return _collection.doc(id).snapshots().map(
          (doc) => doc.exists ? EventModel.fromDoc(doc) : null,
        );
  }

  Future<String> create(EventModel event) async {
    final doc = await _collection.add(event.toMap());
    return doc.id;
  }

  Future<void> update(String id, Map<String, dynamic> data) {
    return _collection.doc(id).update(data);
  }

  // --- Attendees (bookings) ---

  Stream<int> watchAttendeeCount(String eventId) {
    return _collection.doc(eventId).collection('attendees').snapshots().map(
          (snap) => snap.docs.length,
        );
  }

  Stream<bool> watchIsAttending(String eventId, String uid) {
    return _collection
        .doc(eventId)
        .collection('attendees')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists);
  }

  Future<void> bookTicket(String eventId, String uid, String name) {
    return _collection.doc(eventId).collection('attendees').doc(uid).set({
      'uid': uid,
      'name': name,
      'bookedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Total attendees across every event owned by [ownerId] — used for the
  /// host dashboard's "total registrations" stat.
  Future<int> totalAttendeesForOwner(String ownerId) async {
    final events = await _collection.where('ownerId', isEqualTo: ownerId).get();
    var total = 0;
    for (final doc in events.docs) {
      final attendees = await doc.reference.collection('attendees').count().get();
      total += attendees.count ?? 0;
    }
    return total;
  }

  // --- Comments ---

  Stream<List<EventComment>> watchComments(String eventId) {
    return _collection
        .doc(eventId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(EventComment.fromDoc).toList());
  }

  Future<void> addComment(String eventId, {required String uid, required String name, required String text}) {
    return _collection.doc(eventId).collection('comments').add({
      'uid': uid,
      'name': name,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
