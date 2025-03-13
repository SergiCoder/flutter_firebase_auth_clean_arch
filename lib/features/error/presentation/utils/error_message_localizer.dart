import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/error/exceptions.dart';
import 'package:flutter_firebase_auth_clean_arch/generated/app_localizations.dart';

/// Utility class for localizing error messages in the presentation layer
class ErrorMessageLocalizer {
  /// Creates a new [ErrorMessageLocalizer] with the given build context
  const ErrorMessageLocalizer(this.context);

  /// The build context used to access localizations
  final BuildContext context;

  /// Gets the app localizations from the context
  AppLocalizations get _localizations => AppLocalizations.of(context);

  /// Localizes an error message from an [AppException]
  String localizeErrorMessage(AppException exception) {
    try {
      // Handle specific exception types
      if (exception is InvalidCredentialsException) {
        return _localizations.invalidCredentials;
      } else if (exception is EmailAlreadyInUseException) {
        return _localizations.emailAlreadyInUse;
      } else if (exception is WeakPasswordException) {
        return _localizations.weakPassword;
      } else if (exception is PermissionDeniedException) {
        return _localizations.permissionDenied;
      } else if (exception is NotFoundException) {
        return _localizations.notFound;
      } else if (exception is DataException) {
        return _localizations.databaseError;
      } else if (exception is AuthException) {
        // Handle specific auth error codes
        switch (exception.code) {
          case 'operation_not_allowed':
            return _localizations.operationNotAllowed;
          case 'requires_recent_login':
            return _localizations.requiresRecentLogin;
          default:
            return _localizations.authenticationError;
        }
      } else if (exception is UnexpectedException) {
        return _localizations.unexpectedError;
      }

      // If no specific match, try to extract meaning from the message
      final message = exception.message;

      // Check for common error message patterns
      if (message.contains('email') && message.contains('already in use')) {
        return _localizations.emailAlreadyInUse;
      } else if (message.contains('password') &&
          (message.contains('weak') || message.contains('too short'))) {
        return _localizations.weakPassword;
      } else if (message.contains('invalid') &&
          (message.contains('email') || message.contains('password'))) {
        return _localizations.invalidCredentials;
      } else if (message.contains('permission') && message.contains('denied')) {
        return _localizations.permissionDenied;
      } else if (message.contains('not found')) {
        return _localizations.notFound;
      } else if (message.contains('database') || message.contains('data')) {
        return _localizations.databaseError;
      } else if (message.contains('authentication') ||
          message.contains('auth')) {
        return _localizations.authenticationError;
      }

      // If all else fails, return the original message
      return message;
    } catch (e) {
      // If any error occurs during processing, return the original message
      developer.log(
        'Error localizing message: $e',
        name: 'ErrorMessageLocalizer',
        error: e,
      );
      return exception.message;
    }
  }

  /// Localizes a raw error message string
  String localizeRawErrorMessage(String errorMessage) {
    try {
      // Remove common error prefixes like "[firebase_auth/xxx]"
      final prefixPattern = RegExp(r'^\[([\w-]+)\/([\w-]+)\]\s*');
      final prefixMatch = prefixPattern.firstMatch(errorMessage);

      var cleanedMessage = errorMessage;
      String? errorCode;

      if (prefixMatch != null) {
        // Extract the error code (e.g., "invalid-email")
        errorCode = prefixMatch.group(2);
        cleanedMessage = errorMessage.replaceFirst(prefixPattern, '');
      }

      // Remove "Exception:" prefix if present
      cleanedMessage =
          cleanedMessage.replaceFirst(RegExp(r'^Exception:\s*'), '');

      // Try to match the error code with a localized message
      if (errorCode != null) {
        switch (errorCode) {
          case 'invalid-email':
          case 'user-not-found':
          case 'wrong-password':
          case 'user-disabled':
            return _localizations.invalidCredentials;
          case 'email-already-in-use':
            return _localizations.emailAlreadyInUse;
          case 'weak-password':
            return _localizations.weakPassword;
          case 'operation-not-allowed':
            return _localizations.operationNotAllowed;
          case 'requires-recent-login':
            return _localizations.requiresRecentLogin;
          case 'permission-denied':
            return _localizations.permissionDenied;
          case 'not-found':
            return _localizations.notFound;
        }
      }

      // Check for common error message patterns
      if (cleanedMessage.contains('email') &&
          cleanedMessage.contains('already in use')) {
        return _localizations.emailAlreadyInUse;
      } else if (cleanedMessage.contains('password') &&
          (cleanedMessage.contains('weak') ||
              cleanedMessage.contains('too short'))) {
        return _localizations.weakPassword;
      } else if (cleanedMessage.contains('invalid') &&
          (cleanedMessage.contains('email') ||
              cleanedMessage.contains('password'))) {
        return _localizations.invalidCredentials;
      } else if (cleanedMessage.contains('permission') &&
          cleanedMessage.contains('denied')) {
        return _localizations.permissionDenied;
      } else if (cleanedMessage.contains('not found')) {
        return _localizations.notFound;
      } else if (cleanedMessage.contains('database') ||
          cleanedMessage.contains('data')) {
        return _localizations.databaseError;
      } else if (cleanedMessage.contains('authentication') ||
          cleanedMessage.contains('auth')) {
        return _localizations.authenticationError;
      }

      // If no specific match, return the cleaned message with first letter
      // capitalized
      if (cleanedMessage.isNotEmpty &&
          cleanedMessage[0].toLowerCase() == cleanedMessage[0]) {
        return '${cleanedMessage[0].toUpperCase()}'
            '${cleanedMessage.substring(1)}';
      }

      // If all else fails, return a generic error message
      return _localizations.unexpectedError;
    } catch (e) {
      // If any error occurs during processing, return the original message
      developer.log(
        'Error processing error message: $e',
        name: 'ErrorMessageLocalizer',
        error: e,
      );
      return errorMessage;
    }
  }
}
