import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/theme/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme Widget Tests', () {
    testWidgets('ElevatedButton should have correct theme properties',
        (WidgetTester tester) async {
      // Build a MaterialApp with our theme and an ElevatedButton
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Test Button'),
              ),
            ),
          ),
        ),
      );

      // Find the ElevatedButton
      final buttonFinder = find.byType(ElevatedButton);
      expect(buttonFinder, findsOneWidget);

      // In Material 3, we need to check the theme data instead of direct
      // properties
      final BuildContext context = tester.element(buttonFinder);
      final theme = Theme.of(context);

      // Verify the button style from the theme
      final buttonStyle = theme.elevatedButtonTheme.style;
      final backgroundColor = buttonStyle?.backgroundColor?.resolve({});
      expect(backgroundColor, const Color(0xFF009688));

      final foregroundColor = buttonStyle?.foregroundColor?.resolve({});
      expect(foregroundColor, Colors.white);
    });

    testWidgets('TextButton should have correct theme properties',
        (WidgetTester tester) async {
      // Build a MaterialApp with our theme and a TextButton
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () {},
                child: const Text('Test Button'),
              ),
            ),
          ),
        ),
      );

      // Find the TextButton
      final buttonFinder = find.byType(TextButton);
      expect(buttonFinder, findsOneWidget);

      // In Material 3, we need to check the theme data instead of direct
      // properties
      final BuildContext context = tester.element(buttonFinder);
      final theme = Theme.of(context);

      // Verify the button style from the theme
      final buttonStyle = theme.textButtonTheme.style;
      final foregroundColor = buttonStyle?.foregroundColor?.resolve({});
      expect(foregroundColor, const Color(0xFF009688));
    });

    testWidgets('TextField should have correct theme properties',
        (WidgetTester tester) async {
      // Build a MaterialApp with our theme and a TextField
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Test TextField',
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Find the TextField
      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      // In Material 3, we need to check the theme data instead of direct
      // properties
      final BuildContext context = tester.element(textFieldFinder);
      final theme = Theme.of(context);

      // Verify the input decoration theme
      final inputTheme = theme.inputDecorationTheme;
      expect(inputTheme.filled, true);
      expect(inputTheme.fillColor, Colors.white);

      // Verify border
      expect(
        inputTheme.border,
        isA<OutlineInputBorder>().having(
          (border) => border.borderRadius,
          'borderRadius',
          BorderRadius.circular(8),
        ),
      );
    });

    testWidgets('AppBar should have correct theme properties',
        (WidgetTester tester) async {
      // Build a MaterialApp with our theme and an AppBar
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Test AppBar'),
            ),
            body: const Center(
              child: Text('Test Content'),
            ),
          ),
        ),
      );

      // Find the AppBar
      final appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);

      // In Material 3, we need to check the theme data instead of direct
      // properties
      final BuildContext context = tester.element(appBarFinder);
      final theme = Theme.of(context);

      // Verify the AppBar theme
      final appBarTheme = theme.appBarTheme;
      expect(appBarTheme.backgroundColor, const Color(0xFF009688));
      expect(appBarTheme.foregroundColor, Colors.white);
      expect(appBarTheme.elevation, 0);
      expect(appBarTheme.centerTitle, true);
    });

    testWidgets('Card should have correct theme properties',
        (WidgetTester tester) async {
      // Build a MaterialApp with our theme and a Card
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const Scaffold(
            body: Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Test Card'),
                ),
              ),
            ),
          ),
        ),
      );

      // Find the Card
      final cardFinder = find.byType(Card);
      expect(cardFinder, findsOneWidget);

      // In Material 3, we need to check the theme data instead of direct
      // properties
      final BuildContext context = tester.element(cardFinder);
      final theme = Theme.of(context);

      // Verify the Card theme
      final cardTheme = theme.cardTheme;
      expect(cardTheme.elevation, 2);
      expect(
        cardTheme.shape,
        isA<RoundedRectangleBorder>().having(
          (shape) => shape.borderRadius,
          'borderRadius',
          BorderRadius.circular(8),
        ),
      );
    });

    testWidgets('Scaffold should have correct background color',
        (WidgetTester tester) async {
      // Build a MaterialApp with our theme and a Scaffold
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const Scaffold(
            body: Center(
              child: Text('Test Scaffold'),
            ),
          ),
        ),
      );

      // Find the Scaffold
      final scaffoldFinder = find.byType(Scaffold);
      expect(scaffoldFinder, findsOneWidget);

      // In Material 3, we need to check the theme data instead of direct
      // properties
      final BuildContext context = tester.element(scaffoldFinder);
      final theme = Theme.of(context);

      // Verify the Scaffold background color
      expect(theme.scaffoldBackgroundColor, const Color(0xFFF5F5F5));
    });
  });
}
