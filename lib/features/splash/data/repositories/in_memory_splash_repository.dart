import 'package:flutter_firebase_auth_clean_arch/features/splash/domain/repositories/splash_repository.dart';

/// In-memory implementation of the [SplashRepository] interface
///
/// This implementation stores and manages data in memory without
/// using external services or databases.
class InMemorySplashRepository implements SplashRepository {
  /// Creates a new [InMemorySplashRepository]
  const InMemorySplashRepository();

  @override
  Future<void> someSplashOperation() async {
    // Placeholder implementation
  }
}
