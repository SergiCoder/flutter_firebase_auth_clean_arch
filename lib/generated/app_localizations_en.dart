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
  String get changeLanguage => 'Change language';

  @override
  String get loginTitle => 'Login';

  @override
  String get registerTitle => 'Register';

  @override
  String get homeTitle => 'Home';

  @override
  String welcome(String email) {
    return 'Welcome, $email!';
  }

  @override
  String get logoutButton => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get loginButton => 'Login';

  @override
  String get registerButton => 'Register';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get invalidEmail => 'Please enter a valid email address';

  @override
  String get emptyEmail => 'Please enter your email address';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get passwordsDontMatch => 'Passwords don\'t match';

  @override
  String get errorPageTitle => 'Page Not Found';

  @override
  String get pageNotFoundMessage => 'The page you\'re looking for doesn\'t exist';

  @override
  String get goBack => 'Go Back';

  @override
  String get invalidCredentials => 'Invalid email or password';

  @override
  String get emailAlreadyInUse => 'This email is already in use';

  @override
  String get weakPassword => 'The password provided is too weak';

  @override
  String get operationNotAllowed => 'This operation is not allowed';

  @override
  String get requiresRecentLogin => 'Please log in again to continue';

  @override
  String get authenticationError => 'An authentication error occurred';

  @override
  String get permissionDenied => 'Permission denied';

  @override
  String get notFound => 'The requested data was not found';

  @override
  String get databaseError => 'A database error occurred';

  @override
  String get unexpectedError => 'An unexpected error occurred';
}
