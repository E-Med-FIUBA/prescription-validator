import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

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
    _isLoggedIn = await prefs.getBool('isLoggedIn') ?? false;
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
  Future<bool> login(String username, String password) async {
    // Here you would typically make an API call to validate credentials
    // For this example, we'll just check if the username and password are not empty
    if (username.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      final prefs = SharedPreferencesAsync();

      await prefs.setBool('isLoggedIn', true);
      _authStateController.add(true);
      return true;
    }
    return false;
  }

  // Logout method
  Future<void> logout() async {
    _isLoggedIn = false;
    final prefs = SharedPreferencesAsync();

    await prefs.setBool('isLoggedIn', false);
    _authStateController.add(false);
  }

  // Dispose method to close the stream controller
  void dispose() {
    _authStateController.close();
  }
}
