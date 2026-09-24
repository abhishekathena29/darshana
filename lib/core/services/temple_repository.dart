import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/temple_model.dart';
import 'stream_cache.dart';

class TempleRepository {
  TempleRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('temples');

  // Cached by query key so repeated calls (e.g. from a widget that rebuilds
  // often, or a detail screen that's pushed more than once) return the same
  // stream instead of tearing down and resubscribing StreamBuilder on every
  // rebuild. `shareReplay` (see stream_cache.dart) also makes it safe to
  // reuse across independent widget lifecycles: it never cancels the
  // underlying Firestore subscription and replays the latest value to a
  // screen reopened a second time.
  static Stream<List<TempleModel>>? _allCache;
  static final Map<String, Stream<List<TempleModel>>> _ownedByCache = {};
  static final Map<String, Stream<TempleModel?>> _byIdCache = {};

  Stream<List<TempleModel>> watchAll() {
    return _allCache ??= shareReplay(() => _collection.orderBy('createdAt', descending: true).snapshots().map(
          (snap) => snap.docs.map(TempleModel.fromDoc).toList(),
        ));
  }

  Stream<List<TempleModel>> watchOwnedBy(String ownerId) {
    return _ownedByCache.putIfAbsent(
      ownerId,
      () => shareReplay(() => _collection.where('ownerId', isEqualTo: ownerId).snapshots().map(
            (snap) => snap.docs.map(TempleModel.fromDoc).toList(),
          )),
    );
  }

  Stream<TempleModel?> watchById(String id) {
    return _byIdCache.putIfAbsent(
      id,
      () => shareReplay(() => _collection.doc(id).snapshots().map(
            (doc) => doc.exists ? TempleModel.fromDoc(doc) : null,
          )),
    );
  }

  Future<List<TempleModel>> fetchByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final chunks = <List<String>>[];
    for (var i = 0; i < ids.length; i += 10) {
      chunks.add(ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10));
    }
    final results = <TempleModel>[];
    for (final chunk in chunks) {
      final snap = await _collection
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      results.addAll(snap.docs.map(TempleModel.fromDoc));
    }
    return results;
  }

  Future<String> create(TempleModel temple) async {
    final doc = await _collection.add(temple.toMap());
    return doc.id;
  }

  Future<void> update(String id, Map<String, dynamic> data) {
    return _collection.doc(id).update(data);
  }

  /// Appends a quick note to the temple's "Seva & Offerings" list — used by
  /// the host dashboard's "Post Announcement" action so devotees see it on
  /// the temple's profile right away.
  Future<void> addProTip(String templeId, String tip) {
    return _collection.doc(templeId).update({
      'proTips': FieldValue.arrayUnion([tip]),
    });
  }
}
