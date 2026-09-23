import 'package:cloud_firestore/cloud_firestore.dart';

class SacredPathStop {
  final String title;
  final String subtitle;
  final String time;
  final String imageUrl;

  const SacredPathStop({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.imageUrl,
  });

  factory SacredPathStop.fromMap(Map<String, dynamic> map) {
    return SacredPathStop(
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      time: map['time'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'subtitle': subtitle,
        'time': time,
        'imageUrl': imageUrl,
      };
}

/// A curated multi-stop itinerary, stored at `sacredPaths/{id}`.
class SacredPathModel {
  final String id;
  final String title;
  final String description;
  final List<SacredPathStop> stops;

  const SacredPathModel({
    required this.id,
    required this.title,
    required this.description,
    this.stops = const [],
  });

  factory SacredPathModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? const {};
    return SacredPathModel(
      id: doc.id,
      title: map['title'] as String? ?? 'The Southern Trail',
      description: map['description'] as String? ?? '',
      stops: List<Map<String, dynamic>>.from(map['stops'] as List? ?? const [])
          .map(SacredPathStop.fromMap)
          .toList(),
    );
  }
}
