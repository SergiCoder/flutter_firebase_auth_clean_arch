import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/features/error/presentation/utils/error_message_localizer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider for the error message localizer
///
/// This provider requires a [BuildContext] to be passed when used.
/// Example usage:
/// ```dart
/// final localizer = ref.watch(errorMessageLocalizerProvider(context));
/// final localizedMessage = localizer.localizeErrorMessage(exception);
/// ```
final errorMessageLocalizerProvider =
    Provider.family<ErrorMessageLocalizer, BuildContext>(
  (ref, context) => ErrorMessageLocalizer(context),
);
