import 'package:emed/src/settings/settings_service.dart';
import 'package:flutter/material.dart';

class SettingsController with ChangeNotifier {
  final SettingsService _settingsService;

  SettingsController(this._settingsService);
  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;
    if (newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;
    notifyListeners();
    await _settingsService.updateThemeMode(newThemeMode);
  }

  Future<void> logout() async {
    await _settingsService.logout();
    notifyListeners();
  }
}
