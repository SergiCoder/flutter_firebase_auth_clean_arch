import 'package:flutter_hooks/flutter_hooks.dart';

/// A hook that formats an error message to be more user-friendly.
///
/// This hook removes common error prefixes like "[firebase_auth/xxx]" and
/// formats the message to be more readable.
///
/// Example:
/// ```dart
/// final formattedMessage = useFormatErrorMessage(errorMessage);
/// ```
String useFormatErrorMessage(String errorMessage) {
  return useMemoized(
    () {
      // Remove common error prefixes like "[firebase_auth/xxx]"
      final prefixPattern = RegExp(r'^\[[\w-]+\/[\w-]+\]\s*');
      final cleanedMessage = errorMessage.replaceFirst(prefixPattern, '');

      // Capitalize the first letter if it doesn't start with a capital letter
      if (cleanedMessage.isNotEmpty &&
          cleanedMessage[0].toLowerCase() == cleanedMessage[0]) {
        return '${cleanedMessage[0].toUpperCase()}'
            '${cleanedMessage.substring(1)}';
      }

      return cleanedMessage;
    },
    [errorMessage],
  );
}
