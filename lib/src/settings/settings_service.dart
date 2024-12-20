import 'package:emed/src/services/auth/auth.service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  final AuthService _authService;

  SettingsService(this._authService);

  Future<ThemeMode> themeMode() async {
    final sharedPreferences = SharedPreferencesAsync();

    final themeMode = await sharedPreferences.getString('themeMode');

    if (themeMode == 'light') {
      return ThemeMode.light;
    } else if (themeMode == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  /// Persists the Pharmacist's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    final sharedPreferences = SharedPreferencesAsync();

    if (theme == ThemeMode.light) {
      await sharedPreferences.setString('themeMode', 'light');
    } else if (theme == ThemeMode.dark) {
      await sharedPreferences.setString('themeMode', 'dark');
    } else {
      await sharedPreferences.setString('themeMode', 'system');
    }
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}
