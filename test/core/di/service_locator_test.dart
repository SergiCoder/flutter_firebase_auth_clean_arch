import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_auth_clean_arch/core/localization/locale_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/core/routing/auth_router_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

// Create mock classes
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockLocaleProvider extends Mock implements LocaleProvider {}

class MockAuthRouterNotifier extends Mock implements AuthRouterNotifier {}

void main() {
  // Ensure Flutter binding is initialized
  TestWidgetsFlutterBinding.ensureInitialized();

  final serviceLocator = GetIt.instance;

  setUp(() async {
    // Use mock instances instead of real ones
    serviceLocator
      ..registerSingleton<FirebaseAuth>(MockFirebaseAuth())
      ..registerSingleton<AuthRepository>(MockAuthRepository())
      ..registerSingleton<LocaleProvider>(MockLocaleProvider())
      ..registerSingleton<AuthRouterNotifier>(MockAuthRouterNotifier());
  });

  tearDown(serviceLocator.reset);

  test('FirebaseAuth is registered and resolves correctly', () {
    final firebaseAuth = serviceLocator<FirebaseAuth>();
    expect(firebaseAuth, isA<MockFirebaseAuth>());
  });

  test('AuthRepository is registered and resolves correctly', () {
    final authRepository = serviceLocator<AuthRepository>();
    expect(authRepository, isA<MockAuthRepository>());
  });

  test('LocaleProvider is registered and resolves correctly', () {
    final localeProvider = serviceLocator<LocaleProvider>();
    expect(localeProvider, isA<MockLocaleProvider>());
  });

  test('AuthRouterNotifier is registered and resolves correctly', () {
    final authRouterNotifier = serviceLocator<AuthRouterNotifier>();
    expect(authRouterNotifier, isA<MockAuthRouterNotifier>());
  });

  test('Singleton behavior is maintained', () {
    final firebaseAuth1 = serviceLocator<FirebaseAuth>();
    final firebaseAuth2 = serviceLocator<FirebaseAuth>();
    expect(identical(firebaseAuth1, firebaseAuth2), isTrue);

    final authRepository1 = serviceLocator<AuthRepository>();
    final authRepository2 = serviceLocator<AuthRepository>();
    expect(identical(authRepository1, authRepository2), isTrue);

    final localeProvider1 = serviceLocator<LocaleProvider>();
    final localeProvider2 = serviceLocator<LocaleProvider>();
    expect(identical(localeProvider1, localeProvider2), isTrue);

    final authRouterNotifier1 = serviceLocator<AuthRouterNotifier>();
    final authRouterNotifier2 = serviceLocator<AuthRouterNotifier>();
    expect(identical(authRouterNotifier1, authRouterNotifier2), isTrue);
  });
}
