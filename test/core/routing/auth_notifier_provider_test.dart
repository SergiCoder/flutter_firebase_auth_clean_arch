import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/auth_notifier_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_auth_router_notifier.dart';

void main() {
  group('AuthNotifierProvider', () {
    late MockAuthRouterNotifier mockAuthNotifier;

    setUp(() {
      mockAuthNotifier = MockAuthRouterNotifier();
    });

    testWidgets('should provide AuthRouterNotifier to descendants',
        (tester) async {
      // Arrange
      var notifierFound = false;

      // Create a test widget that tries to access the notifier
      await tester.pumpWidget(
        MaterialApp(
          home: AuthNotifierProvider(
            notifier: mockAuthNotifier,
            child: Builder(
              builder: (context) {
                // Try to access the notifier
                final notifier = AuthNotifierProvider.of(context);
                notifierFound = notifier == mockAuthNotifier;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      // Assert
      expect(notifierFound, isTrue);
    });

    testWidgets('should throw exception when provider not found',
        (tester) async {
      // Arrange - Create a widget without the provider
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // This will be called during the build
              return const SizedBox();
            },
          ),
        ),
      );

      // Act & Assert - Verify that accessing the notifier throws an exception
      expect(
        () => AuthNotifierProvider.of(tester.element(find.byType(SizedBox))),
        throwsException,
      );
    });

    testWidgets('should update when notifier changes', (tester) async {
      // Arrange
      var buildCount = 0;

      // Create a test widget that rebuilds when the notifier changes
      await tester.pumpWidget(
        MaterialApp(
          home: AuthNotifierProvider(
            notifier: mockAuthNotifier,
            child: Builder(
              builder: (context) {
                // Access the notifier to establish dependency
                AuthNotifierProvider.of(context);
                buildCount++;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      // Initial build
      expect(buildCount, 1);

      // Act - Change the notifier state
      mockAuthNotifier.isAuthenticated = !mockAuthNotifier.isAuthenticated;
      await tester.pump();

      // Assert - Verify that the builder was called again
      expect(buildCount, 2);
    });
  });
}
