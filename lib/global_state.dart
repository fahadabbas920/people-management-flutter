import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GlobalState with ChangeNotifier {
  final _secureStorage = const FlutterSecureStorage();

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
    // Load securely stored data when the GlobalState is initialized
    _loadFromSecureStorage();
  }

  // Setters for updating email, token, userId, and userName with secure persistence
  void setEmailAndToken(
      String email, String token, String userId, String userName) async {
    _email = email;
    _token = token;
    _userId = userId;
    _userName = userName;
    notifyListeners();
    _saveToSecureStorage();
  }

  // Clear session (with secure persistence)
  void clearSession() async {
    _email = null;
    _token = null;
    _userId = null;
    _userName = null;
    notifyListeners();
    _clearSecureStorage();
  }

  // Save to secure storage
  void _saveToSecureStorage() async {
    await _secureStorage.write(key: 'email', value: _email);
    await _secureStorage.write(key: 'token', value: _token);
    await _secureStorage.write(key: 'userId', value: _userId);
    await _secureStorage.write(key: 'userName', value: _userName);
  }

  // Load from secure storage
  void _loadFromSecureStorage() async {
    _email = await _secureStorage.read(key: 'email');
    _token = await _secureStorage.read(key: 'token');
    _userId = await _secureStorage.read(key: 'userId');
    _userName = await _secureStorage.read(key: 'userName');
    notifyListeners();
  }

  // Clear secure storage
  void _clearSecureStorage() async {
    await _secureStorage.delete(key: 'email');
    await _secureStorage.delete(key: 'token');
    await _secureStorage.delete(key: 'userId');
    await _secureStorage.delete(key: 'userName');
  }
}
