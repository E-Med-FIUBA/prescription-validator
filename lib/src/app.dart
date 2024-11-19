import 'package:emed/src/screens/auth/login_screen.dart';
import 'package:emed/src/screens/auth/register_screen.dart';
import 'package:emed/src/screens/base/base_screen.dart';
import 'package:emed/src/screens/base/prescription_screen.dart';
import 'package:emed/src/screens/pharmacist_profile/pharmacist_profile.service.dart';
import 'package:emed/src/screens/pharmacist_profile/pharmacist_profile_controller.dart';
import 'package:emed/src/screens/pharmacist_profile/pharmacist_profile_view.dart';
import 'package:emed/src/screens/base/prescription_history_screen.dart';
import 'package:emed/src/screens/base/prescription_metrics.dart';
import 'package:emed/src/services/api/api.dart';
import 'package:emed/src/services/auth/auth_wrapper.dart';
import 'package:emed/src/services/prescription/prescription.service.dart';
import 'package:emed/src/settings/settings_controller.dart';
import 'package:emed/src/settings/settings_view.dart';
import 'package:emed/src/widgets/lazy_load_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'screens/base/qr_scanner_screen.dart';
import 'services/auth/auth.service.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  final SettingsController settingsController;
  final AuthService authService;
  late final PharmacistProfileController profileController;
  final ApiService apiService;
  late final PrescriptionService prescriptionService;

  MyApp({
    super.key,
    required this.settingsController,
    required this.authService,
    required this.apiService,
  }) {
    profileController =
        PharmacistProfileController(PharmacistProfileService(authService));

    prescriptionService = PrescriptionService(apiService);
  }

  @override
  Widget build(BuildContext context) {
    final rootNavigatorKey = GlobalKey<NavigatorState>();
    final shellNavigatorKey = GlobalKey<NavigatorState>();

    final GoRouter router = GoRouter(
      initialLocation: '/',
      navigatorKey: rootNavigatorKey,
      routes: [
        GoRoute(
            parentNavigatorKey: rootNavigatorKey,
            path: '/auth/register',
            builder: (context, state) => RegisterScreen(
                  authService: authService,
                )),
        GoRoute(
            parentNavigatorKey: rootNavigatorKey,
            path: '/auth/login',
            builder: (context, state) => LoginScreen(
                  authService: authService,
                )),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: '${PrescriptionScreen.routeName}/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return PrescriptionScreen(
              prescriptionService: prescriptionService,
              prescriptionId: id,
            );
          },
        ),
        ShellRoute(
            navigatorKey: shellNavigatorKey,
            builder: (context, state, child) => AuthWrapper(
                  authService: authService,
                  child:
                      BaseScreen(location: state.uri.toString(), child: child),
                ),
            routes: [
              GoRoute(
                parentNavigatorKey: shellNavigatorKey,
                path: PrescriptionHistoryScreen.routeName,
                builder: (context, state) => LazyLoadScreen(
                  routeName: PrescriptionHistoryScreen.routeName,
                  builder: () => PrescriptionHistoryScreen(
                      prescriptionService: prescriptionService),
                ),
              ),
              GoRoute(
                parentNavigatorKey: shellNavigatorKey,
                path: PrescriptionMetricsScreen.routeName,
                builder: (context, state) => LazyLoadScreen(
                  routeName: PrescriptionMetricsScreen.routeName,
                  builder: () => PrescriptionMetricsScreen(
                    prescriptionService: prescriptionService,
                  ),
                ),
              ),
              GoRoute(
                parentNavigatorKey: shellNavigatorKey,
                path: QRScannerScreen.routeName,
                builder: (context, state) => LazyLoadScreen(
                  routeName: QRScannerScreen.routeName,
                  builder: () => QRScannerScreen(),
                ),
              ),
              GoRoute(
                parentNavigatorKey: shellNavigatorKey,
                path: PharmacistProfileView.routeName,
                builder: (context, state) => LazyLoadScreen(
                  routeName: PharmacistProfileView.routeName,
                  builder: () => PharmacistProfileView(
                    controller: profileController,
                  ),
                ),
              ),
              GoRoute(
                parentNavigatorKey: shellNavigatorKey,
                path: SettingsView.routeName,
                builder: (context, state) => LazyLoadScreen(
                  routeName: SettingsView.routeName,
                  builder: () => SettingsView(
                    controller: settingsController,
                  ),
                ),
              ),
            ]),
      ],
    );

    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          routerConfig: router,
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(
              scaffoldBackgroundColor:
                  const Color.fromARGB(255, 231, 230, 230)),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
        );
      },
    );
  }
}
