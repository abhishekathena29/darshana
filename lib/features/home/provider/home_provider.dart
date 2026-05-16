import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  int _currentBottomNavIndex = 0;
  int get currentBottomNavIndex => _currentBottomNavIndex;

  void updateBottomNavIndex(int index) {
    _currentBottomNavIndex = index;
    notifyListeners();
  }
}
