import 'package:flutter/material.dart';

class SacredPathProvider extends ChangeNotifier {
  // Add state for the sacred path (e.g., active step, expanded details)
  int _activeStep = 1;

  int get activeStep => _activeStep;

  void setActiveStep(int step) {
    _activeStep = step;
    notifyListeners();
  }
}
