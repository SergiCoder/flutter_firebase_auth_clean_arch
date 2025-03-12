import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Enum representing the different fields in the register form
enum RegisterFormField {
  /// Email field
  email,

  /// Password field
  password,

  /// Confirm password field
  confirmPassword,

  /// No field (when form is submitted)
  none
}

/// Provider to manage the register form state
class RegisterFormNotifier extends StateNotifier<RegisterFormField> {
  /// Creates a new [RegisterFormNotifier]
  RegisterFormNotifier() : super(RegisterFormField.email);

  /// Focus the email field
  void focusEmail() {
    state = RegisterFormField.email;
  }

  /// Focus the password field
  void focusPassword() {
    state = RegisterFormField.password;
  }

  /// Focus the confirm password field
  void focusConfirmPassword() {
    state = RegisterFormField.confirmPassword;
  }

  /// Submit the form
  void submitForm() {
    state = RegisterFormField.none;
  }
}

/// Provider for the register form state
final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormField>(
  (ref) => RegisterFormNotifier(),
);
