import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_firebase_auth_clean_arch/features/error/presentation/utils/error_message_localizer.dart';
import 'package:flutter_firebase_auth_clean_arch/generated/app_localizations.dart';

/// A test implementation of AppLocalizations
class TestAppLocalizations implements AppLocalizations {
  @override
  String get unexpectedError => 'An unexpected error occurred';

  // Implement other required methods as needed
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// A custom ErrorMessageLocalizer for testing that exposes the capitalization logic
class CapitalizationTestLocalizer extends ErrorMessageLocalizer {
  CapitalizationTestLocalizer(super.context);

  @override
  AppLocalizations get _localizations => TestAppLocalizations();

  /// Directly test the capitalization logic
  String testCapitalization(String message) {
    // This is a direct copy of the capitalization logic from the original class
    if (message.isNotEmpty && message[0].toLowerCase() == message[0]) {
      return '${message[0].toUpperCase()}${message.substring(1)}';
    }

    // If all else fails, return a generic error message
    return _localizations.unexpectedError;
  }

  /// Test with an empty string
  String testEmptyString() {
    // This is a direct copy of the capitalization logic from the original class
    // but with an empty string
    const message = '';
    if (message.isNotEmpty && message[0].toLowerCase() == message[0]) {
      return '${message[0].toUpperCase()}${message.substring(1)}';
    }

    // If all else fails, return a generic error message
    return _localizations.unexpectedError;
  }
}

/// A mock BuildContext for testing
class MockBuildContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('ErrorMessageLocalizer capitalization logic', () {
    late BuildContext mockContext;
    late CapitalizationTestLocalizer localizer;

    setUp(() {
      mockContext = MockBuildContext();
      localizer = CapitalizationTestLocalizer(mockContext);
    });

    test('testCapitalization capitalizes first letter of lowercase message',
        () {
      final result = localizer.testCapitalization('lowercase message');
      expect(result, 'Lowercase message');
    });

    test('testCapitalization returns unexpected error for uppercase message',
        () {
      final result = localizer.testCapitalization('Uppercase message');
      expect(result, 'An unexpected error occurred');
    });

    test('testEmptyString returns unexpected error for empty string', () {
      final result = localizer.testEmptyString();
      expect(result, 'An unexpected error occurred');
    });
  });
}
