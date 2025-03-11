import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/app_localization.dart';
import 'package:flutter_firebase_auth_clean_arch/core/presentation/widgets/error_widget.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/app_route.dart';
import 'package:flutter_firebase_auth_clean_arch/features/error/presentation/error_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../core/routing/mock_go_router.dart';
import '../../../core/routing/mock_go_router_provider.dart';

void main() {
  late MockGoRouter mockRouter;

  setUp(() {
    mockRouter = MockGoRouter();
  });

  /// Helper function to build the ErrorScreen within a MaterialApp
  Widget buildTestableErrorScreen({
    required String uri,
    required MockGoRouter router,
  }) {
    return MaterialApp(
      // Add localization support
      localizationsDelegates: AppLocalization.localizationDelegates,
      supportedLocales: AppLocalization.supportedLocales,
      home: MockGoRouterProvider(
        router: router,
        child: ErrorScreen(
          uri: uri,
        ),
      ),
    );
  }

  group('ErrorScreen', () {
    testWidgets('renders correctly with the provided URI',
        (WidgetTester tester) async {
      // Arrange
      const testUri = '/invalid/route';

      // Act
      await tester.pumpWidget(
        buildTestableErrorScreen(
          uri: testUri,
          router: mockRouter,
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      // Verify the screen title is displayed
      expect(find.text('Page Not Found'), findsOneWidget);

      // Verify the error message contains the URI
      expect(find.textContaining(testUri), findsOneWidget);

      // Verify the ErrorDisplayWidget is present
      expect(find.byType(ErrorDisplayWidget), findsOneWidget);

      // Verify the back button is present
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Go Back'), findsOneWidget);
    });

    testWidgets('navigates to home route when back button is pressed',
        (WidgetTester tester) async {
      // Arrange
      const testUri = '/invalid/route';

      // Act
      await tester.pumpWidget(
        buildTestableErrorScreen(
          uri: testUri,
          router: mockRouter,
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap the back button
      final backButton = find.byType(ElevatedButton);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Assert
      // Verify that the navigation callback was called with the home route
      expect(mockRouter.location, equals(AppRoute.home.path));
    });

    testWidgets('displays different URIs correctly',
        (WidgetTester tester) async {
      // Arrange
      const testUri = '/another/invalid/path?param=value';

      // Act
      await tester.pumpWidget(
        buildTestableErrorScreen(
          uri: testUri,
          router: mockRouter,
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      // Verify the error message contains the complex URI
      expect(find.textContaining(testUri), findsOneWidget);
    });

    testWidgets('has correct layout with centered content',
        (WidgetTester tester) async {
      // Arrange
      const testUri = '/test';

      // Act
      await tester.pumpWidget(
        buildTestableErrorScreen(
          uri: testUri,
          router: mockRouter,
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      // Verify the Column widget has the correct alignment
      final columnFinder = find.byType(Column);
      expect(columnFinder, findsOneWidget);

      final column = tester.widget(columnFinder) as Column;
      expect(column.mainAxisAlignment, MainAxisAlignment.spaceEvenly);

      // Verify the content is centered
      expect(find.byType(Center), findsOneWidget);
    });
  });
}
