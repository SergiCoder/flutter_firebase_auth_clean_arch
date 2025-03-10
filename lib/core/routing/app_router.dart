import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/app_route.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/auth_router_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/login_screen.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/register_screen.dart';
import 'package:flutter_firebase_auth_clean_arch/features/error/presentation/error_screen.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/presentation/home_screen.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/splash_screen.dart';
import 'package:go_router/go_router.dart';

/// Provides the application's routing configuration
class AppRouter {
  /// Creates a router configuration for the app
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
        // Always show splash screen until auth state is initialized
        if (!authNotifier.isInitialized) {
          return AppRoute.splash.path;
        }

        // If we're at the splash screen and auth is initialized, redirect based
        // on auth state
        if (state.matchedLocation == AppRoute.splash.path &&
            authNotifier.isInitialized) {
          return authNotifier.isAuthenticated
              ? AppRoute.home.path
              : AppRoute.login.path;
        }

        final isAuthenticated = authNotifier.isAuthenticated;

        // If the user is not authenticated, they can only access login and
        // register
        if (!isAuthenticated) {
          if (state.matchedLocation != AppRoute.login.path &&
              state.matchedLocation != AppRoute.register.path) {
            return AppRoute.login.path;
          }
        }
        // If the user is authenticated, they shouldn't access login or register
        else {
          if (state.matchedLocation == AppRoute.login.path ||
              state.matchedLocation == AppRoute.register.path) {
            return AppRoute.home.path;
          }
        }

        return null;
      },
    );
  }
}
