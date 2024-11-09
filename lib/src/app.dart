import 'package:emed/src/screens/base/base_screen.dart';
import 'package:emed/src/screens/base/indexes.dart';
import 'package:emed/src/screens/pharmacist_profile/pharmacist_profile.service.dart';
import 'package:emed/src/screens/pharmacist_profile/pharmacist_profile_controller.dart';
import 'package:emed/src/screens/pharmacist_profile/pharmacist_profile_view.dart';
import 'package:emed/src/screens/base/prescription_history_screen.dart';
import 'package:emed/src/screens/base/prescription_metrics.dart';
import 'package:emed/src/screens/base/prescription_screen.dart';
import 'package:emed/src/services/auth/auth_wrapper.dart';
import 'package:emed/src/settings/settings_controller.dart';
import 'package:emed/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/base/qr_scanner_screen.dart';
import 'services/auth/auth.service.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  final SettingsController settingsController;
  final AuthService authService;
  late final PharmacistProfileController profileController;

  MyApp({
    super.key,
    required this.settingsController,
    required this.authService,
  }) {
    profileController =
        PharmacistProfileController(PharmacistProfileService(authService));
  }

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(
              scaffoldBackgroundColor:
                  const Color.fromARGB(255, 231, 230, 230)),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (context) => AuthWrapper(
                    authService: authService,
                    child: _getPageForRouteName(
                        routeSettings, settingsController, profileController)));
          },
        );
      },
    );
  }

  Widget _getPageForRouteName(
      RouteSettings routeSettings,
      SettingsController settingsController,
      PharmacistProfileController profileController) {
    switch (routeSettings.name) {
      case PrescriptionHistoryScreen.routeName:
      case PrescriptionMetricsScreen.routeName:
      case QRScannerScreen.routeName:
      case PharmacistProfileView.routeName:
      case SettingsView.routeName:
        return BaseScreen(
            settingsController: settingsController,
            profileController: profileController,
            selectedIndex: _getSelectedIndex(routeSettings.name));
      case PrescriptionScreen.routeName:
        final String prescriptionId = routeSettings.arguments as String;
        return PrescriptionScreen(prescriptionId: prescriptionId);
      default:
        return BaseScreen(
            settingsController: settingsController,
            profileController: profileController,
            selectedIndex: indexPharmacistProfile);
    }
  }

  _getSelectedIndex(String? name) {
    switch (name) {
      case PrescriptionHistoryScreen.routeName:
        return indexPrescriptionHistory;
      case PrescriptionMetricsScreen.routeName:
        return indexPrescriptionMetrics;
      case QRScannerScreen.routeName:
        return indexQRScanner;
      case PharmacistProfileView.routeName:
        return indexPharmacistProfile;
      case SettingsView.routeName:
        return indexSettings;
      default:
        return indexPrescriptionHistory;
    }
  }
}
