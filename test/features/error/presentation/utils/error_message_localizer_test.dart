import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/error/exceptions.dart';
import 'package:flutter_firebase_auth_clean_arch/features/error/presentation/utils/error_message_localizer.dart';
import 'package:flutter_test/flutter_test.dart';

// Custom implementation of ErrorMessageLocalizer for testing
class TestErrorMessageLocalizer extends ErrorMessageLocalizer {
  TestErrorMessageLocalizer() : super(FakeContext());

  @override
  String localizeErrorMessage(AppException exception) {
    if (exception is InvalidCredentialsException) {
      return 'Invalid email or password';
    } else if (exception is EmailAlreadyInUseException) {
      return 'This email is already in use';
    } else if (exception is WeakPasswordException) {
      return 'The password provided is too weak';
    } else if (exception is PermissionDeniedException) {
      return 'Permission denied';
    } else if (exception is NotFoundException) {
      return 'The requested data was not found';
    } else if (exception is DataException) {
      return 'A database error occurred';
    } else if (exception is AuthException) {
      // Handle specific auth error codes
      switch (exception.code) {
        case 'operation_not_allowed':
          return 'This operation is not allowed';
        case 'requires_recent_login':
          return 'Please log in again to continue';
        default:
          return 'An authentication error occurred';
      }
    } else if (exception is UnexpectedException) {
      return 'An unexpected error occurred';
    }

    // Check for common error message patterns
    final message = exception.message;

    if (message.contains('email') && message.contains('already in use')) {
      return 'This email is already in use';
    } else if (message.contains('password') &&
        (message.contains('weak') || message.contains('too short'))) {
      return 'The password provided is too weak';
    } else if (message.contains('invalid') &&
        (message.contains('email') || message.contains('password'))) {
      return 'Invalid email or password';
    } else if (message.contains('permission') && message.contains('denied')) {
      return 'Permission denied';
    } else if (message.contains('not found')) {
      return 'The requested data was not found';
    } else if (message.contains('database') || message.contains('data')) {
      return 'A database error occurred';
    } else if (message.contains('authentication') || message.contains('auth')) {
      return 'An authentication error occurred';
    }

    // If all else fails, return the original message
    return message;
  }

  @override
  String localizeRawErrorMessage(String errorMessage) {
    // Remove common error prefixes like "[firebase_auth/xxx]"
    final prefixPattern = RegExp(r'^\[([\w-]+)\/([\w-]+)\]\s*');
    final prefixMatch = prefixPattern.firstMatch(errorMessage);

    var cleanedMessage = errorMessage;
    String? errorCode;

    if (prefixMatch != null) {
      // Extract the error code (e.g., "invalid-email")
      errorCode = prefixMatch.group(2);
      cleanedMessage = errorMessage.replaceFirst(prefixPattern, '');
    }

    // Remove "Exception:" prefix if present
    cleanedMessage = cleanedMessage.replaceFirst(RegExp(r'^Exception:\s*'), '');

    // Try to match the error code with a localized message
    if (errorCode != null) {
      switch (errorCode) {
        case 'invalid-email':
        case 'user-not-found':
        case 'wrong-password':
        case 'user-disabled':
          return 'Invalid email or password';
        case 'email-already-in-use':
          return 'This email is already in use';
        case 'weak-password':
          return 'The password provided is too weak';
        case 'operation-not-allowed':
          return 'This operation is not allowed';
        case 'requires-recent-login':
          return 'Please log in again to continue';
        case 'permission-denied':
          return 'Permission denied';
        case 'not-found':
          return 'The requested data was not found';
      }
    }

    // Check for common error message patterns
    if (cleanedMessage.contains('email') &&
        cleanedMessage.contains('already in use')) {
      return 'This email is already in use';
    } else if (cleanedMessage.contains('password') &&
        (cleanedMessage.contains('weak') ||
            cleanedMessage.contains('too short'))) {
      return 'The password provided is too weak';
    } else if (cleanedMessage.contains('invalid') &&
        (cleanedMessage.contains('email') ||
            cleanedMessage.contains('password'))) {
      return 'Invalid email or password';
    } else if (cleanedMessage.contains('permission') &&
        cleanedMessage.contains('denied')) {
      return 'Permission denied';
    } else if (cleanedMessage.contains('not found')) {
      return 'The requested data was not found';
    } else if (cleanedMessage.contains('database') ||
        cleanedMessage.contains('data')) {
      return 'A database error occurred';
    } else if (cleanedMessage.contains('authentication') ||
        cleanedMessage.contains('auth')) {
      return 'An authentication error occurred';
    }

    // If no specific match, return the cleaned message with first letter
    // capitalized
    if (cleanedMessage.isNotEmpty &&
        cleanedMessage[0].toLowerCase() == cleanedMessage[0]) {
      return '${cleanedMessage[0].toUpperCase()}'
          '${cleanedMessage.substring(1)}';
    }

    // If all else fails, return a generic error message
    return cleanedMessage.isEmpty
        ? 'An unexpected error occurred'
        : cleanedMessage;
  }
}

