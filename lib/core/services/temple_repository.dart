import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/temple_model.dart';

class TempleRepository {
  TempleRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('temples');

  Stream<List<TempleModel>> watchAll() {
    return _collection.orderBy('createdAt', descending: true).snapshots().map(
          (snap) => snap.docs.map(TempleModel.fromDoc).toList(),
        );
  }

  Stream<List<TempleModel>> watchOwnedBy(String ownerId) {
    return _collection.where('ownerId', isEqualTo: ownerId).snapshots().map(
          (snap) => snap.docs.map(TempleModel.fromDoc).toList(),
        );
  }

  Stream<TempleModel?> watchById(String id) {
    return _collection.doc(id).snapshots().map(
          (doc) => doc.exists ? TempleModel.fromDoc(doc) : null,
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
}
