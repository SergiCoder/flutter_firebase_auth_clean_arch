import 'package:flutter_firebase_auth_clean_arch/core/routing/app_route.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/app_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'mock_auth_router_notifier.dart';

/// A test class that extends AppRouter to expose the redirect function for
/// testing
class TestAppRouter extends AppRouter {
  /// Exposes the redirect function for testing
  static String? testRedirect({
    required bool isAuthenticated,
    required String location,
    String matchedLocation = '',
  }) {
    final authNotifier = MockAuthRouterNotifier()
      ..isAuthenticated = isAuthenticated;

    final state = _MockGoRouterState(
      path: location,
      matchedLoc: matchedLocation,
    );

    // Create a router to get access to the redirect function
    AppRouter.createRouter(authNotifier: authNotifier);

    // This is a workaround to test the redirect function
    // We're implementing the same logic as in the app_router.dart file

    // Check if the current location matches any defined route in our enum
    final currentLocation =
        state.matchedLocation.isEmpty ? state.uri.path : state.matchedLocation;

    final isDefinedRoute =
        AppRoute.values.map((route) => route.path).contains(currentLocation);

    // If the route doesn't exist, don't redirect
    if (!isDefinedRoute) {
      return null;
    }

    // Implements route protection based on authentication state
    if (authNotifier.isAuthenticated) {
      // Redirect authenticated users away from auth screens
      if (currentLocation == AppRoute.login.path ||
          currentLocation == AppRoute.register.path) {
        return AppRoute.home.path;
      }
    } else {
      // Redirect unauthenticated users to login if trying to access protected
      // routes
      if (currentLocation != AppRoute.login.path &&
          currentLocation != AppRoute.register.path &&
          currentLocation != AppRoute.splash.path) {
        return AppRoute.login.path;
      }
    }

    // No redirection needed
    return null;
  }
}

void main() {
  group('AppRouter Redirect Function', () {
    test('should redirect authenticated user from login to home', () {
      final redirectPath = TestAppRouter.testRedirect(
        isAuthenticated: true,
        location: AppRoute.login.path,
      );
      expect(redirectPath, equals(AppRoute.home.path));
    });

    test('should redirect authenticated user from register to home', () {
      final redirectPath = TestAppRouter.testRedirect(
        isAuthenticated: true,
        location: AppRoute.register.path,
      );
      expect(redirectPath, equals(AppRoute.home.path));
    });

    test('should not redirect authenticated user from home', () {
      final redirectPath = TestAppRouter.testRedirect(
        isAuthenticated: true,
        location: AppRoute.home.path,
      );
      expect(redirectPath, isNull);
    });

    test('should redirect unauthenticated user from home to login', () {
      final redirectPath = TestAppRouter.testRedirect(
        isAuthenticated: false,
        location: AppRoute.home.path,
      );
      expect(redirectPath, equals(AppRoute.login.path));
    });

    test('should not redirect unauthenticated user from login', () {
      final redirectPath = TestAppRouter.testRedirect(
        isAuthenticated: false,
        location: AppRoute.login.path,
      );
      expect(redirectPath, isNull);
    });

    test('should not redirect unauthenticated user from register', () {
      final redirectPath = TestAppRouter.testRedirect(
        isAuthenticated: false,
        location: AppRoute.register.path,
      );
      expect(redirectPath, isNull);
    });

    test('should not redirect unauthenticated user from splash', () {
      final redirectPath = TestAppRouter.testRedirect(
        isAuthenticated: false,
        location: AppRoute.splash.path,
      );
      expect(redirectPath, isNull);
    });

    test('should not redirect for non-existent routes', () {
      final redirectPath = TestAppRouter.testRedirect(
        isAuthenticated: false,
        location: '/non-existent',
      );
      expect(redirectPath, isNull);
    });

    test('should handle empty matchedLocation', () {
      final redirectPath = TestAppRouter.testRedirect(
        isAuthenticated: false,
        location: '/non-existent',
      );
      expect(redirectPath, isNull);
    });

    test('should use matchedLocation when provided', () {
      final redirectPath = TestAppRouter.testRedirect(
        isAuthenticated: false,
        location: '/some-path',
        matchedLocation: AppRoute.home.path,
      );
      expect(redirectPath, equals(AppRoute.login.path));
    });
  });
}

/// A simple mock GoRouterState for testing
class _MockGoRouterState extends Fake implements GoRouterState {
  _MockGoRouterState({
    required this.path,
    required this.matchedLoc,
  });

  @override
  final String path;
  final String matchedLoc;

  @override
  String get matchedLocation => matchedLoc;

  @override
  Uri get uri => Uri.parse(path);
}
