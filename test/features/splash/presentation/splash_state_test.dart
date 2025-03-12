import 'package:flutter_firebase_auth_clean_arch/features/splash/presentation/providers/splash_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SplashState', () {
    group('SplashError', () {
      test('equality works correctly', () {
        // Arrange
        const error1 = SplashError('Error message');
        const error2 = SplashError('Error message');
        const error3 = SplashError('Different error message');

        // Assert
        expect(error1, equals(error2));
        expect(error1, isNot(equals(error3)));
      });

      test('hashCode works correctly', () {
        // Arrange
        const error1 = SplashError('Error message');
        const error2 = SplashError('Error message');
        const error3 = SplashError('Different error message');

        // Assert
        expect(error1.hashCode, equals(error2.hashCode));
        expect(error1.hashCode, isNot(equals(error3.hashCode)));
      });
    });

    group('SplashNavigate', () {
      test('equality works correctly', () {
        // Arrange
        const navigate1 = SplashNavigate(isAuthenticated: true);
        const navigate2 = SplashNavigate(isAuthenticated: true);
        const navigate3 = SplashNavigate(isAuthenticated: false);

        // Assert
        expect(navigate1, equals(navigate2));
        expect(navigate1, isNot(equals(navigate3)));
      });

      test('hashCode works correctly', () {
        // Arrange
        const navigate1 = SplashNavigate(isAuthenticated: true);
        const navigate2 = SplashNavigate(isAuthenticated: true);
        const navigate3 = SplashNavigate(isAuthenticated: false);

        // Assert
        expect(navigate1.hashCode, equals(navigate2.hashCode));
        expect(navigate1.hashCode, isNot(equals(navigate3.hashCode)));
      });
    });

    group('SplashInitial', () {
      test('can be instantiated', () {
        // Arrange & Act
        const initial = SplashInitial();

        // Assert
        expect(initial, isA<SplashState>());
      });
    });

    group('SplashLoading', () {
      test('can be instantiated', () {
        // Arrange & Act
        const loading = SplashLoading();

        // Assert
        expect(loading, isA<SplashState>());
      });
    });
  });
}
