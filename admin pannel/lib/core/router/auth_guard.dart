import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthGuard {
  /// A redirect function to check if the user is authenticated.
  static FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    // TODO: Replace with actual auth service check (e.g., via GetX or SecureStorage)
    bool isAuthenticated = true; // Placeholder for true auth status
    
    final bool isLoggingIn = state.matchedLocation == '/login';

    // ignore: dead_code
    if (!isAuthenticated && !isLoggingIn) {
      // Redirect to login if not authenticated and not currently on the login page
      return '/login';
    }

    if (isAuthenticated && isLoggingIn) {
      // Redirect to dashboard if already authenticated but trying to go to login
      return '/';
    }

    // No redirect needed
    return null;
  }
}
