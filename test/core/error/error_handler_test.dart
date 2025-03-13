// ignore_for_file: must_be_immutable, document_ignores
// Mock classes in this file need to be mutable to properly function as mocks

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_auth_clean_arch/core/error/error_handler.dart';
import 'package:flutter_firebase_auth_clean_arch/core/error/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock Firebase exceptions
class MockFirebaseAuthException extends Mock implements FirebaseAuthException {
  MockFirebaseAuthException({required this.code, this.message});
  @override
  final String code;
  @override
  final String? message;
}

class MockFirebaseException extends Mock implements FirebaseException {
  MockFirebaseException({required this.code, this.message});
  @override
  final String code;
  @override
  final String? message;
}

void main() {
  group('ErrorHandler', () {
    late ErrorHandler errorHandler;

    setUp(() {
      errorHandler = const ErrorHandler();
    });

    group('handleFirebaseAuthError', () {
      test('should return InvalidCredentialsException for invalid-email code',
          () {
        // Arrange
        final exception = MockFirebaseAuthException(
          code: 'invalid-email',
        );

        // Act
        final result = errorHandler.handleFirebaseAuthError(exception);

        // Assert
        expect(result, isA<InvalidCredentialsException>());
        expect(result.message, equals('Invalid email or password'));
        expect(result.code, equals('invalid_credentials'));
        expect(result.originalError, equals(exception));
      });

      test('should return InvalidCredentialsException for user-not-found code',
          () {
        // Arrange
        final exception = MockFirebaseAuthException(
          code: 'user-not-found',
          message: 'No user found for that email.',
        );

        // Act
        final result = errorHandler.handleFirebaseAuthError(exception);

        // Assert
        expect(result, isA<InvalidCredentialsException>());
        expect(result.message, equals('No user found for that email.'));
        expect(result.code, equals('invalid_credentials'));
        expect(result.originalError, equals(exception));
      });

      test('should return InvalidCredentialsException for wrong-password code',
          () {
        // Arrange
        final exception = MockFirebaseAuthException(
          code: 'wrong-password',
          message: 'Wrong password provided for that user.',
        );

        // Act
        final result = errorHandler.handleFirebaseAuthError(exception);

        // Assert
        expect(result, isA<InvalidCredentialsException>());
        expect(
          result.message,
          equals('Wrong password provided for that user.'),
        );
        expect(result.code, equals('invalid_credentials'));
        expect(result.originalError, equals(exception));
      });

      test('should return InvalidCredentialsException for user-disabled code',
          () {
        // Arrange
        final exception = MockFirebaseAuthException(
          code: 'user-disabled',
          message: 'User account has been disabled.',
        );

        // Act
        final result = errorHandler.handleFirebaseAuthError(exception);

        // Assert
        expect(result, isA<InvalidCredentialsException>());
        expect(result.message, equals('User account has been disabled.'));
        expect(result.code, equals('invalid_credentials'));
        expect(result.originalError, equals(exception));
      });

      test(
          'should return EmailAlreadyInUseException for '
          'email-already-in-use code', () {
        // Arrange
        final exception = MockFirebaseAuthException(
          code: 'email-already-in-use',
          message: 'The email address is already in use by another account.',
        );

        // Act
        final result = errorHandler.handleFirebaseAuthError(exception);

        // Assert
        expect(result, isA<EmailAlreadyInUseException>());
        expect(
          result.message,
          equals('The email address is already in use by another account.'),
        );
        expect(result.code, equals('email_already_in_use'));
        expect(result.originalError, equals(exception));
      });

      test('should return WeakPasswordException for weak-password code', () {
        // Arrange
        final exception = MockFirebaseAuthException(
          code: 'weak-password',
          message: 'Password should be at least 6 characters.',
        );

        // Act
        final result = errorHandler.handleFirebaseAuthError(exception);

        // Assert
        expect(result, isA<WeakPasswordException>());
        expect(
          result.message,
          equals('Password should be at least 6 characters.'),
        );
        expect(result.code, equals('weak_password'));
        expect(result.originalError, equals(exception));
      });

      test('should return AuthException for operation-not-allowed code', () {
        // Arrange
        final exception = MockFirebaseAuthException(
          code: 'operation-not-allowed',
          message: 'This operation is not allowed.',
        );

        // Act
        final result = errorHandler.handleFirebaseAuthError(exception);

        // Assert
        expect(result, isA<AuthException>());
        expect(result.message, equals('This operation is not allowed.'));
        expect(result.code, equals('operation_not_allowed'));
        expect(result.originalError, equals(exception));
      });

      test('should return AuthException for requires-recent-login code', () {
        // Arrange
        final exception = MockFirebaseAuthException(
          code: 'requires-recent-login',
          message: 'This operation requires recent authentication.',
        );

        // Act
        final result = errorHandler.handleFirebaseAuthError(exception);

        // Assert
        expect(result, isA<AuthException>());
        expect(result.message,
            equals('This operation requires recent authentication.'));
        expect(result.code, equals('requires_recent_login'));
        expect(result.originalError, equals(exception));
      });

      test('should return AuthException for unknown code', () {
        // Arrange
        final exception = MockFirebaseAuthException(
          code: 'unknown-code',
          message: 'An unknown error occurred.',
        );

        // Act
        final result = errorHandler.handleFirebaseAuthError(exception);

        // Assert
        expect(result, isA<AuthException>());
        expect(result.message, equals('An unknown error occurred.'));
        expect(result.code, equals('unknown-code'));
        expect(result.originalError, equals(exception));
      });

      test('should use default message when message is null', () {
        // Arrange
        final exception = MockFirebaseAuthException(
          code: 'invalid-email',
        );

        // Act
        final result = errorHandler.handleFirebaseAuthError(exception);

        // Assert
        expect(result, isA<InvalidCredentialsException>());
        expect(result.message, equals('Invalid email or password'));
      });
    });

    group('handleFirebaseError', () {
      test('should return PermissionDeniedException for permission-denied code',
          () {
        // Arrange
        final exception = MockFirebaseException(
          code: 'permission-denied',
          message: 'Missing or insufficient permissions.',
        );

        // Act
        final result = errorHandler.handleFirebaseError(exception);

        // Assert
        expect(result, isA<PermissionDeniedException>());
        expect(result.message, equals('Missing or insufficient permissions.'));
        expect(result.code, equals('permission_denied'));
        expect(result.originalError, equals(exception));
      });

      test('should return NotFoundException for not-found code', () {
        // Arrange
        final exception = MockFirebaseException(
          code: 'not-found',
          message: 'Document does not exist.',
        );

        // Act
        final result = errorHandler.handleFirebaseError(exception);

        // Assert
        expect(result, isA<NotFoundException>());
        expect(result.message, equals('Document does not exist.'));
        expect(result.code, equals('not_found'));
        expect(result.originalError, equals(exception));
      });

      test('should return DataException for unknown code', () {
        // Arrange
        final exception = MockFirebaseException(
          code: 'unknown-code',
          message: 'An unknown database error occurred.',
        );

        // Act
        final result = errorHandler.handleFirebaseError(exception);

        // Assert
        expect(result, isA<DataException>());
        expect(result.message, equals('An unknown database error occurred.'));
        expect(result.code, equals('unknown-code'));
        expect(result.originalError, equals(exception));
      });

      test('should use default message when message is null', () {
        // Arrange
        final exception = MockFirebaseException(
          code: 'not-found',
        );

        // Act
        final result = errorHandler.handleFirebaseError(exception);

        // Assert
        expect(result, isA<NotFoundException>());
        expect(result.message, equals('The requested data was not found'));
      });
    });

    group('handleError', () {
      test('should call handleFirebaseAuthError for FirebaseAuthException', () {
        // Arrange
        final exception = MockFirebaseAuthException(
          code: 'invalid-email',
        );

        // Act
        final result = errorHandler.handleError(exception);

        // Assert
        expect(result, isA<InvalidCredentialsException>());
      });

      test('should call handleFirebaseError for FirebaseException', () {
        // Arrange
        final exception = MockFirebaseException(
          code: 'not-found',
        );

        // Act
        final result = errorHandler.handleError(exception);

        // Assert
        expect(result, isA<NotFoundException>());
      });

      test('should return the same exception for AppException', () {
        // Arrange
        const exception = InvalidCredentialsException(
          message: 'Invalid credentials',
        );

        // Act
        final result = errorHandler.handleError(exception);

        // Assert
        expect(result, equals(exception));
      });

      test('should return UnexpectedException for other errors', () {
        // Arrange
        final exception = Exception('A generic exception');

        // Act
        final result = errorHandler.handleError(exception);

        // Assert
        expect(result, isA<UnexpectedException>());
        expect(result.message, equals('Exception: A generic exception'));
        expect(result.code, equals('unexpected_error'));
        expect(result.originalError, equals(exception));
      });

      test('should handle null error with default message', () {
        // Act
        final result = errorHandler.handleError(null);

        // Assert
        expect(result, isA<UnexpectedException>());
        expect(result.message, equals('An unexpected error occurred'));
        expect(result.code, equals('unexpected_error'));
        expect(result.originalError, isNull);
      });
    });
  });
}
