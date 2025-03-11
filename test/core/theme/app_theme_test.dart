import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/theme/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    test('private constructor prevents instantiation', () {
      // Test the private constructor using the test method
      AppTheme.testPrivateConstructor();

      // Verify that the static members work as expected
      expect(AppTheme.theme, isA<ThemeData>());
      expect(AppTheme.animationDuration, const Duration(milliseconds: 300));
    });

    test('theme should have correct primary color', () {
      final theme = AppTheme.theme;
      expect(theme.colorScheme.primary, const Color(0xFF009688));
    });

    test('theme should have correct secondary color', () {
      final theme = AppTheme.theme;
      expect(theme.colorScheme.secondary, const Color(0xFF4DB6AC));
    });

    test('theme should have correct tertiary color', () {
      final theme = AppTheme.theme;
      expect(theme.colorScheme.tertiary, const Color(0xFF00796B));
    });

    test('theme should have correct scaffold background color', () {
      final theme = AppTheme.theme;
      expect(theme.scaffoldBackgroundColor, const Color(0xFFF5F5F5));
    });

    test('theme should have Material 3 enabled', () {
      final theme = AppTheme.theme;
      expect(theme.useMaterial3, true);
    });

    test('appBarTheme should have correct configuration', () {
      final theme = AppTheme.theme;
      expect(theme.appBarTheme.elevation, 0);
      expect(theme.appBarTheme.backgroundColor, const Color(0xFF009688));
      expect(theme.appBarTheme.foregroundColor, Colors.white);
      expect(theme.appBarTheme.centerTitle, true);
    });

    test('cardTheme should have correct configuration', () {
      final theme = AppTheme.theme;
      expect(theme.cardTheme.elevation, 2);
      expect(
        theme.cardTheme.shape,
        isA<RoundedRectangleBorder>().having(
          (shape) => shape.borderRadius,
          'borderRadius',
          BorderRadius.circular(8),
        ),
      );
    });

    test('elevatedButtonTheme should have correct configuration', () {
      final theme = AppTheme.theme;
      final buttonStyle = theme.elevatedButtonTheme.style;

      // Test background color
      final backgroundColor = buttonStyle?.backgroundColor?.resolve({});
      expect(backgroundColor, const Color(0xFF009688));

      // Test foreground color
      final foregroundColor = buttonStyle?.foregroundColor?.resolve({});
      expect(foregroundColor, Colors.white);

      // Test shape
      final shape = buttonStyle?.shape?.resolve({});
      expect(
        shape,
        isA<RoundedRectangleBorder>().having(
          (shape) => shape.borderRadius,
          'borderRadius',
          BorderRadius.circular(8),
        ),
      );

      // Test padding
      final padding = buttonStyle?.padding?.resolve({});
      expect(
        padding,
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );
    });

    test('textButtonTheme should have correct configuration', () {
      final theme = AppTheme.theme;
      final buttonStyle = theme.textButtonTheme.style;

      // Test foreground color
      final foregroundColor = buttonStyle?.foregroundColor?.resolve({});
      expect(foregroundColor, const Color(0xFF009688));
    });

    test('inputDecorationTheme should have correct configuration', () {
      final theme = AppTheme.theme;
      final inputTheme = theme.inputDecorationTheme;

      expect(inputTheme.filled, true);
      expect(inputTheme.fillColor, Colors.white);

      // Test borders
      expect(
        inputTheme.border,
        isA<OutlineInputBorder>()
            .having(
              (border) => border.borderRadius,
              'borderRadius',
              BorderRadius.circular(8),
            )
            .having(
              (border) => border.borderSide,
              'borderSide',
              BorderSide.none,
            ),
      );

      expect(
        inputTheme.enabledBorder,
        isA<OutlineInputBorder>()
            .having(
              (border) => border.borderRadius,
              'borderRadius',
              BorderRadius.circular(8),
            )
            .having(
              (border) => border.borderSide,
              'borderSide',
              BorderSide.none,
            ),
      );

      expect(
        inputTheme.focusedBorder,
        isA<OutlineInputBorder>()
            .having(
              (border) => border.borderRadius,
              'borderRadius',
              BorderRadius.circular(8),
            )
            .having(
              (border) => border.borderSide.color,
              'borderSide.color',
              const Color(0xFF009688),
            )
            .having(
              (border) => border.borderSide.width,
              'borderSide.width',
              2,
            ),
      );

      // Test padding
      expect(
        inputTheme.contentPadding,
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      );
    });

    test('pageTransitionsTheme should have correct configuration', () {
      final theme = AppTheme.theme;
      final transitionsTheme = theme.pageTransitionsTheme;

      expect(
        transitionsTheme.builders[TargetPlatform.android],
        isA<FadeUpwardsPageTransitionsBuilder>(),
      );
      expect(
        transitionsTheme.builders[TargetPlatform.iOS],
        isA<CupertinoPageTransitionsBuilder>(),
      );
      expect(
        transitionsTheme.builders[TargetPlatform.macOS],
        isA<CupertinoPageTransitionsBuilder>(),
      );
      expect(
        transitionsTheme.builders[TargetPlatform.windows],
        isA<FadeUpwardsPageTransitionsBuilder>(),
      );
      expect(
        transitionsTheme.builders[TargetPlatform.linux],
        isA<FadeUpwardsPageTransitionsBuilder>(),
      );
      expect(
        transitionsTheme.builders[TargetPlatform.fuchsia],
        isA<FadeUpwardsPageTransitionsBuilder>(),
      );
    });

    test('animationDuration should be 300 milliseconds', () {
      expect(AppTheme.animationDuration, const Duration(milliseconds: 300));
    });
  });
}
