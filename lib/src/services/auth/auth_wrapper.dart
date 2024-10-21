import 'dart:developer';

import 'package:flutter/material.dart';

import '../../screens/login_screen.dart';
import 'auth.service.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;
  final AuthService authService;

  const AuthWrapper({
    Key? key,
    required this.child,
    required this.authService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: authService.authStateChanges(),
      builder: (context, snapshot) {
        log("${snapshot.data}");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          final bool isLoggedIn = snapshot.data ?? false;
          return isLoggedIn ? child : const LoginScreen();
        }

        // Show a loading indicator while waiting for the auth state
      },
    );
  }
}
