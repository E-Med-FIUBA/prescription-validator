import 'package:emed/src/services/auth/auth.service.dart';
import 'package:emed/src/services/pharmacist/pharmacist.service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PharmacistProfileService {
  final AuthService _authService;

  PharmacistProfileService(this._authService);

  /// Loads the Pharmacist's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final themeMode = sharedPreferences.getString('themeMode');

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
    final sharedPreferences = await SharedPreferences.getInstance();

    if (theme == ThemeMode.light) {
      await sharedPreferences.setString('themeMode', 'light');
    } else if (theme == ThemeMode.dark) {
      await sharedPreferences.setString('themeMode', 'dark');
    } else {
      await sharedPreferences.setString('themeMode', 'system');
    }
  }

  Future<Pharmacist> getPharmacist() async {
    return PharmacistService.fetchPharmacist();
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}
