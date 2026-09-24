import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sacred_path_model.dart';
import 'stream_cache.dart';

class SacredPathRepository {
  SacredPathRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('sacredPaths');

  static Stream<SacredPathModel?>? _featuredCache;

  /// Streams the first published sacred path. The UI currently shows a
  /// single curated itinerary; this can grow into a list later.
  ///
  /// Cached as a broadcast stream so repeated calls from a widget that
  /// rebuilds often (e.g. a tab under a scroll-driven nav bar) share the
  /// same subscription instead of resetting StreamBuilder to a loading
  /// state on every rebuild.
  Stream<SacredPathModel?> watchFeatured() {
    return _featuredCache ??= shareReplay(() => _collection.limit(1).snapshots().map(
          (snap) => snap.docs.isEmpty ? null : SacredPathModel.fromDoc(snap.docs.first),
        ));
  }
}
