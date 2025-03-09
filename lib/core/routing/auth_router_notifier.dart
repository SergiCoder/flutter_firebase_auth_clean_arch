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
    _init();
  }

  /// The authentication repository
  final AuthRepository _authRepository;

  /// Whether the user is authenticated
  bool _isAuthenticated = false;

  /// Returns whether the user is authenticated
  bool get isAuthenticated => _isAuthenticated;

  /// Subscription to auth state changes
  StreamSubscription<bool>? _authSubscription;

  Future<void> _init() async {
    // Check initial authentication state
    _isAuthenticated = await _authRepository.isAuthenticated();

    // Listen to authentication state changes
    _authSubscription =
        _authRepository.authStateChanges.listen((isAuthenticated) {
      _isAuthenticated = isAuthenticated;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
