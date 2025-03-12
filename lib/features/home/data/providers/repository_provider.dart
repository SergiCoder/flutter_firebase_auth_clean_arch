import 'package:flutter_firebase_auth_clean_arch/features/home/data/repositories/in_memory_home_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/domain/repositories/home_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider for the in-memory implementation of the home repository.
///
/// This provider creates and exposes an InMemoryHomeRepository instance
/// that implements the HomeRepository interface.
///
/// In a real application, this would be replaced with an actual implementation
/// that connects to a data source. Currently, it's a placeholder implementation
/// for demonstration purposes.
final homeRepositoryImplProvider = Provider<HomeRepository>(
  (ref) => const InMemoryHomeRepository(),
);
