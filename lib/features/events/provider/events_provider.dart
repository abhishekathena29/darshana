import 'package:flutter/material.dart';

class EventsProvider extends ChangeNotifier {
  String _selectedCategory = 'All Events';
  String get selectedCategory => _selectedCategory;

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
