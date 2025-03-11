import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/app_route.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_go_router.dart';
import 'mock_go_router_provider.dart';

void main() {
  group('MockGoRouter in widget tests', () {
    testWidgets('should navigate when button is pressed', (tester) async {
      // Arrange
      final mockRouter = MockGoRouter();

      // Create a simple test widget with a button that navigates
      await tester.pumpWidget(
        MaterialApp(
          home: MockGoRouterProvider(
            router: mockRouter,
            child: Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => mockRouter.go(AppRoute.home.path),
                  child: const Text('Go to Home'),
                ),
              ),
            ),
          ),
        ),
      );

      // Act - tap the button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert - verify navigation occurred by checking the location
      expect(mockRouter.location, equals(AppRoute.home.path));
    });

    testWidgets('should push route when button is pressed', (tester) async {
      // Arrange
      final mockRouter = MockGoRouter();

      // Create a simple test widget with a button that navigates
      await tester.pumpWidget(
        MaterialApp(
          home: MockGoRouterProvider(
            router: mockRouter,
            child: Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => mockRouter.push(AppRoute.login.path),
                  child: const Text('Push Login'),
                ),
              ),
            ),
          ),
        ),
      );

      // Act - tap the button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert - verify navigation occurred by checking the location
      expect(mockRouter.location, equals(AppRoute.login.path));
    });
  });
}
