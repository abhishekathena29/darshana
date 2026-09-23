import 'package:cloud_firestore/cloud_firestore.dart';

/// A temple event / gathering, stored at `events/{id}`.
class EventModel {
  final String id;
  final String ownerId;
  final String? templeId;
  final String title;
  final String badge;
  final String category;
  final String imageUrl;
  final DateTime date;
  final String dateText;
  final String startTime;
  final String venue;
  final String durationText;
  final String description;
  final double price;
  final int? capacity;

  const EventModel({
    required this.id,
    required this.ownerId,
    this.templeId,
    required this.title,
    required this.badge,
    required this.category,
    required this.imageUrl,
    required this.date,
    required this.dateText,
    required this.startTime,
    required this.venue,
    required this.durationText,
    required this.description,
    this.price = 0,
    this.capacity,
  });

  bool get isUpcoming => date.isAfter(DateTime.now());

  factory EventModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? const {};
    final ts = map['date'];
    return EventModel(
      id: doc.id,
      ownerId: map['ownerId'] as String? ?? '',
      templeId: map['templeId'] as String?,
      title: map['title'] as String? ?? 'Untitled event',
      badge: map['badge'] as String? ?? '',
      category: map['category'] as String? ?? 'All Events',
      imageUrl: map['imageUrl'] as String? ?? '',
      date: ts is Timestamp ? ts.toDate() : DateTime.now(),
      dateText: map['dateText'] as String? ?? '',
      startTime: map['startTime'] as String? ?? '',
      venue: map['venue'] as String? ?? '',
      durationText: map['durationText'] as String? ?? '',
      description: map['description'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      capacity: map['capacity'] as int?,
    );
  }

  Map<String, dynamic> toMap() => {
        'ownerId': ownerId,
        if (templeId != null) 'templeId': templeId,
        'title': title,
        'badge': badge,
        'category': category,
        'imageUrl': imageUrl,
        'date': Timestamp.fromDate(date),
        'dateText': dateText,
        'startTime': startTime,
        'venue': venue,
        'durationText': durationText,
        'description': description,
        'price': price,
        if (capacity != null) 'capacity': capacity,
        'createdAt': FieldValue.serverTimestamp(),
      };
}

class EventComment {
  final String id;
  final String uid;
  final String name;
  final String text;
  final DateTime createdAt;

  const EventComment({
    required this.id,
    required this.uid,
    required this.name,
    required this.text,
    required this.createdAt,
  });

  factory EventComment.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? const {};
    final ts = map['createdAt'];
    return EventComment(
      id: doc.id,
      uid: map['uid'] as String? ?? '',
      name: map['name'] as String? ?? 'Seeker',
      text: map['text'] as String? ?? '',
      createdAt: ts is Timestamp ? ts.toDate() : DateTime.now(),
    );
  }
}
