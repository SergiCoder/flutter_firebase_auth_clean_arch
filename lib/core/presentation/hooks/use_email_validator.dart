import 'package:flutter_hooks/flutter_hooks.dart';

/// A hook that returns a validator function for email fields.
///
/// This hook creates a memoized validator function that checks if an email
/// is valid according to a standard regex pattern. It uses provided error
/// messages for better user experience.
///
/// Example:
/// ```dart
/// final emailValidator = useEmailValidator(
///   requiredFieldMessage: 'Please enter your email',
///   invalidEmailMessage: 'Please enter a valid email address',
/// );
/// TextFormField(
///   validator: emailValidator,
///   // ...
/// )
/// ```
///
/// @param requiredFieldMessage Message for required field error
/// @param invalidEmailMessage Message for invalid email format error
/// @return A validator function that returns an error message or null
String? Function(String?) useEmailValidator({
  required String requiredFieldMessage,
  required String invalidEmailMessage,
}) {
  return useMemoized(
    () {
      return (String? value) {
        if (value == null || value.isEmpty) {
          return requiredFieldMessage;
        }
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return invalidEmailMessage;
        }
        return null;
      };
    },
    [requiredFieldMessage, invalidEmailMessage],
  );
}
