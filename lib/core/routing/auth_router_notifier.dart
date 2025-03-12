import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/providers/auth_usecases_providers.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/usecases/get_auth_state_changes_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A notifier that listens to authentication state changes and refreshes the
/// router.
///
/// This class is responsible for:
/// - Tracking the user's authentication state
/// - Providing redirection logic based on authentication status
/// - Notifying listeners when authentication state changes
class AuthRouterNotifier extends ChangeNotifier {
  /// Creates a new [AuthRouterNotifier] with the given auth state changes
  /// use case.
  ///
  /// Initializes authentication state tracking and sets up listeners for
  /// authentication state changes.
  ///
  /// [getAuthStateChangesUseCase] Use case that provides authentication state
  /// changes.
  AuthRouterNotifier({
    required GetAuthStateChangesUseCase getAuthStateChangesUseCase,
  })  : _getAuthStateChangesUseCase = getAuthStateChangesUseCase,
        _isAuthenticated = false {
    _initializeAuthState();
  }

  /// The use case for getting authentication state changes
  final GetAuthStateChangesUseCase _getAuthStateChangesUseCase;

  /// Whether the user is authenticated
  bool _isAuthenticated;

  /// Returns whether the user is currently authenticated.
  ///
  /// This value is updated automatically when authentication state changes.
  bool get isAuthenticated => _isAuthenticated;

  /// Subscription to auth state changes from the use case
  StreamSubscription<bool>? _authSubscription;

  /// Initializes the authentication state by subscribing to auth state changes
  Future<void> _initializeAuthState() async {
    try {
      // Listen to authentication state changes
      _authSubscription =
          _getAuthStateChangesUseCase.execute().listen((isAuthenticated) {
        _isAuthenticated = isAuthenticated;
        notifyListeners();

        // Log authentication state change
        developer.log(
          'Authentication state changed: $isAuthenticated',
          name: 'AuthRouterNotifier',
        );
      });

      // Log successful initialization
      developer.log(
        'Auth router notifier initialized',
        name: 'AuthRouterNotifier',
      );
    } catch (e) {
      // Handle initialization errors
      _isAuthenticated = false;
      notifyListeners();

      // Log initialization error
      developer.log(
        'Auth router notifier initialization failed',
        name: 'AuthRouterNotifier',
        error: e,
      );
    }
  }

  /// Cancels the auth state subscription and disposes resources.
  ///
  /// This method is called automatically when the notifier is no longer needed.
  @override
  void dispose() {
    _authSubscription?.cancel();

    // Log disposal
    developer.log(
      'Auth router notifier disposed',
      name: 'AuthRouterNotifier',
    );

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
    getAuthStateChangesUseCase: ref.watch(getAuthStateChangesUseCaseProvider),
  ),
);
