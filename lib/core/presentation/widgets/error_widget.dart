import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/app_localization.dart';
import 'package:flutter_firebase_auth_clean_arch/core/presentation/hooks/use_format_error_message.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A widget for displaying error messages with a consistent UI.
///
/// The [onRetry] callback is optional and will display a retry button when
/// provided.
class ErrorDisplayWidget extends HookWidget {
  /// Creates a new [ErrorDisplayWidget].
  const ErrorDisplayWidget({
    required this.errorMessage,
    this.onRetry,
    super.key,
  });

  /// The error message to display.
  final String errorMessage;

  /// Optional callback to retry the operation that caused the error.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    // Format the error message to be more user-friendly
    final formattedMessage = useFormatErrorMessage(errorMessage);

    // Default error styling
    const iconData = Icons.error_outline;
    const iconColor = Colors.red;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(flex: 2),
        const Icon(
          iconData,
          size: 60,
          color: iconColor,
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            formattedMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (onRetry != null) ...[
          const Spacer(),
          Center(
            child: ElevatedButton(
              onPressed: onRetry,
              child: Text(AppLocalization.of(context).retryButton),
            ),
          ),
        ],
        const Spacer(flex: 3),
      ],
    );
  }
}
