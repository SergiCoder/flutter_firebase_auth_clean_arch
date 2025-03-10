import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/theme/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme Constants', () {
    test('animationDuration should be 300 milliseconds', () {
      expect(AppTheme.animationDuration, const Duration(milliseconds: 300));
    });

    test('theme should use Material 3', () {
      final theme = AppTheme.theme;
      expect(theme.useMaterial3, true);
    });

    test('theme should have consistent border radius across components', () {
      final theme = AppTheme.theme;

      // Get border radius from different components
      final cardBorderRadius =
          (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius;

      final buttonBorderRadius = (theme.elevatedButtonTheme.style?.shape
              ?.resolve({}) as RoundedRectangleBorder?)
          ?.borderRadius;

      final inputBorderRadius =
          (theme.inputDecorationTheme.border as OutlineInputBorder)
              .borderRadius;

      // Verify they are all the same
      expect(cardBorderRadius, BorderRadius.circular(8));
      expect(buttonBorderRadius, BorderRadius.circular(8));
      expect(inputBorderRadius, BorderRadius.circular(8));
    });

    test('theme should have consistent primary color across components', () {
      final theme = AppTheme.theme;
      final primaryColor = theme.colorScheme.primary;

      // Check primary color is used consistently
      final appBarColor = theme.appBarTheme.backgroundColor;
      final buttonColor =
          theme.elevatedButtonTheme.style?.backgroundColor?.resolve({});
      final focusedBorderColor =
          (theme.inputDecorationTheme.focusedBorder as OutlineInputBorder)
              .borderSide
              .color;
      final textButtonColor =
          theme.textButtonTheme.style?.foregroundColor?.resolve({});

      expect(primaryColor, const Color(0xFF009688));
      expect(appBarColor, primaryColor);
      expect(buttonColor, primaryColor);
      expect(focusedBorderColor, primaryColor);
      expect(textButtonColor, primaryColor);
    });

    test('theme should have consistent padding in components', () {
      final theme = AppTheme.theme;

      final buttonPadding =
          theme.elevatedButtonTheme.style?.padding?.resolve({});
      final inputPadding = theme.inputDecorationTheme.contentPadding;

      expect(
        buttonPadding,
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );
      expect(
        inputPadding,
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      );
    });
  });
}
