import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/error/exceptions.dart';
import 'package:flutter_firebase_auth_clean_arch/features/error/presentation/utils/error_message_localizer.dart';
import 'package:flutter_firebase_auth_clean_arch/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock exception that throws during toString
class ThrowingException extends AppException {
  const ThrowingException() : super('Test message');

  @override
  String toString() => throw Exception('Error in toString');
}

void main() {
  group('ErrorMessageLocalizer error handling', () {
    late ErrorMessageLocalizer localizer;
    late BuildContext context;

    setUp(() {
      // We'll set the context in the testWidgets callback
    });

    testWidgets('localizeErrorMessage handles exceptions in exception.toString',
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
      localizer = ErrorMessageLocalizer(context);

      // Create a custom exception that throws during toString
      const exception = ThrowingException();

      // The method should catch the exception and return a fallback
      final result = localizer.localizeErrorMessage(exception);

      // Verify the result is the fallback message
      expect(result, 'Test message');
    });

    testWidgets('localizeRawErrorMessage handles exceptions during processing',
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
      localizer = ErrorMessageLocalizer(context);

      // Create a custom ErrorMessageLocalizer that throws during processing
      final throwingLocalizer = ErrorMessageLocalizer(context);

      // Force an error in the method by passing an invalid message
      try {
        // This should throw an exception internally but catch it
        final result = throwingLocalizer.localizeRawErrorMessage('');

        // The method should return a generic error message
        expect(result, 'An unexpected error occurred');
      } catch (e) {
        fail('Exception should be caught by the localizer: $e');
      }
    });
  });
}
