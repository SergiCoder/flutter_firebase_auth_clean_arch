import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/error/exceptions.dart';
import 'package:flutter_firebase_auth_clean_arch/features/error/presentation/providers/error_message_localizer_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/features/error/presentation/utils/error_message_localizer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A mock implementation of [ErrorMessageLocalizer] for testing
class MockErrorMessageLocalizer extends ErrorMessageLocalizer {
  /// Creates a new [MockErrorMessageLocalizer]
  MockErrorMessageLocalizer(super.context);

  @override
  String localizeErrorMessage(AppException exception) {
    // Return the original message for simplicity in tests
    return exception.message;
  }

  @override
  String localizeRawErrorMessage(String errorMessage) {
    // Return the original message for simplicity in tests
    return errorMessage;
  }
}

/// Provider for the mock error message localizer
final mockErrorMessageLocalizerProvider =
    Provider.family<ErrorMessageLocalizer, BuildContext>(
  (ref, context) => MockErrorMessageLocalizer(context),
);

/// Override the real provider with the mock for testing
final errorMessageLocalizerProviderOverride =
    errorMessageLocalizerProvider.overrideWithProvider(
  mockErrorMessageLocalizerProvider,
);
