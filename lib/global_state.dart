import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this line

class GlobalState with ChangeNotifier {
  String? _email;
  String? _token; 
  String? _userId; 
  String? _userName; 

  // Getters for email, token, user ID, and user name
  String? get email => _email;
  String? get token => _token;
  String? get userId => _userId; 
  String? get userName => _userName; 

  GlobalState() {
    loadSession(); 
  }

  Future<void> setEmailAndToken(String email, String token, String userId, String userName) async {
    _email = email;
    _token = token; 
    _userId = userId; 
    _userName = userName; 
    notifyListeners(); 
    final prefs = await SharedPreferences.getInstance();
    
    try {
      await prefs.setString('email', email);
      await prefs.setString('token', token);
      await prefs.setString('userId', userId);
      await prefs.setString('userName', userName);
    } catch (e) {
      print('Error saving to SharedPreferences: $e');
    }
  }

  Future<void> clearSession() async {
    _email = null;
    _token = null; 
    _userId = null; 
    _userName = null; 
    notifyListeners(); 
    final prefs = await SharedPreferences.getInstance();
    
    try {
      await prefs.remove('email'); 
      await prefs.remove('token'); 
      await prefs.remove('userId'); 
      await prefs.remove('userName'); 
    } catch (e) {
      print('Error removing from SharedPreferences: $e');
    }
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    
    _email = prefs.getString('email'); 
    _token = prefs.getString('token'); 
    _userId = prefs.getString('userId'); 
    _userName = prefs.getString('userName'); 
    notifyListeners(); 
  }
}
