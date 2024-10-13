import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalState with ChangeNotifier {
  String? _email;

  String? get email => _email;

  // Method to set email and save it to SharedPreferences
  Future<void> setEmail(String email) async {
    _email = email;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email); // Store email
  }

  // Method to clear email and remove it from SharedPreferences
  Future<void> clearEmail() async {
    _email = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email'); // Clear email
  }

  // Method to load email from SharedPreferences
  Future<void> loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    _email = prefs.getString('email'); // Load email
    notifyListeners();
  }
}
