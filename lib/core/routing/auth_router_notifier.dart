import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';

/// A notifier that listens to authentication state changes and refreshes the
/// router
class AuthRouterNotifier extends ChangeNotifier {
  /// Creates a new [AuthRouterNotifier] with the given auth repository
  AuthRouterNotifier({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository {
    _initializeAuthState();
  }

  /// The authentication repository
  final AuthRepository _authRepository;

  /// Whether the user is authenticated
  bool _isAuthenticated = false;

  /// Whether the initial authentication check has completed
  bool _isInitialized = false;

  /// Returns whether the user is authenticated
  bool get isAuthenticated => _isAuthenticated;

  /// Returns whether the initial authentication check has completed
  bool get isInitialized => _isInitialized;

  /// Subscription to auth state changes
  StreamSubscription<bool>? _authSubscription;

  /// Initializes the authentication state
  Future<void> _initializeAuthState() async {
    try {
      // Check initial authentication state
      _isAuthenticated = await _authRepository.isAuthenticated();
      _isInitialized = true;
      notifyListeners();

      // Listen to authentication state changes
      _authSubscription =
          _authRepository.authStateChanges.listen((isAuthenticated) {
        _isAuthenticated = isAuthenticated;
        notifyListeners();
      });
    } catch (e) {
      // Handle initialization errors
      _isInitialized = true;
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
