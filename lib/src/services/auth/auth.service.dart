import 'dart:async';
import 'package:emed/src/environment/environment.dart';
import 'package:emed/src/screens/auth/login_screen.dart';
import 'package:emed/src/screens/auth/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
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

  Future<bool> login(LoginFormData data) async {
    try {
      final response = await http.post(
        Uri.parse('${Environment.apiUrl}/auth/login'),
        body: data.toJson(),
      );

      final apiResponse = ApiResponse(
        statusCode: response.statusCode,
        responseBody: response.body,
      );

      if (apiResponse.statusCode != 200) {
        throw Exception('Invalid credentials');
      }

      setCredentials(apiResponse.body['token']);

      return true;
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> register(RegisterFormData data) async {
    try {
      final response = await http.post(
        Uri.parse('${Environment.apiUrl}/auth/register/doctor'),
        body: data.toJson(),
      );

      final apiResponse = ApiResponse(
        statusCode: response.statusCode,
        responseBody: response.body,
      );

      if (apiResponse.statusCode != 201) {
        throw Exception(apiResponse.body);
      }

      setCredentials(apiResponse.body['token']);

      return true;
    } catch (err) {
      rethrow;
    }
  }

  Future<void> setCredentials(String token) async {
    _isLoggedIn = true;
    final prefs = SharedPreferencesAsync();

    await prefs.setString('token', token);

    _authStateController.add(true);
  }

  // Logout method
  Future<void> logout() async {
    _isLoggedIn = false;
    final prefs = SharedPreferencesAsync();

    await prefs.remove('token');
    _authStateController.add(false);
  }

  Future<String?> getToken() async {
    final prefs = SharedPreferencesAsync();

    return prefs.getString('token');
  }

  // Dispose method to close the stream controller
  void dispose() {
    _authStateController.close();
  }
}
