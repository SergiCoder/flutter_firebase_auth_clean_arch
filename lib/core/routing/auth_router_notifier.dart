import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/data/providers/auth_repository_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A notifier that listens to authentication state changes and refreshes the
/// router.
///
/// This class is responsible for:
/// - Tracking the user's authentication state
/// - Providing redirection logic based on authentication status
/// - Notifying listeners when authentication state changes
class AuthRouterNotifier extends ChangeNotifier {
  /// Creates a new [AuthRouterNotifier] with the given auth repository.
  ///
  /// Initializes authentication state tracking and sets up listeners for
  /// authentication state changes.
  ///
  /// [authRepository] Repository that provides authentication operations and
  /// state changes.
  AuthRouterNotifier({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository {
    _initializeAuthState();
  }

  /// The authentication repository used to monitor auth state
  final AuthRepository _authRepository;

  /// Whether the user is authenticated
  bool _isAuthenticated = false;

  /// Returns whether the user is currently authenticated.
  ///
  /// This value is updated automatically when authentication state changes.
  bool get isAuthenticated => _isAuthenticated;

  /// Subscription to auth state changes from the repository
  StreamSubscription<bool>? _authSubscription;

  /// Initializes the authentication state by subscribing to auth state changes
  Future<void> _initializeAuthState() async {
    try {
      // Listen to authentication state changes
      _authSubscription =
          _authRepository.authStateChanges.listen((isAuthenticated) {
        _isAuthenticated = isAuthenticated;
        notifyListeners();
      });
    } catch (e) {
      // Handle initialization errors
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  /// Cancels the auth state subscription and disposes resources.
  ///
  /// This method is called automatically when the notifier is no longer needed.
  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}

/// Provider for the auth router notifier.
///
/// This provider creates and exposes an [AuthRouterNotifier] instance that can
/// be used throughout the application to access authentication state and
/// handle navigation redirection.
final authRouterNotifierProvider = Provider<AuthRouterNotifier>(
  (ref) => AuthRouterNotifier(
    authRepository: ref.watch(authRepositoryProvider),
  ),
);
