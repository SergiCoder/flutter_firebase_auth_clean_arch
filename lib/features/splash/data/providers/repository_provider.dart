import 'package:flutter_firebase_auth_clean_arch/features/splash/data/repositories/in_memory_splash_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/domain/repositories/splash_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider for the in-memory implementation of the splash repository.
///
/// This provider creates and exposes an InMemorySplashRepository instance
/// that implements the SplashRepository interface.
///
/// In a real application, this would be replaced with an actual implementation
/// that connects to a data source. Currently, it's a placeholder implementation
/// for demonstration purposes.
final splashRepositoryProvider = Provider<SplashRepository>(
  (ref) => const InMemorySplashRepository(),
);
