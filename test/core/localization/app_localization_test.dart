import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/app_localization.dart';
import 'package:flutter_firebase_auth_clean_arch/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLocalization', () {
    testWidgets('supportedLocales returns correct locales', (tester) async {
      final supportedLocales = AppLocalization.supportedLocales;

      // Verify that the supported locales include at least English and Spanish
      expect(
        supportedLocales.any((locale) => locale.languageCode == 'en'),
        isTrue,
      );
      expect(
        supportedLocales.any((locale) => locale.languageCode == 'es'),
        isTrue,
      );
    });

    testWidgets('localizationDelegates returns correct delegates',
        (tester) async {
      final delegates = AppLocalization.localizationDelegates;

      // Verify that the delegates include the AppLocalizations delegate
      expect(
        delegates.contains(AppLocalizations.delegate),
        isTrue,
      );

      // Verify that the delegates include the GlobalMaterialLocalizations
      // delegates
      expect(
        delegates.contains(GlobalMaterialLocalizations.delegate),
        isTrue,
      );
      expect(
        delegates.contains(GlobalWidgetsLocalizations.delegate),
        isTrue,
      );
      expect(
        delegates.contains(GlobalCupertinoLocalizations.delegate),
        isTrue,
      );
    });

    test('getLocaleName returns correct name for English', () {
      final localeName = AppLocalization.getLocaleName(const Locale('en'));
      expect(localeName, equals('English'));
    });

    test('getLocaleName returns correct name for Spanish', () {
      final localeName = AppLocalization.getLocaleName(const Locale('es'));
      expect(localeName, equals('Español'));
    });

    test('getLocaleName returns language code for unsupported locale', () {
      final localeName = AppLocalization.getLocaleName(const Locale('fr'));
      expect(localeName, equals('fr'));
    });

    testWidgets('of returns AppLocalizations instance', (tester) async {
      late AppLocalizations appLocalizations;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalization.localizationDelegates,
          supportedLocales: AppLocalization.supportedLocales,
          home: Builder(
            builder: (context) {
              appLocalizations = AppLocalization.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(appLocalizations, isA<AppLocalizations>());
    });
  });
}
