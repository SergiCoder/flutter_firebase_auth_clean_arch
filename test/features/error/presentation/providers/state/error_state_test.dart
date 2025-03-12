import 'package:flutter_firebase_auth_clean_arch/features/error/presentation/providers/state/error_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ErrorState', () {
    test('ErrorInitial props should be empty', () {
      // Arrange
      const state = ErrorInitial();

      // Assert
      expect(state.props, isEmpty);
    });

    test('ErrorProcessing props should be empty', () {
      // Arrange
      const state = ErrorProcessing();

      // Assert
      expect(state.props, isEmpty);
    });

    test('ErrorHandled props should be empty', () {
      // Arrange
      const state = ErrorHandled();

      // Assert
      expect(state.props, isEmpty);
    });

    test('ErrorFailed props should contain message', () {
      // Arrange
      const message = 'Test error message';
      const state = ErrorFailed(message);

      // Assert
      expect(state.props, [message]);
      expect(state.message, equals(message));
    });

    test('ErrorFailed instances with same message should be equal', () {
      // Arrange
      const message = 'Test error message';
      const state1 = ErrorFailed(message);
      const state2 = ErrorFailed(message);

      // Assert
      expect(state1, equals(state2));
    });

    test('ErrorFailed instances with different messages should not be equal',
        () {
      // Arrange
      const state1 = ErrorFailed('Message 1');
      const state2 = ErrorFailed('Message 2');

      // Assert
      expect(state1, isNot(equals(state2)));
    });

    test('Different state types should not be equal', () {
      // Arrange
      const initial = ErrorInitial();
      const processing = ErrorProcessing();
      const handled = ErrorHandled();
      const failed = ErrorFailed('Error message');

      // Assert
      expect(initial, isNot(equals(processing)));
      expect(initial, isNot(equals(handled)));
      expect(initial, isNot(equals(failed)));
      expect(processing, isNot(equals(handled)));
      expect(processing, isNot(equals(failed)));
      expect(handled, isNot(equals(failed)));
    });
  });
}
