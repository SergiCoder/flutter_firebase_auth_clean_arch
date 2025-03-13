import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/generated/app_localizations.dart';

/// Provides localized error messages for the application.
///
/// This class acts as a bridge between the error handler and the localization
/// system, ensuring that all error messages are properly localized.
class LocalizedErrorMessages {
  /// Creates a new [LocalizedErrorMessages] instance.
  ///
  /// The [context] is used to access the app's localizations.
  const LocalizedErrorMessages(this.context);

  /// The build context used to access localizations.
  final BuildContext context;

  /// Gets the app localizations from the context.
  AppLocalizations get _localizations => AppLocalizations.of(context);

  /// Returns a localized message for invalid credentials.
  String get invalidCredentials => _localizations.invalidCredentials;

  /// Returns a localized message for email already in use.
  String get emailAlreadyInUse => _localizations.emailAlreadyInUse;

  /// Returns a localized message for weak password.
  String get weakPassword => _localizations.weakPassword;

  /// Returns a localized message for operation not allowed.
  String get operationNotAllowed => _localizations.operationNotAllowed;

  /// Returns a localized message for requiring recent login.
  String get requiresRecentLogin => _localizations.requiresRecentLogin;

  /// Returns a localized message for generic authentication error.
  String get authenticationError => _localizations.authenticationError;

  /// Returns a localized message for permission denied.
  String get permissionDenied => _localizations.permissionDenied;

  /// Returns a localized message for not found.
  String get notFound => _localizations.notFound;

  /// Returns a localized message for database error.
  String get databaseError => _localizations.databaseError;

  /// Returns a localized message for unexpected error.
  String get unexpectedError => _localizations.unexpectedError;
}
