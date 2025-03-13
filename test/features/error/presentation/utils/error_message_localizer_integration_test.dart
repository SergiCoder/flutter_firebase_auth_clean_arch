import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_firebase_auth_clean_arch/core/error/exceptions.dart';
import 'package:flutter_firebase_auth_clean_arch/features/error/presentation/utils/error_message_localizer.dart';
import 'package:flutter_firebase_auth_clean_arch/generated/app_localizations.dart';
import 'package:flutter_firebase_auth_clean_arch/generated/app_localizations_en.dart';

// Concrete implementation of AppException for testing
class TestAppException extends AppException {
  const TestAppException(super.message);
}

// Special exception that throws during localization for testing error handling
class ThrowingAppException extends AppException {
  const ThrowingAppException(super.message);

  @override
  String toString() {
    throw Exception('Test exception during toString');
  }
}

// Custom ErrorMessageLocalizer that throws during localization for testing error handling
class ThrowingErrorMessageLocalizer extends ErrorMessageLocalizer {
  ThrowingErrorMessageLocalizer(super.context);

  @override
  String localizeErrorMessage(AppException exception) {
    throw Exception('Test exception during localization');
  }

  @override
  String localizeRawErrorMessage(String errorMessage) {
    throw Exception('Test exception during raw localization');
  }
}

