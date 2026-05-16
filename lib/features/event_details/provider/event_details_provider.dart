import 'package:flutter/material.dart';

class EventDetailsProvider extends ChangeNotifier {
  bool _isBooking = false;
  bool get isBooking => _isBooking;

  void bookTicket() async {
    _isBooking = true;
    notifyListeners();
    // Simulate booking process
    await Future.delayed(const Duration(seconds: 2));
    _isBooking = false;
    notifyListeners();
  }
}
