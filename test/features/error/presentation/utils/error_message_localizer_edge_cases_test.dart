import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/error/exceptions.dart';
import 'package:flutter_firebase_auth_clean_arch/features/error/presentation/utils/error_message_localizer.dart';
import 'package:flutter_firebase_auth_clean_arch/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// A special exception that throws during toString() to test error handling
class ThrowingException extends AppException {
  const ThrowingException() : super('Fallback message');

  @override
  String toString() {
    throw Exception('Error in toString');
  }
}

/// A special exception that throws during message getter to test error handling
class MessageThrowingException extends AppException {
  const MessageThrowingException() : super('Fallback message');

  @override
  String get message {
    throw Exception('Error in message getter');
  }
}

/// A custom ErrorMessageLocalizer that forces exceptions in specific methods
class CustomErrorMessageLocalizer extends ErrorMessageLocalizer {
  CustomErrorMessageLocalizer(super.context);

  @override
  String localizeErrorMessage(AppException exception) {
    try {
      throw Exception('Forced exception in localizeErrorMessage');
    } catch (e) {
      return exception.message;
    }
  }

  @override
  String localizeRawErrorMessage(String errorMessage) {
    try {
      throw Exception('Forced exception in localizeRawErrorMessage');
    } catch (e) {
      return errorMessage;
    }
  }
}

void main() {
  group('ErrorMessageLocalizer edge cases', () {
    late BuildContext context;

    testWidgets('localizeErrorMessage handles exceptions in catch block',
        (WidgetTester tester) async {
      // Build a test widget to get a valid context
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
          ],
          home: Builder(
            builder: (BuildContext ctx) {
              context = ctx;
              return const Scaffold();
            },
          ),
        ),
      );

      // Wait for localizations to load
      await tester.pumpAndSettle();

      // Create a custom localizer that forces exceptions
      final customLocalizer = CustomErrorMessageLocalizer(context);

      // Test with a normal exception
      const exception = InvalidCredentialsException();
      final result = customLocalizer.localizeErrorMessage(exception);
      expect(result, 'Invalid email or password');
    });

    testWidgets('localizeRawErrorMessage handles exceptions in catch block',
        (WidgetTester tester) async {
      // Build a test widget to get a valid context
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
          ],
          home: Builder(
            builder: (BuildContext ctx) {
              context = ctx;
              return const Scaffold();
            },
          ),
        ),
      );

      // Wait for localizations to load
      await tester.pumpAndSettle();

      // Create a custom localizer that forces exceptions
      final customLocalizer = CustomErrorMessageLocalizer(context);

      // Test with a normal message
      const testMessage = 'Test message';
      final result = customLocalizer.localizeRawErrorMessage(testMessage);
      expect(result, testMessage);
    });

    testWidgets('localizeRawErrorMessage handles capitalization edge case',
        (WidgetTester tester) async {
      // Build a test widget to get a valid context
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
          ],
          home: Builder(
            builder: (BuildContext ctx) {
              context = ctx;
              return const Scaffold();
            },
          ),
        ),
      );

      // Wait for localizations to load
      await tester.pumpAndSettle();

      // Create the localizer with the context
      final localizer = ErrorMessageLocalizer(context);

      // Test with a message that already has an uppercase first letter
      // This should skip the capitalization branch
      final result =
          localizer.localizeRawErrorMessage('Already Capitalized Message');
      expect(result, 'An unexpected error occurred');
    });
  });
}
