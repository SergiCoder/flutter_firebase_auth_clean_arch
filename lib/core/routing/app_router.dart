import 'dart:developer' as dev;

import 'package:flutter_firebase_auth_clean_arch/core/routing/app_route.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/auth_router_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/login_screen.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/register_screen.dart';
import 'package:flutter_firebase_auth_clean_arch/features/error/presentation/error_screen.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/presentation/home_screen.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/splash_screen.dart';
import 'package:go_router/go_router.dart';

/// Provides the application's routing configuration.
///
/// This class is responsible for:
/// - Defining all available routes in the application
/// - Configuring route redirection based on authentication state
/// - Setting up error handling for navigation
/// - Initializing the router with the appropriate starting route
class AppRouter {
  /// Creates a router configuration for the app.
  ///
  /// Configures the application's routing system with:
  /// - Route definitions for all screens
  /// - Authentication-based redirection logic
  /// - Error handling for invalid routes
  /// - Debugging capabilities
  ///
  /// [authNotifier]: The notifier that tracks authentication state and
  /// triggers router refreshes when auth state changes.
  ///
  /// Returns a configured [GoRouter] instance ready for use in the application.
  static GoRouter createRouter({
    required AuthRouterNotifier authNotifier,
  }) {
    return GoRouter(
      initialLocation: AppRoute.splash.path,
      debugLogDiagnostics: true,
      refreshListenable: authNotifier,
      routes: [
        GoRoute(
          path: AppRoute.splash.path,
          name: AppRoute.splash.name,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoute.login.path,
          name: AppRoute.login.name,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoute.register.path,
          name: AppRoute.register.name,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: AppRoute.home.path,
          name: AppRoute.home.name,
          builder: (context, state) => const HomeScreen(),
        ),
      ],
      errorBuilder: (context, state) => ErrorScreen(
        uri: state.uri.toString(),
      ),
      redirect: (context, state) {
        // Implements route protection based on authentication state:
        // 1. Authenticated users trying to access login/register are redirected
        // to home
        // 2. Unauthenticated users can only access public routes (splash,
        //login, register)

        if (authNotifier.isAuthenticated) {
          // Redirect authenticated users away from auth screens
          if (state.matchedLocation == AppRoute.login.path ||
              state.matchedLocation == AppRoute.register.path) {
            dev.log('Redirecting to home: User is already authenticated');
            return AppRoute.home.path;
          }
        } else {
          // Redirect unauthenticated users to login if trying to access
          //protected routes
          if (state.matchedLocation != AppRoute.login.path &&
              state.matchedLocation != AppRoute.register.path &&
              state.matchedLocation != AppRoute.splash.path) {
            dev.log('Redirecting to login: User is not authenticated and '
                'attempted to access ${state.matchedLocation}');
            return AppRoute.login.path;
          }
        }

        // No redirection needed
        return null;
      },
    );
  }
}
