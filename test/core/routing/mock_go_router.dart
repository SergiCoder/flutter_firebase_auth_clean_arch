import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/app_route.dart';

/// A mock implementation of [GoRouter] for testing purposes.
///
/// This class provides a mock implementation of the GoRouter that can be used
/// in tests to verify navigation behavior without requiring a full router setup.
class MockGoRouter extends Mock implements GoRouter {
  /// The current location of the router.
  String _location = AppRoute.splash.path;

  /// Returns the current location of the router.
  @override
  String get location => _location;

  /// Mocks navigation to the specified location.
  ///
  /// Updates the internal location state and records the navigation for
  /// verification in tests.
  ///
  /// [location] The path to navigate to.
  /// [extra] Optional extra data to pass with the navigation.
  @override
  void go(String location, {Object? extra}) {
    _location = location;
  }

  /// Mocks pushing a new location onto the navigation stack.
  ///
  /// Updates the internal location state and records the navigation for
  /// verification in tests.
  ///
  /// [location] The path to push onto the navigation stack.
  /// [extra] Optional extra data to pass with the navigation.
  @override
  Future<T?> push<T extends Object?>(String location, {Object? extra}) {
    _location = location;
    return Future<T?>.value(null);
  }

  /// Mocks replacing the current location with a new one.
  ///
  /// Updates the internal location state and records the navigation for
  /// verification in tests.
  ///
  /// [location] The path to replace the current location with.
  /// [extra] Optional extra data to pass with the navigation.
  @override
  Future<T?> replace<T extends Object?>(String location, {Object? extra}) {
    _location = location;
    return Future<T?>.value(null);
  }

  /// Mocks popping the current route.
  ///
  /// Records the pop operation for verification in tests.
  @override
  void pop<T extends Object?>([T? result]) {
    // No-op implementation for testing
  }

  /// Resets the mock to its initial state.
  ///
  /// This method clears all recorded interactions and resets the location
  /// to the splash screen.
  void reset() {
    _location = AppRoute.splash.path;
    clearInteractions(this);
  }
}

/// A provider function to create a mock [GoRouter] for testing.
///
/// This function creates a mock router that can be used in widget tests
/// to verify navigation behavior.
///
/// [initialLocation] The initial location of the router.
/// Returns a configured mock [GoRouter].
GoRouter createMockRouter({String? initialLocation}) {
  final router = MockGoRouter();

  // Set the initial location if provided
  if (initialLocation != null) {
    router._location = initialLocation;
  }

  return router;
}
