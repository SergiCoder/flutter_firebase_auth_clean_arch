// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Aplicación de Autenticación';

  @override
  String get changeLanguage => 'Cambiar idioma';

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
  String get loginButton => 'Iniciar Sesión';

  @override
  String get registerButton => 'Registrarse';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta?';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get invalidEmail => 'Por favor ingresa un correo electrónico válido';

  @override
  String get emptyEmail => 'Por favor ingresa tu correo electrónico';

  @override
  String get passwordTooShort => 'La contraseña debe tener al menos 6 caracteres';

  @override
  String get passwordsDontMatch => 'Las contraseñas no coinciden';

  @override
  String get errorPageTitle => 'Página No Encontrada';

  @override
  String get pageNotFoundMessage => 'La página que buscas no existe';

  @override
  String get goBack => 'Volver';

  @override
  String get invalidCredentials => 'Correo electrónico o contraseña inválidos';

  @override
  String get emailAlreadyInUse => 'Este correo electrónico ya está en uso';

  @override
  String get weakPassword => 'La contraseña proporcionada es demasiado débil';

  @override
  String get operationNotAllowed => 'Esta operación no está permitida';

  @override
  String get requiresRecentLogin => 'Por favor inicia sesión de nuevo para continuar';

  @override
  String get authenticationError => 'Ocurrió un error de autenticación';

  @override
  String get permissionDenied => 'Permiso denegado';

  @override
  String get notFound => 'Los datos solicitados no fueron encontrados';

  @override
  String get databaseError => 'Ocurrió un error en la base de datos';

  @override
  String get unexpectedError => 'Ocurrió un error inesperado';
}
