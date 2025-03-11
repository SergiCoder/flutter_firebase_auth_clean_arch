import 'package:flutter_firebase_auth_clean_arch/core/core.dart';
import 'package:flutter_firebase_auth_clean_arch/features/features.dart';
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
        // Check if the current location matches any defined route in our enum
        // For non-existent routes, we need to check if the location exists in
        //our routes
        final location = state.matchedLocation.isEmpty
            ? state.uri.path
            : state.matchedLocation;

        final isDefinedRoute =
            AppRoute.values.map((route) => route.path).contains(location);

        // If the route doesn't exist, don't redirect and let errorBuilder
        // handle it
        if (!isDefinedRoute) {
          return null;
        }

        // Implements route protection based on authentication state:
        // 1. Authenticated users trying to access login/register are redirected
        // to home
        // 2. Unauthenticated users can only access public routes (splash,
        //login, register)

        if (authNotifier.isAuthenticated) {
          // Redirect authenticated users away from auth screens
          if (location == AppRoute.login.path ||
              location == AppRoute.register.path) {
            return AppRoute.home.path;
          }
        } else {
          // Redirect unauthenticated users to login if trying to access
          //protected routes
          if (location != AppRoute.login.path &&
              location != AppRoute.register.path &&
              location != AppRoute.splash.path) {
            return AppRoute.login.path;
          }
        }

        // No redirection needed
        return null;
      },
    );
  }
}
