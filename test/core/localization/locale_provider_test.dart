import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/locale_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocaleProvider', () {
    late LocaleProvider localeProvider;

    setUp(() {
      localeProvider = LocaleProvider();
    });

    test('initial locale is English', () {
      expect(localeProvider.locale.languageCode, equals('en'));
    });

    test('setLocale updates locale when valid', () {
      const spanishLocale = Locale('es');

      localeProvider.setLocale(spanishLocale);

      expect(localeProvider.locale, equals(spanishLocale));
    });

    test('setLocale does not update locale when invalid', () {
      const initialLocale = Locale('en');
      const unsupportedLocale =
          Locale('fr'); // Assuming French is not supported

      expect(localeProvider.locale, equals(initialLocale));

      localeProvider.setLocale(unsupportedLocale);

      // Locale should remain unchanged
      expect(localeProvider.locale, equals(initialLocale));
    });

    test('setEnglishLocale sets locale to English', () {
      // First set to a different locale
      localeProvider.setLocale(const Locale('es'));
      expect(localeProvider.locale.languageCode, equals('es'));

      // Then set to English
      localeProvider.setEnglishLocale();
      expect(localeProvider.locale.languageCode, equals('en'));
    });

    test('setSpanishLocale sets locale to Spanish', () {
      // Ensure we start with English
      localeProvider.setLocale(const Locale('en'));
      expect(localeProvider.locale.languageCode, equals('en'));

      // Then set to Spanish
      localeProvider.setSpanishLocale();
      expect(localeProvider.locale.languageCode, equals('es'));
    });

    test('setLocaleFromDeviceLocale sets to supported device locale', () {
      const deviceLocale = Locale('es'); // Supported locale

      localeProvider.setLocaleFromDeviceLocale(deviceLocale);

      expect(localeProvider.locale, equals(deviceLocale));
    });

    test('setLocaleFromDeviceLocale defaults to English for unsupported locale',
        () {
      const deviceLocale = Locale('fr'); // Unsupported locale
      const defaultLocale = Locale('en');

      localeProvider.setLocaleFromDeviceLocale(deviceLocale);

      expect(localeProvider.locale, equals(defaultLocale));
    });

    test('notifies listeners when locale changes', () {
      int notificationCount = 0;

      localeProvider.addListener(() {
        notificationCount++;
      });

      // Change locale
      localeProvider.setLocale(const Locale('es'));
      expect(notificationCount, equals(1));

      // Change to same locale should not notify
      localeProvider.setLocale(const Locale('es'));
      expect(notificationCount, equals(1));

      // Change to different locale should notify
      localeProvider.setLocale(const Locale('en'));
      expect(notificationCount, equals(2));
    });
  });
}
