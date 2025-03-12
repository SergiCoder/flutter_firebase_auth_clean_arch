// Import the data layer providers with an alias
import 'package:flutter_firebase_auth_clean_arch/'
    'features/auth/data/providers/providers.dart' as data;
// Import the domain layer providers with an alias
import 'package:flutter_firebase_auth_clean_arch/'
    'features/auth/domain/providers/auth_usecases_providers.dart' as domain;

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
  domain.authRepositoryProvider.overrideWith(
    (ref) => ref.watch(data.firebaseAuthRepositoryProvider),
  ),
];
