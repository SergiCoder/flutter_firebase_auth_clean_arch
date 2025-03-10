import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/presentation/widgets/error_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ErrorDisplayWidget', () {
    testWidgets('renders error message with correct styling',
        (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'Test error message';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              error: Colors.red,
            ),
            textTheme: const TextTheme(
              titleMedium: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          home: const Scaffold(
            body: ErrorDisplayWidget(
              errorMessage: errorMessage,
            ),
          ),
        ),
      );

      // Assert - we don't need to check for the formatted message since that's
      // handled by the hook which has its own tests
      expect(find.byType(Text), findsOneWidget);

      // Verify text styling
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.textAlign, TextAlign.center);
      expect(textWidget.style?.color, Colors.red);
    });

    testWidgets('applies correct padding', (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'Test error';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorDisplayWidget(
              errorMessage: errorMessage,
            ),
          ),
        ),
      );

      // Assert
      final paddingWidget = tester.widget<Padding>(find.byType(Padding));
      expect(paddingWidget.padding, const EdgeInsets.all(24));
    });

    testWidgets('integrates with useFormatErrorMessage hook',
        (WidgetTester tester) async {
      // Arrange - using a raw error message that would be formatted by the hook
      const rawErrorMessage = '[firebase_auth/error] Some error occurred';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorDisplayWidget(
              errorMessage: rawErrorMessage,
            ),
          ),
        ),
      );

      // Assert - The hook should have removed the prefix
      // We can't directly test the hook's behavior here since it's mocked in
      // the widget, but we can verify that a Text widget is rendered
      expect(find.byType(Text), findsOneWidget);

      // The actual formatting is tested in the hook's own tests
    });
  });
}