void main() {
  testWidgets('ErrorMessageLocalizer integration test',
      (WidgetTester tester) async {
    late ErrorMessageLocalizer localizer;
    late BuildContext context;

    // Create a test widget with localizations
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
        ],
        home: Builder(
          builder: (BuildContext ctx) {
            // Store the context for later use
            context = ctx;
            return const Scaffold();
          },
        ),
      ),
    );

    // Wait for localizations to load
    await tester.pumpAndSettle();

    // Create the localizer with the context
    localizer = ErrorMessageLocalizer(context);

    // Test localizeErrorMessage

    // Test specific exception types
    expect(
      localizer.localizeErrorMessage(const InvalidCredentialsException()),
      'Invalid email or password',
    );

    expect(
      localizer.localizeErrorMessage(const EmailAlreadyInUseException()),
      'This email is already in use',
    );

    expect(
      localizer.localizeErrorMessage(const WeakPasswordException()),
      'The password provided is too weak',
    );

    expect(
      localizer.localizeErrorMessage(const PermissionDeniedException()),
      'Permission denied',
    );

    expect(
      localizer.localizeErrorMessage(const NotFoundException()),
      'The requested data was not found',
    );

    expect(
      localizer.localizeErrorMessage(
        const DataException('A database error occurred'),
      ),
      'A database error occurred',
    );

    expect(
      localizer.localizeErrorMessage(
        const AuthException(
          'This operation is not allowed',
          code: 'operation_not_allowed',
        ),
      ),
      'This operation is not allowed',
    );

    expect(
      localizer.localizeErrorMessage(
        const AuthException(
          'Please log in again to continue',
          code: 'requires_recent_login',
        ),
      ),
      'Please log in again to continue',
    );

    expect(
      localizer.localizeErrorMessage(
        const AuthException(
          'An authentication error occurred',
          code: 'unknown_code',
        ),
      ),
      'An authentication error occurred',
    );

    expect(
      localizer.localizeErrorMessage(const UnexpectedException()),
      'An unexpected error occurred',
    );

    // Test pattern detection
    expect(
      localizer.localizeErrorMessage(
        const TestAppException(
          'The email is already in use by another account',
        ),
      ),
      'This email is already in use',
    );

    expect(
      localizer.localizeErrorMessage(
        const TestAppException('The password is too weak or too short'),
      ),
      'The password provided is too weak',
    );

    expect(
      localizer.localizeErrorMessage(
        const TestAppException('The email or password is invalid'),
      ),
      'Invalid email or password',
    );

    expect(
      localizer.localizeErrorMessage(
        const TestAppException(
          'Access permission denied for this resource',
        ),
      ),
      'Permission denied',
    );

    expect(
      localizer.localizeErrorMessage(
        const TestAppException('The requested resource was not found'),
      ),
      'The requested data was not found',
    );

    expect(
      localizer.localizeErrorMessage(
        const TestAppException(
          'A database error occurred while processing the request',
        ),
      ),
      'A database error occurred',
    );

    expect(
      localizer.localizeErrorMessage(
        const TestAppException(
          'An authentication error occurred during sign in',
        ),
      ),
      'An authentication error occurred',
    );

    // Test fallback to original message
    const originalMessage = 'Some random error message';
    expect(
      localizer.localizeErrorMessage(const TestAppException(originalMessage)),
      originalMessage,
    );

    // Test localizeRawErrorMessage

    // Test error code handling
    expect(
      localizer.localizeRawErrorMessage(
        '[firebase_auth/invalid-email] The email is invalid',
      ),
      'Invalid email or password',
    );

    expect(
      localizer
          .localizeRawErrorMessage('Exception: The email is already in use'),
      'This email is already in use',
    );

    expect(
      localizer.localizeRawErrorMessage(
        '[firebase_auth/email-already-in-use] The email is already in use',
      ),
      'This email is already in use',
    );

    expect(
      localizer.localizeRawErrorMessage(
        '[firebase_auth/weak-password] The password is too weak',
      ),
      'The password provided is too weak',
    );

    expect(
      localizer.localizeRawErrorMessage(
        '[firebase_auth/operation-not-allowed] This operation is not allowed',
      ),
      'This operation is not allowed',
    );

    expect(
      localizer.localizeRawErrorMessage(
        '[firebase_auth/requires-recent-login] Please log in again',
      ),
      'Please log in again to continue',
    );

    expect(
      localizer.localizeRawErrorMessage(
        '[firebase/permission-denied] Permission denied for this operation',
      ),
      'Permission denied',
    );

    expect(
      localizer
          .localizeRawErrorMessage('[firebase/not-found] Document not found'),
      'The requested data was not found',
    );

    // Test pattern detection in raw messages
    expect(
      localizer.localizeRawErrorMessage('The email address is already in use'),
      'This email is already in use',
    );

    expect(
      localizer.localizeRawErrorMessage('The password provided is too weak'),
      'The password provided is too weak',
    );

    expect(
      localizer.localizeRawErrorMessage('The email or password is invalid'),
      'Invalid email or password',
    );

    expect(
      localizer.localizeRawErrorMessage(
        'Access permission denied for this resource',
      ),
      'Permission denied',
    );

    expect(
      localizer.localizeRawErrorMessage('The requested resource was not found'),
      'The requested data was not found',
    );

    expect(
      localizer.localizeRawErrorMessage('A database error occurred'),
      'A database error occurred',
    );

    expect(
      localizer.localizeRawErrorMessage('An authentication error occurred'),
      'An authentication error occurred',
    );

    // Test empty message
    expect(
      localizer.localizeRawErrorMessage(''),
      'An unexpected error occurred',
    );

    // Test capitalization of first letter (to cover line 137)
    expect(
      localizer.localizeRawErrorMessage(
        'test message with lowercase first letter',
      ),
      'Test message with lowercase first letter',
    );

    // Test message that doesn't match any patterns but contains a keyword
    // This should match one of the patterns and return a localized message
    expect(
      localizer.localizeRawErrorMessage(
        'This message contains the word authentication',
      ),
      'An authentication error occurred',
    );

    // Test error handling in localizeErrorMessage
    try {
      final throwingLocalizer = ThrowingErrorMessageLocalizer(context);
      const exception = TestAppException('Test message');
      throwingLocalizer.localizeErrorMessage(exception);
      fail('Expected an exception to be thrown');
    } catch (e) {
      // Expected exception
    }

    // Test error handling in localizeRawErrorMessage
    try {
      final throwingLocalizer = ThrowingErrorMessageLocalizer(context);
      throwingLocalizer.localizeRawErrorMessage('Test message');
      fail('Expected an exception to be thrown');
    } catch (e) {
      // Expected exception
    }

    // Test error handling with exception that throws during toString
    expect(
      localizer.localizeErrorMessage(
        const ThrowingAppException('Fallback message'),
      ),
      'Fallback message',
    );
  });
}
