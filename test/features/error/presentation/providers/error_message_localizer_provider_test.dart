import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_firebase_auth_clean_arch/features/error/presentation/providers/error_message_localizer_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/features/error/presentation/utils/error_message_localizer.dart';
import 'package:flutter_firebase_auth_clean_arch/core/error/exceptions.dart';
import 'package:flutter_firebase_auth_clean_arch/generated/app_localizations.dart';

void main() {
  group('ErrorMessageLocalizerProvider', () {
    late ProviderContainer container;
    late BuildContext context;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('provides an ErrorMessageLocalizer instance',
        (WidgetTester tester) async {
      // Build a widget with localizations to get a valid context
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

      // Get the provider with the context
      final localizer = container.read(errorMessageLocalizerProvider(context));

      // Verify that the provider returns an instance of ErrorMessageLocalizer
      expect(localizer, isA<ErrorMessageLocalizer>());
    });

    testWidgets('localizer can localize error messages',
        (WidgetTester tester) async {
      // Build a widget with localizations to get a valid context
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

      // Get the provider with the context
      final localizer = container.read(errorMessageLocalizerProvider(context));

      // Test that the localizer can localize an exception
      final result =
          localizer.localizeErrorMessage(const InvalidCredentialsException());

      // Verify the result
      expect(result, isA<String>());
      expect(result.isNotEmpty, true);
    });

    testWidgets('provider can be overridden for testing',
        (WidgetTester tester) async {
      // Create a mock provider
      final mockProvider = Provider.family<ErrorMessageLocalizer, BuildContext>(
        (ref, context) => MockErrorMessageLocalizer(),
      );

      // Create a provider container with the override
      final containerWithOverride = ProviderContainer(
        overrides: [
          errorMessageLocalizerProvider.overrideWithProvider(mockProvider.call),
        ],
      );

      // Build a widget with localizations to get a valid context
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

      // Get the provider with the context
      final localizer =
          containerWithOverride.read(errorMessageLocalizerProvider(context));

      // Verify that the provider returns the mock instance
      expect(localizer, isA<MockErrorMessageLocalizer>());
      expect(
        localizer.localizeErrorMessage(const InvalidCredentialsException()),
        'Mock localized message',
      );

      // Clean up
      containerWithOverride.dispose();
    });

    testWidgets('provider creates a new instance for each context',
        (WidgetTester tester) async {
      late BuildContext context1;
      late BuildContext context2;

      // Build a widget with two different contexts
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
          ],
          home: Column(
            children: [
              Builder(
                builder: (BuildContext ctx) {
                  context1 = ctx;
                  return const SizedBox();
                },
              ),
              Builder(
                builder: (BuildContext ctx) {
                  context2 = ctx;
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      );

      // Wait for localizations to load
      await tester.pumpAndSettle();

      // Get the provider with different contexts
      final localizer1 =
          container.read(errorMessageLocalizerProvider(context1));
      final localizer2 =
          container.read(errorMessageLocalizerProvider(context2));

      // Verify that they are different instances
      expect(localizer1, isNot(same(localizer2)));

      // But they should both be ErrorMessageLocalizer instances
      expect(localizer1, isA<ErrorMessageLocalizer>());
      expect(localizer2, isA<ErrorMessageLocalizer>());
    });
  });
}

/// A mock implementation of ErrorMessageLocalizer for testing
class MockErrorMessageLocalizer extends ErrorMessageLocalizer {
  MockErrorMessageLocalizer() : super(FakeContext());

  @override
  String localizeErrorMessage(AppException exception) {
    return 'Mock localized message';
  }

  @override
  String localizeRawErrorMessage(String errorMessage) {
    return 'Mock localized raw message';
  }
}

/// A fake BuildContext for testing
class FakeContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
