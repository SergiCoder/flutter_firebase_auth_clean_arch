// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'App de Autenticación';

  @override
  String get loginTitle => 'Iniciar Sesión';

  @override
  String get registerTitle => 'Registrarse';

  @override
  String get email => 'Correo Electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get confirmPassword => 'Confirmar Contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get resetPassword => 'Restablecer Contraseña';

  @override
  String get loginButton => 'Iniciar Sesión';

  @override
  String get registerButton => 'Registrarse';

  @override
  String get logoutButton => 'Cerrar Sesión';

  @override
  String get retryButton => 'Reintentar';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta?';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get resetPasswordInstructions => 'Ingresa tu correo electrónico y te enviaremos instrucciones para restablecer tu contraseña.';

  @override
  String get sendResetLink => 'Enviar Enlace de Restablecimiento';

  @override
  String get resetLinkSent => 'Enlace de restablecimiento enviado a tu correo';

  @override
  String get invalidEmail => 'Por favor ingresa un correo electrónico válido';

  @override
  String get passwordTooShort => 'La contraseña debe tener al menos 6 caracteres';

  @override
  String get passwordsDontMatch => 'Las contraseñas no coinciden';

  @override
  String get loginFailed => 'Error al iniciar sesión. Por favor verifica tus credenciales.';

  @override
  String get registrationFailed => 'Error al registrarse. Por favor intenta de nuevo.';

  @override
  String get resetPasswordFailed => 'Error al enviar el enlace de restablecimiento. Por favor intenta de nuevo.';

  @override
  String welcomeMessage(String email) {
    return 'Bienvenido, $email!';
  }

  @override
  String get profileTitle => 'Perfil';

  @override
  String get homeTitle => 'Inicio';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get signInWithGoogle => 'Iniciar sesión con Google';

  @override
  String get signInWithApple => 'Iniciar sesión con Apple';

  @override
  String get or => 'O';

  @override
  String get continueAsGuest => 'Continuar como Invitado';

  @override
  String get errorPageTitle => 'Página No Encontrada';

  @override
  String get pageNotFoundMessage => 'La página que buscas no existe';

  @override
  String get goBack => 'Volver';
}
