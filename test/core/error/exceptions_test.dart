import 'package:flutter_firebase_auth_clean_arch/core/error/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppException', () {
    // Since AppException is abstract, we'll test it through a concrete subclass
    test('should have correct properties when accessed through a subclass', () {
      // Arrange & Act
      const exception = UnexpectedException(
        message: 'Test message',
      );

      // Assert
      expect(exception.message, equals('Test message'));
      expect(exception.code, equals('unexpected_error'));
      expect(exception.originalError, isNull);
    });

    test('should include originalError in properties when provided', () {
      // Arrange
      final originalError = Exception('Original error');

      // Act
      final exception = UnexpectedException(
        message: 'Test message',
        originalError: originalError,
      );

      // Assert
      expect(exception.message, equals('Test message'));
      expect(exception.code, equals('unexpected_error'));
      expect(exception.originalError, equals(originalError));
    });
  });

  group('AuthException', () {
    test('should have correct properties and inherit from AppException', () {
      // Arrange & Act
      const exception = AuthException(
        'Auth error',
        code: 'auth_error',
      );

      // Assert
      expect(exception, isA<AppException>());
      expect(exception.message, equals('Auth error'));
      expect(exception.code, equals('auth_error'));
    });
  });

  group('InvalidCredentialsException', () {
    test('should have correct properties and inherit from AuthException', () {
      // Arrange & Act
      const exception = InvalidCredentialsException(
        message: 'Invalid credentials',
      );

      // Assert
      expect(exception, isA<AuthException>());
      expect(exception.message, equals('Invalid credentials'));
      expect(exception.code, equals('invalid_credentials'));
    });

    test('should use default message when not provided', () {
      // Arrange & Act
      const exception = InvalidCredentialsException();

      // Assert
      expect(exception.message, equals('Invalid email or password'));
      expect(exception.code, equals('invalid_credentials'));
    });
  });

  group('EmailAlreadyInUseException', () {
    test('should have correct properties and inherit from AuthException', () {
      // Arrange & Act
      const exception = EmailAlreadyInUseException(
        message: 'Email already in use',
      );

      // Assert
      expect(exception, isA<AuthException>());
      expect(exception.message, equals('Email already in use'));
      expect(exception.code, equals('email_already_in_use'));
    });

    test('should use default message when not provided', () {
      // Arrange & Act
      const exception = EmailAlreadyInUseException();

      // Assert
      expect(exception.message, equals('This email is already in use'));
      expect(exception.code, equals('email_already_in_use'));
    });
  });

  group('WeakPasswordException', () {
    test('should have correct properties and inherit from AuthException', () {
      // Arrange & Act
      const exception = WeakPasswordException(
        message: 'Password is too weak',
      );

      // Assert
      expect(exception, isA<AuthException>());
      expect(exception.message, equals('Password is too weak'));
      expect(exception.code, equals('weak_password'));
    });

    test('should use default message when not provided', () {
      // Arrange & Act
      const exception = WeakPasswordException();

      // Assert
      expect(exception.message, equals('The password provided is too weak'));
      expect(exception.code, equals('weak_password'));
    });
  });

  group('UserNotAuthenticatedException', () {
    test('should have correct properties and inherit from AuthException', () {
      // Arrange & Act
      const exception = UserNotAuthenticatedException(
        message: 'User is not logged in',
      );

      // Assert
      expect(exception, isA<AuthException>());
      expect(exception.message, equals('User is not logged in'));
      expect(exception.code, equals('user_not_authenticated'));
    });

    test('should use default message when not provided', () {
      // Arrange & Act
      const exception = UserNotAuthenticatedException();

      // Assert
      expect(exception.message, equals('User is not authenticated'));
      expect(exception.code, equals('user_not_authenticated'));
    });
  });

  group('DataException', () {
    test('should have correct properties and inherit from AppException', () {
      // Arrange & Act
      const exception = DataException(
        'Data error',
        code: 'data_error',
      );

      // Assert
      expect(exception, isA<AppException>());
      expect(exception.message, equals('Data error'));
      expect(exception.code, equals('data_error'));
    });
  });

  group('PermissionDeniedException', () {
    test('should have correct properties and inherit from DataException', () {
      // Arrange & Act
      const exception = PermissionDeniedException(
        message: 'Custom permission denied message',
      );

      // Assert
      expect(exception, isA<DataException>());
      expect(exception.message, equals('Custom permission denied message'));
      expect(exception.code, equals('permission_denied'));
    });

    test('should use default message when not provided', () {
      // Arrange & Act
      const exception = PermissionDeniedException();

      // Assert
      expect(exception.message, equals('Permission denied'));
      expect(exception.code, equals('permission_denied'));
    });
  });

  group('NotFoundException', () {
    test('should have correct properties and inherit from DataException', () {
      // Arrange & Act
      const exception = NotFoundException(
        message: 'Resource not found',
      );

      // Assert
      expect(exception, isA<DataException>());
      expect(exception.message, equals('Resource not found'));
      expect(exception.code, equals('not_found'));
    });

    test('should use default message when not provided', () {
      // Arrange & Act
      const exception = NotFoundException();

      // Assert
      expect(exception.message, equals('The requested data was not found'));
      expect(exception.code, equals('not_found'));
    });
  });

  group('NetworkException', () {
    test('should have correct properties and inherit from AppException', () {
      // Arrange & Act
      const exception = NetworkException(
        'Network error',
        code: 'network_error',
      );

      // Assert
      expect(exception, isA<AppException>());
      expect(exception.message, equals('Network error'));
      expect(exception.code, equals('network_error'));
    });
  });

  group('NoInternetException', () {
    test('should have correct properties and inherit from NetworkException',
        () {
      // Arrange & Act
      const exception = NoInternetException(
        message: 'No internet connection available',
      );

      // Assert
      expect(exception, isA<NetworkException>());
      expect(exception.message, equals('No internet connection available'));
      expect(exception.code, equals('no_internet'));
    });

    test('should use default message when not provided', () {
      // Arrange & Act
      const exception = NoInternetException();

      // Assert
      expect(exception.message, equals('No internet connection'));
      expect(exception.code, equals('no_internet'));
    });
  });

  group('TimeoutException', () {
    test('should have correct properties and inherit from NetworkException',
        () {
      // Arrange & Act
      const exception = TimeoutException(
        message: 'Operation timed out',
      );

      // Assert
      expect(exception, isA<NetworkException>());
      expect(exception.message, equals('Operation timed out'));
      expect(exception.code, equals('timeout'));
    });

    test('should use default message when not provided', () {
      // Arrange & Act
      const exception = TimeoutException();

      // Assert
      expect(exception.message, equals('The operation timed out'));
      expect(exception.code, equals('timeout'));
    });
  });

  group('UnexpectedException', () {
    test('should have correct properties and inherit from AppException', () {
      // Arrange & Act
      const exception = UnexpectedException(
        message: 'Unexpected error',
      );

      // Assert
      expect(exception, isA<AppException>());
      expect(exception.message, equals('Unexpected error'));
      expect(exception.code, equals('unexpected_error'));
    });

    test('should use default message when not provided', () {
      // Arrange & Act
      const exception = UnexpectedException();

      // Assert
      expect(exception.message, equals('An unexpected error occurred'));
      expect(exception.code, equals('unexpected_error'));
    });
  });
}
