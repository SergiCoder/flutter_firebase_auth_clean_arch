import 'dart:developer' as developer;

import 'package:flutter_firebase_auth_clean_arch/features/error/presentation/providers/state/error_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A notifier that manages the state of error handling
class ErrorNotifier extends StateNotifier<ErrorState> {
  /// Creates a new [ErrorNotifier]
  ///
  /// [forceException] can be set to true to force an exception during processing
  /// This is primarily used for testing the catch block
  ErrorNotifier({this.forceException = false}) : super(const ErrorInitial());

  /// Flag to force an exception during processing (for testing)
  final bool forceException;

  /// Processes an error
  Future<void> processError(String errorMessage) async {
    state = const ErrorProcessing();

    try {
      // Simulate error processing
      if (forceException) {
        throw Exception('Forced exception for testing');
      }
      await Future<void>.delayed(const Duration(seconds: 1));

      // Successfully handled the error
      state = const ErrorHandled();

      // Log successful error handling
      developer.log(
        'Error successfully processed: $errorMessage',
        name: 'ErrorNotifier',
      );
    } catch (e) {
      // Failed to handle the error
      state = ErrorFailed(e.toString());

      // Log the error handling failure
      developer.log(
        'Error processing failed: $errorMessage',
        name: 'ErrorNotifier',
        error: e,
      );
    }
  }

  /// Resets the error state to initial
  void reset() {
    state = const ErrorInitial();

    // Log state reset
    developer.log(
      'Error state reset',
      name: 'ErrorNotifier',
    );
  }
}

/// Provider for the error handling state
final errorProvider =
    StateNotifierProvider.autoDispose<ErrorNotifier, ErrorState>(
  (ref) => ErrorNotifier(),
);
