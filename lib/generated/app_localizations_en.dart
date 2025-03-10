// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Authentication App';

  @override
  String get loginTitle => 'Login';

  @override
  String get registerTitle => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get loginButton => 'Login';

  @override
  String get registerButton => 'Register';

  @override
  String get logoutButton => 'Logout';

  @override
  String get retryButton => 'Retry';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get resetPasswordInstructions =>
      'Enter your email and we\'ll send you instructions to reset your password.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get resetLinkSent => 'Password reset link sent to your email';

  @override
  String get emptyEmail => 'The email address is empty';

  @override
  String get invalidEmail => 'Please enter a valid email address';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get passwordsDontMatch => 'Passwords don\'t match';

  @override
  String get loginFailed => 'Login failed. Please check your credentials.';

  @override
  String get registrationFailed => 'Registration failed. Please try again.';

  @override
  String get resetPasswordFailed =>
      'Failed to send reset link. Please try again.';

  @override
  String welcomeMessage(String email) {
    return 'Welcome, $email!';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get homeTitle => 'Home';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get or => 'OR';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get errorPageTitle => 'Page Not Found';

  @override
  String get pageNotFoundMessage =>
      'The page you\'re looking for doesn\'t exist';

  @override
  String get goBack => 'Go Back';
}
