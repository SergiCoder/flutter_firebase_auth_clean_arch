import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/generated/app_localizations.dart';

/// A provider class that manages the app's locale state
class LocaleProvider extends ChangeNotifier {
  /// The current locale of the app
  Locale _locale = const Locale('en');

  /// Returns the current locale
  Locale get locale => _locale;

  /// Sets the locale to the given locale
  void setLocale(Locale locale) {
    if (!AppLocalizations.supportedLocales.contains(locale)) {
      return;
    }

    if (_locale != locale) {
      _locale = locale;
      notifyListeners();
    }
  }

  /// Sets the locale to English
  void setEnglishLocale() {
    setLocale(const Locale('en'));
  }

  /// Sets the locale to Spanish
  void setSpanishLocale() {
    setLocale(const Locale('es'));
  }

  /// Sets the locale based on the device locale
  void setLocaleFromDeviceLocale(Locale deviceLocale) {
    // Check if the device locale is supported
    final supportedLocale = AppLocalizations.supportedLocales.firstWhere(
      (locale) => locale.languageCode == deviceLocale.languageCode,
      orElse: () => const Locale('en'), // Default to English if not supported
    );

    setLocale(supportedLocale);
  }
}
