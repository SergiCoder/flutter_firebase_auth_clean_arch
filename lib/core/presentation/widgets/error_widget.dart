import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/presentation/hooks/use_format_error_message.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A widget for displaying error messages with a consistent UI.
class ErrorDisplayWidget extends HookWidget {
  /// Creates a new [ErrorDisplayWidget].
  const ErrorDisplayWidget({
    required this.errorMessage,
    super.key,
  });

  /// The error message to display.
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    // Format the error message to be more user-friendly
    final formattedMessage = useFormatErrorMessage(errorMessage);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        formattedMessage,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
      ),
    );
  }
}
