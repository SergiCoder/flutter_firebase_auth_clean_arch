import 'package:flutter_firebase_auth_clean_arch/core/error/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Exceptions Complete Coverage Tests', () {
    test('UserNotAuthenticatedException constructor with originalError', () {
      // Arrange
      final originalError = Exception('Original error');

      // Act
      final exception = UserNotAuthenticatedException(
        message: 'Custom message',
        originalError: originalError,
      );

      // Assert
      expect(exception, isA<AuthException>());
      expect(exception.message, equals('Custom message'));
      expect(exception.code, equals('user_not_authenticated'));
      expect(exception.originalError, equals(originalError));

      // This test specifically targets the super constructor call in
      // UserNotAuthenticatedException
    });

    test('NoInternetException constructor with originalError', () {
      // Arrange
      final originalError = Exception('Original error');

      // Act
      final exception = NoInternetException(
        message: 'Custom message',
        originalError: originalError,
      );

      // Assert
      expect(exception, isA<NetworkException>());
      expect(exception.message, equals('Custom message'));
      expect(exception.code, equals('no_internet'));
      expect(exception.originalError, equals(originalError));

      // This test specifically targets the super constructor call in
      // NoInternetException
    });

    test('TimeoutException constructor with originalError', () {
      // Arrange
      final originalError = Exception('Original error');

      // Act
      final exception = TimeoutException(
        message: 'Custom message',
        originalError: originalError,
      );

      // Assert
      expect(exception, isA<NetworkException>());
      expect(exception.message, equals('Custom message'));
      expect(exception.code, equals('timeout'));
      expect(exception.originalError, equals(originalError));

      // This test specifically targets the super constructor call in
      // TimeoutException
    });

    test('AppException toString method', () {
      // Arrange
      const exception = UnexpectedException(
        message: 'Test message',
        // Using a specific code to test toString
      );

      // Act
      final result = exception.toString();

      // Assert
      expect(result, equals('AppException: unexpected_error - Test message'));

      // This test ensures the toString method is fully covered
    });
  });
}
