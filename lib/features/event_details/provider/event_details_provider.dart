import 'package:flutter/material.dart';
import '../../../core/services/event_repository.dart';

class EventDetailsProvider extends ChangeNotifier {
  EventDetailsProvider(this.eventId);

  final String eventId;
  final _repository = EventRepository();

  bool _isBooking = false;
  bool get isBooking => _isBooking;

  Future<void> bookTicket({required String uid, required String name}) async {
    _isBooking = true;
    notifyListeners();
    try {
      await _repository.bookTicket(eventId, uid, name);
    } finally {
      _isBooking = false;
      notifyListeners();
    }
  }

  Future<void> addComment({required String uid, required String name, required String text}) {
    if (text.trim().isEmpty) return Future.value();
    return _repository.addComment(eventId, uid: uid, name: name, text: text.trim());
  }
}
