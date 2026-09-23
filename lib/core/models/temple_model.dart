import 'package:cloud_firestore/cloud_firestore.dart';

class TempleFacility {
  final String icon;
  final String title;
  final String subtitle;

  const TempleFacility({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  factory TempleFacility.fromMap(Map<String, dynamic> map) {
    return TempleFacility(
      icon: map['icon'] as String? ?? 'info',
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'icon': icon,
        'title': title,
        'subtitle': subtitle,
      };
}

/// A temple / sacred site, stored at `temples/{id}`.
class TempleModel {
  final String id;
  final String ownerId;
  final String name;
  final String deity;
  final String imageUrl;
  final String location;
  final String timings;
  final String dressCode;
  final String significance;
  final String history;
  final String architecture;
  final List<String> proTips;
  final List<TempleFacility> facilities;
  final String officialPortal;

  const TempleModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.deity,
    required this.imageUrl,
    required this.location,
    required this.timings,
    required this.dressCode,
    required this.significance,
    required this.history,
    required this.architecture,
    this.proTips = const [],
    this.facilities = const [],
    this.officialPortal = '',
  });

  factory TempleModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? const {};
    return TempleModel(
      id: doc.id,
      ownerId: map['ownerId'] as String? ?? '',
      name: map['name'] as String? ?? 'Unnamed Temple',
      deity: map['deity'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      location: map['location'] as String? ?? '',
      timings: map['timings'] as String? ?? '',
      dressCode: map['dressCode'] as String? ?? '',
      significance: map['significance'] as String? ?? '',
      history: map['history'] as String? ?? '',
      architecture: map['architecture'] as String? ?? '',
      proTips: List<String>.from(map['proTips'] as List? ?? const []),
      facilities: List<Map<String, dynamic>>.from(map['facilities'] as List? ?? const [])
          .map(TempleFacility.fromMap)
          .toList(),
      officialPortal: map['officialPortal'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'ownerId': ownerId,
        'name': name,
        'deity': deity,
        'imageUrl': imageUrl,
        'location': location,
        'timings': timings,
        'dressCode': dressCode,
        'significance': significance,
        'history': history,
        'architecture': architecture,
        'proTips': proTips,
        'facilities': facilities.map((f) => f.toMap()).toList(),
        'officialPortal': officialPortal,
        'createdAt': FieldValue.serverTimestamp(),
      };
}
