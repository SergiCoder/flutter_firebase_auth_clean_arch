import 'package:flutter_firebase_auth_clean_arch/core/di/service_locator.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the authentication repository
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => serviceLocator<AuthRepository>(),
);