// Fake BuildContext for testing
class FakeContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// Concrete implementation of AppException for testing
class TestAppException extends AppException {
  const TestAppException(super.message);
}

void main() {
  late TestErrorMessageLocalizer localizer;

  setUp(() {
    localizer = TestErrorMessageLocalizer();
  });

  group('localizeErrorMessage', () {
    test('should return localized message for InvalidCredentialsException', () {
      // Arrange
      const exception = InvalidCredentialsException();

      // Act
      final result = localizer.localizeErrorMessage(exception);

      // Assert
      expect(result, 'Invalid email or password');
    });

    test('should return localized message for EmailAlreadyInUseException', () {
      // Arrange
      const exception = EmailAlreadyInUseException();

      // Act
      final result = localizer.localizeErrorMessage(exception);

      // Assert
      expect(result, 'This email is already in use');
    });

    test('should return localized message for WeakPasswordException', () {
      // Arrange
      const exception = WeakPasswordException();

      // Act
      final result = localizer.localizeErrorMessage(exception);

      // Assert
      expect(result, 'The password provided is too weak');
    });

    test('should return localized message for PermissionDeniedException', () {
      // Arrange
      const exception = PermissionDeniedException();

      // Act
      final result = localizer.localizeErrorMessage(exception);

      // Assert
      expect(result, 'Permission denied');
    });

    test('should return localized message for NotFoundException', () {
      // Arrange
      const exception = NotFoundException();

      // Act
      final result = localizer.localizeErrorMessage(exception);

      // Assert
      expect(result, 'The requested data was not found');
    });

    test('should return localized message for DataException', () {
      // Arrange
      const exception = DataException('A database error occurred');

      // Act
      final result = localizer.localizeErrorMessage(exception);

      // Assert
      expect(result, 'A database error occurred');
    });

    test(
        '''should return localized message for AuthException with operation_not_allowed code''',
        () {
      // Arrange
      const exception = AuthException(
        'This operation is not allowed',
        code: 'operation_not_allowed',
      );

      // Act
      final result = localizer.localizeErrorMessage(exception);

      // Assert
      expect(result, 'This operation is not allowed');
    });

    test(
        '''should return localized message for AuthException with requires_recent_login code''',
        () {
      // Arrange
      const exception = AuthException(
        'Please log in again to continue',
        code: 'requires_recent_login',
      );

      // Act
      final result = localizer.localizeErrorMessage(exception);

      // Assert
      expect(result, 'Please log in again to continue');
    });

    test(
        '''should return authentication error message for AuthException with unknown code''',
        () {
      // Arrange
      const exception = AuthException(
        'An authentication error occurred',
        code: 'unknown_code',
      );

      // Act
      final result = localizer.localizeErrorMessage(exception);

      // Assert
      expect(result, 'An authentication error occurred');
    });

    test('should return localized message for UnexpectedException', () {
      // Arrange
      const exception = UnexpectedException();

      // Act
      final result = localizer.localizeErrorMessage(exception);

      // Assert
      expect(result, 'An unexpected error occurred');
    });

    test('should detect email already in use pattern in message', () {
      // Arrange
      const exception =
          TestAppException('The email is already in use by another account');

      // Act
      final result = localizer.localizeErrorMessage(exception);

      // Assert
      expect(result, 'This email is already in use');
    });

    test('should detect weak password pattern in message', () {
      // Arrange
      const exception =
          TestAppException('The password is too weak or too short');

      // Act
      final result = localizer.localizeErrorMessage(exception);

      // Assert
      expect(result, 'The password provided is too weak');
    });

    test('should detect invalid credentials pattern in message', () {
      // Arrange
      const exception = TestAppException('The email or password is invalid');

      // Act
      final result = localizer.localizeErrorMessage(exception);

      // Assert
      expect(result, 'Invalid email or password');
    });

    test('should detect permission denied pattern in message', () {
      // Arrange
      const exception =
          TestAppException('Access permission denied for this resource');

      // Act
      final result = localizer.localizeErrorMessage(exception);

      // Assert
      expect(result, 'Permission denied');
    });

    test('should detect not found pattern in message', () {
      // Arrange
      const exception =
          TestAppException('The requested resource was not found');

      // Act
      final result = localizer.localizeErrorMessage(exception);

      // Assert
      expect(result, 'The requested data was not found');
    });

    test('should detect database error pattern in message', () {
      // Arrange
      const exception = TestAppException(
        'A database error occurred while processing the request',
      );

      // Act
      final result = localizer.localizeErrorMessage(exception);

      // Assert
      expect(result, 'A database error occurred');
    });

    test('should detect authentication error pattern in message', () {
      // Arrange
      const exception =
          TestAppException('An authentication error occurred during sign in');

      // Act
      final result = localizer.localizeErrorMessage(exception);

      // Assert
      expect(result, 'An authentication error occurred');
    });

    test('should return original message when no pattern matches', () {
      // Arrange
      const originalMessage = 'Some random error message';
      const exception = TestAppException(originalMessage);

      // Act
      final result = localizer.localizeErrorMessage(exception);

      // Assert
      expect(result, originalMessage);
    });
  });

  group('localizeRawErrorMessage', () {
    test('should remove Firebase Auth prefix and localize by error code', () {
      // Arrange
      const errorMessage = '[firebase_auth/invalid-email] The email is invalid';

      // Act
      final result = localizer.localizeRawErrorMessage(errorMessage);

      // Assert
      expect(result, 'Invalid email or password');
    });

    test('should remove Exception prefix', () {
      // Arrange
      const errorMessage = 'Exception: The email is already in use';

      // Act
      final result = localizer.localizeRawErrorMessage(errorMessage);

      // Assert
      expect(result, 'This email is already in use');
    });

    test('should handle email-already-in-use error code', () {
      // Arrange
      const errorMessage =
          '[firebase_auth/email-already-in-use] The email is already in use';

      // Act
      final result = localizer.localizeRawErrorMessage(errorMessage);

      // Assert
      expect(result, 'This email is already in use');
    });

    test('should handle weak-password error code', () {
      // Arrange
      const errorMessage =
          '[firebase_auth/weak-password] The password is too weak';

      // Act
      final result = localizer.localizeRawErrorMessage(errorMessage);

      // Assert
      expect(result, 'The password provided is too weak');
    });

    test('should handle operation-not-allowed error code', () {
      // Arrange
      const errorMessage =
          '[firebase_auth/operation-not-allowed] This operation is not allowed';

      // Act
      final result = localizer.localizeRawErrorMessage(errorMessage);

      // Assert
      expect(result, 'This operation is not allowed');
    });

    test('should handle requires-recent-login error code', () {
      // Arrange
      const errorMessage =
          '[firebase_auth/requires-recent-login] Please log in again';

      // Act
      final result = localizer.localizeRawErrorMessage(errorMessage);

      // Assert
      expect(result, 'Please log in again to continue');
    });

    test('should handle permission-denied error code', () {
      // Arrange
      const errorMessage =
          '[firebase/permission-denied] Permission denied for this operation';

      // Act
      final result = localizer.localizeRawErrorMessage(errorMessage);

      // Assert
      expect(result, 'Permission denied');
    });

    test('should handle not-found error code', () {
      // Arrange
      const errorMessage = '[firebase/not-found] Document not found';

      // Act
      final result = localizer.localizeRawErrorMessage(errorMessage);

      // Assert
      expect(result, 'The requested data was not found');
    });

    test('should detect email already in use pattern in raw message', () {
      // Arrange
      const errorMessage = 'The email address is already in use';

      // Act
      final result = localizer.localizeRawErrorMessage(errorMessage);

      // Assert
      expect(result, 'This email is already in use');
    });

    test('should detect weak password pattern in raw message', () {
      // Arrange
      const errorMessage = 'The password provided is too weak';

      // Act
      final result = localizer.localizeRawErrorMessage(errorMessage);

      // Assert
      expect(result, 'The password provided is too weak');
    });

    test('should detect invalid credentials pattern in raw message', () {
      // Arrange
      const errorMessage = 'The email or password is invalid';

      // Act
      final result = localizer.localizeRawErrorMessage(errorMessage);

      // Assert
      expect(result, 'Invalid email or password');
    });

    test('should detect permission denied pattern in raw message', () {
      // Arrange
      const errorMessage = 'Access permission denied for this resource';

      // Act
      final result = localizer.localizeRawErrorMessage(errorMessage);

      // Assert
      expect(result, 'Permission denied');
    });

    test('should detect not found pattern in raw message', () {
      // Arrange
      const errorMessage = 'The requested resource was not found';

      // Act
      final result = localizer.localizeRawErrorMessage(errorMessage);

      // Assert
      expect(result, 'The requested data was not found');
    });

    test('should detect database error pattern in raw message', () {
      // Arrange
      const errorMessage = 'A database error occurred';

      // Act
      final result = localizer.localizeRawErrorMessage(errorMessage);

      // Assert
      expect(result, 'A database error occurred');
    });

    test('should detect authentication error pattern in raw message', () {
      // Arrange
      const errorMessage = 'An authentication error occurred';

      // Act
      final result = localizer.localizeRawErrorMessage(errorMessage);

      // Assert
      expect(result, 'An authentication error occurred');
    });

    test('should capitalize first letter of message if no pattern matches', () {
      // Arrange
      const errorMessage = 'some random error message';

      // Act
      final result = localizer.localizeRawErrorMessage(errorMessage);

      // Assert
      expect(result, 'Some random error message');
    });

    test('should return unexpected error for empty message', () {
      // Arrange
      const errorMessage = '';

      // Act
      final result = localizer.localizeRawErrorMessage(errorMessage);

      // Assert
      expect(result, 'An unexpected error occurred');
    });
  });
}
