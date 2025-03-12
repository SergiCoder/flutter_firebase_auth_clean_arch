import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/providers/state/splash_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SplashState', () {
    test('SplashInitial props should be empty', () {
      // Arrange
      const state = SplashInitial();

      // Assert
      expect(state.props, isEmpty);
    });

    test('SplashLoading props should be empty', () {
      // Arrange
      const state = SplashLoading();

      // Assert
      expect(state.props, isEmpty);
    });

    test('SplashError props should contain message', () {
      // Arrange
      const message = 'Test error message';
      const state = SplashError(message);

      // Assert
      expect(state.props, [message]);
      expect(state.message, equals(message));
    });

    test('SplashNavigate props should contain isAuthenticated', () {
      // Arrange
      const state = SplashNavigate(isAuthenticated: true);

      // Assert
      expect(state.props, [true]);
      expect(state.isAuthenticated, isTrue);
    });

    test('SplashInitial instances should be equal', () {
      // Arrange
      const state1 = SplashInitial();
      const state2 = SplashInitial();

      // Assert
      expect(state1, equals(state2));
    });

    test('SplashLoading instances should be equal', () {
      // Arrange
      const state1 = SplashLoading();
      const state2 = SplashLoading();

      // Assert
      expect(state1, equals(state2));
    });

    test('SplashError instances with same message should be equal', () {
      // Arrange
      const message = 'Test error message';
      const state1 = SplashError(message);
      const state2 = SplashError(message);

      // Assert
      expect(state1, equals(state2));
    });

    test('SplashError instances with different messages should not be equal',
        () {
      // Arrange
      const state1 = SplashError('Message 1');
      const state2 = SplashError('Message 2');

      // Assert
      expect(state1, isNot(equals(state2)));
    });

    test('SplashNavigate instances with same isAuthenticated should be equal',
        () {
      // Arrange
      const state1 = SplashNavigate(isAuthenticated: true);
      const state2 = SplashNavigate(isAuthenticated: true);

      // Assert
      expect(state1, equals(state2));
    });

    test(
        'SplashNavigate instances with different isAuthenticated should not be equal',
        () {
      // Arrange
      const state1 = SplashNavigate(isAuthenticated: true);
      const state2 = SplashNavigate(isAuthenticated: false);

      // Assert
      expect(state1, isNot(equals(state2)));
    });

    test('Different state types should not be equal', () {
      // Arrange
      const initial = SplashInitial();
      const loading = SplashLoading();
      const error = SplashError('Error message');
      const navigate = SplashNavigate(isAuthenticated: true);

      // Assert
      expect(initial, isNot(equals(loading)));
      expect(initial, isNot(equals(error)));
      expect(initial, isNot(equals(navigate)));
      expect(loading, isNot(equals(error)));
      expect(loading, isNot(equals(navigate)));
      expect(error, isNot(equals(navigate)));
    });
  });
}
