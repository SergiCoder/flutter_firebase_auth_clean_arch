import 'package:flutter_firebase_auth_clean_arch/core/error/exceptions.dart';
import 'package:flutter_firebase_auth_clean_arch/features/error/presentation/providers/error_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/error/presentation/providers/state/error_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ErrorNotifier complete coverage', () {
    late ErrorNotifier errorNotifier;

    setUp(() {
      errorNotifier = ErrorNotifier();
    });

    test('processException transitions through states correctly', () async {
      // Initial state should be ErrorInitial
      expect(errorNotifier.state, isA<ErrorInitial>());

      // Process an exception
      const exception = InvalidCredentialsException();
      final future = errorNotifier.processException(exception);

      // State should be ErrorProcessing
      expect(errorNotifier.state, isA<ErrorProcessing>());

      // Wait for the future to complete
      await future;

      // State should be ErrorHandled
      expect(errorNotifier.state, isA<ErrorHandled>());
    });

    test('processException handles errors correctly', () async {
      // Create an error notifier that forces exceptions
      final forcingErrorNotifier = ErrorNotifier(forceException: true);

      // Initial state should be ErrorInitial
      expect(forcingErrorNotifier.state, isA<ErrorInitial>());

      // Process an exception
      const exception = InvalidCredentialsException();

      // The state will change to ErrorProcessing and then to ErrorFailed
      // when the future completes
      await forcingErrorNotifier.processException(exception);

      // State should be ErrorFailed
      expect(forcingErrorNotifier.state, isA<ErrorFailed>());
      expect(
        (forcingErrorNotifier.state as ErrorFailed).message,
        contains('Forced exception for testing'),
      );
    });

    test('reset sets state to ErrorInitial', () {
      // Set the state to something other than ErrorInitial
      errorNotifier.processError('Test error');
      expect(errorNotifier.state, isA<ErrorProcessing>());

      // Reset the state
      errorNotifier.reset();

      // State should be ErrorInitial
      expect(errorNotifier.state, isA<ErrorInitial>());
    });
  });
}
