import 'package:flutter/material.dart';

const kAnyDate = 'Any Date';
const kAllCities = 'All Cities';
const kAllEventTypes = 'Event Type';

class HomeProvider extends ChangeNotifier {
  String _search = '';
  String _city = kAllCities;
  String _category = kAllEventTypes;
  String _dateFilter = kAnyDate;

  String get search => _search;
  String get city => _city;
  String get category => _category;
  String get dateFilter => _dateFilter;

  void setSearch(String value) {
    _search = value;
    notifyListeners();
  }

  void setCity(String value) {
    _city = value;
    notifyListeners();
  }

  void setCategory(String value) {
    _category = value;
    notifyListeners();
  }

  void setDateFilter(String value) {
    _dateFilter = value;
    notifyListeners();
  }

  bool matchesDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (_dateFilter) {
      case 'Today':
        return date.year == today.year && date.month == today.month && date.day == today.day;
      case 'This Week':
        final endOfWeek = today.add(Duration(days: 7 - today.weekday));
        return !date.isBefore(today) && !date.isAfter(endOfWeek);
      case 'This Month':
        return date.year == today.year && date.month == today.month;
      default:
        return true;
    }
  }
}
