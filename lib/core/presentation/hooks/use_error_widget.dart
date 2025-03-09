import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/app_localization.dart';

/// A hook that returns a widget builder for displaying error messages
/// with a consistent UI across the application.
///
/// The [onRetry] callback is optional and will display a retry button when
/// provided.
Widget useErrorWidget({
  required BuildContext context,
  required String errorMessage,
  VoidCallback? onRetry,
}) {
  // Default error styling
  const iconData = Icons.error_outline;
  const iconColor = Colors.red;

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(
        iconData,
        size: 60,
        color: iconColor,
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      if (onRetry != null) ...[
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: onRetry,
          child: Text(AppLocalization.of(context).retryButton),
        ),
      ],
    ],
  );
}
