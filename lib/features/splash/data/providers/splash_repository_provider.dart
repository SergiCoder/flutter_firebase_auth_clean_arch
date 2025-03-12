import 'package:flutter_firebase_auth_clean_arch/features/splash/data/repositories/in_memory_splash_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/domain/repositories/splash_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider for the splash repository implementation
final splashRepositoryImplProvider = Provider<SplashRepository>(
  (ref) => const InMemorySplashRepository(),
);
