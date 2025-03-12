import 'package:flutter_firebase_auth_clean_arch/features/home/domain/repositories/home_repository.dart';

/// In-memory implementation of the [HomeRepository] interface
///
/// This implementation stores and manages data in memory without
/// using external services or databases.
class InMemoryHomeRepository implements HomeRepository {
  /// Creates a new [InMemoryHomeRepository]
  const InMemoryHomeRepository();

  @override
  Future<void> someHomeOperation() async {
    // Placeholder implementation
  }
}
