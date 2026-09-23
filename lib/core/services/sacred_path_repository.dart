import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sacred_path_model.dart';

class SacredPathRepository {
  SacredPathRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('sacredPaths');

  /// Streams the first published sacred path. The UI currently shows a
  /// single curated itinerary; this can grow into a list later.
  Stream<SacredPathModel?> watchFeatured() {
    return _collection.limit(1).snapshots().map(
          (snap) => snap.docs.isEmpty ? null : SacredPathModel.fromDoc(snap.docs.first),
        );
  }
}
