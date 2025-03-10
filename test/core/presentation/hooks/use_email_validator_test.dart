import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/presentation/hooks/use_email_validator.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('useEmailValidator', () {
    testWidgets('returns required field message when value is null',
        (WidgetTester tester) async {
      const requiredMessage = 'Email is required';
      const invalidMessage = 'Invalid email format';

      String? validatorResult;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              final validator = useEmailValidator(
                requiredFieldMessage: requiredMessage,
                invalidEmailMessage: invalidMessage,
              );

              // Call the validator with null
              validatorResult = validator(null);

              return const SizedBox();
            },
          ),
        ),
      );

      expect(validatorResult, equals(requiredMessage));
    });

    testWidgets('returns required field message when value is empty',
        (WidgetTester tester) async {
      const requiredMessage = 'Email is required';
      const invalidMessage = 'Invalid email format';

      String? validatorResult;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              final validator = useEmailValidator(
                requiredFieldMessage: requiredMessage,
                invalidEmailMessage: invalidMessage,
              );

              // Call the validator with empty string
              validatorResult = validator('');

              return const SizedBox();
            },
          ),
        ),
      );

      expect(validatorResult, equals(requiredMessage));
    });

    testWidgets('returns invalid email message for invalid email format',
        (WidgetTester tester) async {
      const requiredMessage = 'Email is required';
      const invalidMessage = 'Invalid email format';

      String? validatorResult;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              final validator = useEmailValidator(
                requiredFieldMessage: requiredMessage,
                invalidEmailMessage: invalidMessage,
              );

              // Call the validator with invalid email
              validatorResult = validator('invalid-email');

              return const SizedBox();
            },
          ),
        ),
      );

      expect(validatorResult, equals(invalidMessage));
    });

    testWidgets('returns null for valid email format',
        (WidgetTester tester) async {
      const requiredMessage = 'Email is required';
      const invalidMessage = 'Invalid email format';

      String? validatorResult;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              final validator = useEmailValidator(
                requiredFieldMessage: requiredMessage,
                invalidEmailMessage: invalidMessage,
              );

              // Call the validator with valid email
              validatorResult = validator('test@example.com');

              return const SizedBox();
            },
          ),
        ),
      );

      expect(validatorResult, isNull);
    });
  });
}
