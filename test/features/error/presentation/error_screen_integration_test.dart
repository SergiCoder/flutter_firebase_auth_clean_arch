import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/app_localization.dart';
import 'package:flutter_firebase_auth_clean_arch/features/error/presentation/screens/error_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('ErrorScreen Integration Tests', () {
    late GoRouter router;

    setUp(() {
      // Create a real GoRouter for integration testing
      router = GoRouter(
        initialLocation: '/error',
        routes: [
          GoRoute(
            path: '/error',
            builder: (context, state) =>
                const ErrorScreen(uri: '/invalid/route'),
          ),
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Home Screen')),
            ),
          ),
        ],
      );
    });

    testWidgets('integrates with real GoRouter for navigation',
        (WidgetTester tester) async {
      // Act - Build the app with the router
      await tester.pumpWidget(
        MaterialApp.router(
          localizationsDelegates: AppLocalization.localizationDelegates,
          supportedLocales: AppLocalization.supportedLocales,
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      // Verify we're on the error screen
      expect(find.text('Page Not Found'), findsOneWidget);
      expect(find.textContaining('/invalid/route'), findsOneWidget);

      // Find and tap the back button
      final backButton = find.byType(ElevatedButton);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify that we navigated to the home screen
      expect(find.text('Home Screen'), findsOneWidget);
    });

    testWidgets('handles different URIs in integration context',
        (WidgetTester tester) async {
      // Arrange
      const testUri = '/another/invalid/path?param=value';

      // Create a router with a different URI
      final customRouter = GoRouter(
        initialLocation: '/error',
        routes: [
          GoRoute(
            path: '/error',
            builder: (context, state) => const ErrorScreen(uri: testUri),
          ),
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Home Screen')),
            ),
          ),
        ],
      );

      // Act - Build the app with the custom router
      await tester.pumpWidget(
        MaterialApp.router(
          localizationsDelegates: AppLocalization.localizationDelegates,
          supportedLocales: AppLocalization.supportedLocales,
          routerConfig: customRouter,
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      // Verify the error message contains the complex URI
      expect(find.textContaining(testUri), findsOneWidget);

      // Navigate back and verify it works with the complex URI
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text('Home Screen'), findsOneWidget);
    });
  });
}
