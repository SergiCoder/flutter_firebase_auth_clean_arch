import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/auth_router_notifier.dart';

/// A mock implementation of [AuthRouterNotifier] for testing purposes.
///
/// This class provides a mock implementation of the AuthRouterNotifier that can
/// be used in tests to simulate different authentication states without
/// requiring a real authentication repository.
class MockAuthRouterNotifier extends ChangeNotifier
    implements AuthRouterNotifier {
  /// Creates a new [MockAuthRouterNotifier] with the specified authentication
  /// state.
  ///
  /// [isAuthenticated] Whether the user should be considered authenticated.
  MockAuthRouterNotifier({bool isAuthenticated = false})
      : _isAuthenticated = isAuthenticated;

  /// Whether the user is authenticated.
  bool _isAuthenticated;

  /// Returns whether the user is currently authenticated.
  @override
  bool get isAuthenticated => _isAuthenticated;

  /// Sets the authentication state and notifies listeners.
  ///
  /// [value] The new authentication state.
  set isAuthenticated(bool value) {
    if (_isAuthenticated != value) {
      _isAuthenticated = value;
      notifyListeners();
    }
  }
}
