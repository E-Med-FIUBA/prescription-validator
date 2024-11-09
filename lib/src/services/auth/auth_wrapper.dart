import 'dart:developer';

import 'package:flutter/material.dart';

import '../../screens/auth/login_screen.dart';
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          final bool isLoggedIn = snapshot.data ?? false;

          log('User is logged in: $isLoggedIn');
          return isLoggedIn ? child : LoginScreen(authService: authService);
        }

        // Show a loading indicator while waiting for the auth state
      },
    );
  }
}
