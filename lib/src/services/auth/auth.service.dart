import 'dart:async';
import 'package:emed/src/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api.dart';

class AuthService {
  final StreamController<bool> _authStateController =
      StreamController<bool>.broadcast();
  bool _isLoggedIn = false;

  AuthService() {
    _checkInitialAuthState();
  }

  // Check the initial auth state when the service is created
  Future<void> _checkInitialAuthState() async {
    final prefs = SharedPreferencesAsync();
    final token = await prefs.getString('token');
    _isLoggedIn = token != null;
    _authStateController.add(_isLoggedIn);
  }

  // Stream of auth state changes
  Stream<bool> authStateChanges() async* {
    // Emit the current state immediately
    yield _isLoggedIn;
    // Then yield any future changes
    yield* _authStateController.stream;
  }

  // Current auth state
  bool get isLoggedIn => _isLoggedIn;

  // Login method
  Future<bool> login(LoginFormData data) async {
    // Here you would typically make an API call to validate credentials
    // For this example, we'll just check if the username and password are not empty
    try {
      final response = await ApiService.post('auth/login', data.toJson());

      if (response.statusCode != 200) {
        throw Exception('Invalid credentials');
      }

      _isLoggedIn = true;
      final prefs = SharedPreferencesAsync();

      await prefs.setString('token', response.body['token']);

      _authStateController.add(true);

      return true;
    } catch (err) {
      rethrow;
    }
  }

  // Logout method
  Future<void> logout() async {
    _isLoggedIn = false;
    final prefs = SharedPreferencesAsync();

    await prefs.remove('token');
    _authStateController.add(false);
  }

  // Dispose method to close the stream controller
  void dispose() {
    _authStateController.close();
  }
}
