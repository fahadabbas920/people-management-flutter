import 'package:flutter/material.dart';

class GlobalState with ChangeNotifier {
  String _email = '';

  String get email => _email;

  void setEmail(String newEmail) {
    _email = newEmail;
    notifyListeners(); // Notify listeners about the change
  }

  void clearEmail() {
    _email = '';
    notifyListeners(); // Notify listeners about the change
  }
}
