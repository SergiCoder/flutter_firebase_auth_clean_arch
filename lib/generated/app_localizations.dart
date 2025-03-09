import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Authentication App'**
  String get appTitle;

  /// Title for the login screen
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// Title for the register screen
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerTitle;

  /// Label for email field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Label for password field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Label for confirm password field
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Text for forgot password button
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Title for reset password screen
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// Text for login button
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// Text for register button
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// Text for logout button
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutButton;

  /// Text for retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// Text for users who don't have an account
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Text for users who already have an account
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Instructions for password reset
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you instructions to reset your password.'**
  String get resetPasswordInstructions;

  /// Button text to send password reset link
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// Message shown after reset link is sent
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to your email'**
  String get resetLinkSent;

  /// Error message for invalid email
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmail;

  /// Error message for short password
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// Error message when passwords don't match
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get passwordsDontMatch;

  /// Error message for failed login
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your credentials.'**
  String get loginFailed;

  /// Error message for failed registration
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registrationFailed;

  /// Error message for failed password reset
  ///
  /// In en, this message translates to:
  /// **'Failed to send reset link. Please try again.'**
  String get resetPasswordFailed;

  /// Welcome message with user's name
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}!'**
  String welcomeMessage(String name);

  /// Title for profile screen
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// Title for home screen
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// Title for settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Label for dark mode setting
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Label for language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Button text for Google sign-in
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// Button text for Apple sign-in
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInWithApple;

  /// Text for divider between options
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// Button text for guest mode
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
