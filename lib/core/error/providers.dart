import 'package:flutter_firebase_auth_clean_arch/core/error/error_handler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider for the error handler
final errorHandlerProvider = Provider<ErrorHandler>(
  (ref) => const ErrorHandler(),
);
