import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// A service class that provides localization functionality for the app
class AppLocalization {
  /// Returns the localization instance for the given context
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context);
  }

  /// Returns a list of all supported locales
  static List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  /// Returns a list of all localization delegates required for the app
  static List<LocalizationsDelegate<dynamic>> get localizationDelegates => [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ];

  /// Returns the locale name for the given locale
  static String getLocaleName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      default:
        return locale.languageCode;
    }
  }
}
