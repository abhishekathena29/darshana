import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';
import 'stream_cache.dart';

/// A single booking, for the host dashboard's "Recent Activity" feed.
class EventAttendeeActivity {
  final String eventId;
  final String eventTitle;
  final String name;
  final DateTime? bookedAt;

  const EventAttendeeActivity({
    required this.eventId,
    required this.eventTitle,
    required this.name,
    this.bookedAt,
  });
}

class EventRepository {
  EventRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('events');

  // Firestore streams are cheap to re-listen to, but every UI screen that
  // lives inside a StatelessWidget rebuild path (e.g. tabs under a
  // scroll-driven nav bar) calls `watchX()` again on every rebuild. If we
  // handed back a brand new Stream instance each time, StreamBuilder would
  // see a changed `stream` identity, tear down its subscription and flash
  // back to a loading state mid-scroll — which looks exactly like "the list
  // won't scroll". Caching by query key keeps the same stream alive across
  // rebuilds so StreamBuilder just keeps listening. `shareReplay` (rather
  // than a plain `.asBroadcastStream()`) is what makes this safe to reuse
  // across independent widget lifecycles too: it never tears down the
  // underlying Firestore subscription (so a single-subscription source
  // stream is never re-listened to, which would throw) and replays the
  // latest value to a screen that's opened a second time, instead of
  // leaving it on a loading spinner forever.
  static Stream<List<EventModel>>? _allCache;
  static final Map<String, Stream<List<EventModel>>> _ownedByCache = {};
  static final Map<String, Stream<EventModel?>> _byIdCache = {};

  Stream<List<EventModel>> watchAll() {
    return _allCache ??= shareReplay(() => _collection.orderBy('date').snapshots().map(
          (snap) => snap.docs.map(EventModel.fromDoc).toList(),
        ));
  }

  Stream<List<EventModel>> watchOwnedBy(String ownerId) {
    return _ownedByCache.putIfAbsent(
      ownerId,
      () => shareReplay(() => _collection.where('ownerId', isEqualTo: ownerId).snapshots().map(
            (snap) => snap.docs.map(EventModel.fromDoc).toList()
              ..sort((a, b) => a.date.compareTo(b.date)),
          )),
    );
  }

  Stream<EventModel?> watchById(String id) {
    return _byIdCache.putIfAbsent(
      id,
      () => shareReplay(() => _collection.doc(id).snapshots().map(
            (doc) => doc.exists ? EventModel.fromDoc(doc) : null,
          )),
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

  static final Map<String, Stream<int>> _attendeeCountCache = {};
  static final Map<String, Stream<bool>> _isAttendingCache = {};

  Stream<int> watchAttendeeCount(String eventId) {
    return _attendeeCountCache.putIfAbsent(
      eventId,
      () => shareReplay(() => _collection.doc(eventId).collection('attendees').snapshots().map(
            (snap) => snap.docs.length,
          )),
    );
  }

  Stream<bool> watchIsAttending(String eventId, String uid) {
    return _isAttendingCache.putIfAbsent(
      '$eventId:$uid',
      () => shareReplay(() => _collection
          .doc(eventId)
          .collection('attendees')
          .doc(uid)
          .snapshots()
          .map((doc) => doc.exists)),
    );
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

  /// The most recent bookings across every event owned by [ownerId], newest
  /// first — used to power the host dashboard's "Recent Activity" feed with
  /// real data instead of placeholder content.
  Future<List<EventAttendeeActivity>> recentAttendeesForOwner(String ownerId, {int limit = 5}) async {
    final events = await _collection.where('ownerId', isEqualTo: ownerId).get();
    final all = <EventAttendeeActivity>[];
    for (final doc in events.docs) {
      final attendees = await doc.reference
          .collection('attendees')
          .orderBy('bookedAt', descending: true)
          .limit(limit)
          .get();
      for (final a in attendees.docs) {
        final data = a.data();
        final bookedAt = data['bookedAt'];
        all.add(EventAttendeeActivity(
          eventId: doc.id,
          eventTitle: doc.data()['title'] as String? ?? 'an event',
          name: data['name'] as String? ?? 'A devotee',
          bookedAt: bookedAt is Timestamp ? bookedAt.toDate() : null,
        ));
      }
    }
    all.sort((a, b) {
      final ad = a.bookedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bd = b.bookedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bd.compareTo(ad);
    });
    return all.take(limit).toList();
  }

  // --- Comments ---

  static final Map<String, Stream<List<EventComment>>> _commentsCache = {};

  Stream<List<EventComment>> watchComments(String eventId) {
    return _commentsCache.putIfAbsent(
      eventId,
      () => shareReplay(() => _collection
          .doc(eventId)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snap) => snap.docs.map(EventComment.fromDoc).toList())),
    );
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
