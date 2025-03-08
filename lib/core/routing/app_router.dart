import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/locale_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/app_route.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/login_screen.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/presentation/register_screen.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/presentation/home_screen.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/splash_screen.dart';
import 'package:go_router/go_router.dart';

/// Provides the application's routing configuration
class AppRouter {
  /// Creates a router configuration for the app
  static GoRouter createRouter({
    required LocaleProvider localeProvider,
    bool isAuthenticated = false,
  }) {
    return GoRouter(
      initialLocation: AppRoute.splash.path,
      debugLogDiagnostics: true,
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
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('Page Not Found'),
        ),
        body: Center(
          child: Text('No route defined for ${state.uri.path}'),
        ),
      ),
      redirect: (context, state) {
        // Skip redirect for splash screen
        if (state.matchedLocation == AppRoute.splash.path) {
          return null;
        }

        // Add authentication redirects here if needed
        // For example, redirect unauthenticated users to login
        if (!isAuthenticated &&
            state.matchedLocation != AppRoute.login.path &&
            state.matchedLocation != AppRoute.register.path) {
          return AppRoute.login.path;
        }
        return null;
      },
    );
  }
}
