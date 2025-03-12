import 'package:flutter_firebase_auth_clean_arch/features/home/data/repositories/home_repository_impl.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/domain/repositories/home_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider for the home repository implementation
final homeRepositoryImplProvider = Provider<HomeRepository>(
  (ref) => const HomeRepositoryImpl(),
);
