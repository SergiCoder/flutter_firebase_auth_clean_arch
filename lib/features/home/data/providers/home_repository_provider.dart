import 'package:flutter_firebase_auth_clean_arch/features/home/data/repositories/in_memory_home_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/domain/repositories/home_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider for the home repository implementation
final homeRepositoryImplProvider = Provider<HomeRepository>(
  (ref) => const InMemoryHomeRepository(),
);
