// Import the data layer providers with an alias
import 'package:flutter_firebase_auth_clean_arch/'
    'features/auth/data/providers/providers.dart' as auth_data;
// Import the domain layer providers with an alias
import 'package:flutter_firebase_auth_clean_arch/'
        'features/auth/domain/providers/auth_usecases_providers.dart'
    as auth_domain;
// Import the home data layer providers with an alias
import 'package:flutter_firebase_auth_clean_arch/'
    'features/home/data/providers/providers.dart' as home_data;
// Import the home domain layer providers with an alias
import 'package:flutter_firebase_auth_clean_arch/'
        'features/home/domain/providers/home_usecases_providers.dart'
    as home_domain;
// Import the splash data layer providers with an alias
import 'package:flutter_firebase_auth_clean_arch/'
    'features/splash/data/providers/providers.dart' as splash_data;
// Import the splash domain layer providers with an alias
import 'package:flutter_firebase_auth_clean_arch/'
        'features/splash/domain/providers/splash_usecases_providers.dart'
    as splash_domain;

/// Connects different layers of the application.
/// Maintains clean architecture by wiring up dependencies.
///
/// In clean architecture, the domain layer should not depend on the data layer.
/// This file serves as a bridge between these layers.

/// List of provider overrides for the application.
/// This is used in the ProviderScope at the root of the application.
final overrides = [
  // Override the domain layer's authRepositoryProvider with the data layer's
  // implementation
  auth_domain.authRepositoryDomainProvider.overrideWith(
    (ref) => ref.watch(auth_data.authRepositoryProvider),
  ),

  // Override the domain layer's homeRepositoryProvider with the data layer's
  // implementation
  home_domain.homeRepositoryDomainProvider.overrideWith(
    (ref) => ref.watch(home_data.homeRepositoryProvider),
  ),

  // Override the domain layer's splashRepositoryProvider with the data layer's
  // implementation
  splash_domain.splashRepositoryDomainProvider.overrideWith(
    (ref) => ref.watch(splash_data.splashRepositoryProvider),
  ),
];
