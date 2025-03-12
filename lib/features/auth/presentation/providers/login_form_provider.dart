import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Enum representing the different fields in the login form
enum LoginFormField {
  /// Email field
  email,

  /// Password field
  password,

  /// No field (when form is submitted)
  none
}

/// Provider to manage the login form state
class LoginFormNotifier extends StateNotifier<LoginFormField> {
  /// Creates a new [LoginFormNotifier]
  LoginFormNotifier() : super(LoginFormField.email);

  /// Focus the email field
  void focusEmail() {
    state = LoginFormField.email;
  }

  /// Focus the password field
  void focusPassword() {
    state = LoginFormField.password;
  }

  /// Submit the form
  void submitForm() {
    state = LoginFormField.none;
  }
}

/// Provider for the login form state
final loginFormProvider =
    StateNotifierProvider<LoginFormNotifier, LoginFormField>(
  (ref) => LoginFormNotifier(),
);
