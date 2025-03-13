import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/features/error/presentation/presentation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A widget for displaying error messages with a consistent UI.
class ErrorDisplayWidget extends ConsumerWidget {
  /// Creates a new [ErrorDisplayWidget].
  const ErrorDisplayWidget({
    required this.errorMessage,
    super.key,
  });

  /// The error message to display.
  final String errorMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the error message localizer from the provider
    final localizer = ref.watch(errorMessageLocalizerProvider(context));
    // Get the localized error message
    final localizedMessage = localizer.localizeRawErrorMessage(errorMessage);

    return Padding(
      padding: const EdgeInsets.all(24),
      // Use IgnorePointer to ensure this widget doesn't capture any input
      // events
      child: IgnorePointer(
        child: Text(
          localizedMessage,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
        ),
      ),
    );
  }
}
