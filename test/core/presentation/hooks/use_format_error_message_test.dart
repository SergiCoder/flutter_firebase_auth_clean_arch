import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/presentation/hooks/use_format_error_message.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('useFormatErrorMessage', () {
    testWidgets('removes Firebase error prefix', (WidgetTester tester) async {
      const errorMessage = '[firebase_auth/invalid-email] Invalid email format';
      var formattedMessage = '';

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              formattedMessage = useFormatErrorMessage(errorMessage);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(formattedMessage, equals('Invalid email format'));
    });

    testWidgets('removes Exception prefix', (WidgetTester tester) async {
      const errorMessage = 'Exception: something went wrong';
      var formattedMessage = '';

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              formattedMessage = useFormatErrorMessage(errorMessage);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(formattedMessage, equals('Something went wrong'));
    });

    testWidgets('capitalizes first letter if lowercase',
        (WidgetTester tester) async {
      const errorMessage = 'error occurred during processing';
      var formattedMessage = '';

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              formattedMessage = useFormatErrorMessage(errorMessage);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(formattedMessage, equals('Error occurred during processing'));
    });

    testWidgets('keeps message unchanged if already properly formatted',
        (WidgetTester tester) async {
      const errorMessage = 'Network connection failed';
      var formattedMessage = '';

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              formattedMessage = useFormatErrorMessage(errorMessage);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(formattedMessage, equals('Network connection failed'));
    });

    testWidgets('handles complex error message with multiple patterns',
        (WidgetTester tester) async {
      const errorMessage =
          '[firebase_auth/user-not-found] Exception: user not found';
      var formattedMessage = '';

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              formattedMessage = useFormatErrorMessage(errorMessage);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(formattedMessage, equals('User not found'));
    });
  });
}
