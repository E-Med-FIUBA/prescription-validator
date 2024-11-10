import 'package:emed/src/services/api/api.dart';
import 'package:emed/src/services/auth/auth.service.dart';
import 'package:emed/src/settings/settings_controller.dart';
import 'package:emed/src/settings/settings_service.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final AuthService authService = AuthService();
  final settingsController = SettingsController(SettingsService(authService));
  final apiService = ApiService(authService: authService);

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  settingsController.updateThemeMode(ThemeMode.dark);

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(
    settingsController: settingsController,
    authService: authService,
    apiService: apiService,
  ));
}
