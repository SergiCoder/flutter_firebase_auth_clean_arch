import 'package:flutter_firebase_auth_clean_arch/features/splash/domain/repositories/splash_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/domain/usecases/some_splash_operation_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider for the splash repository.
/// This is a placeholder that should be overridden in the composition root.
/// This approach maintains clean architecture by ensuring the domain layer
/// doesn't depend on the data layer.
final splashRepositoryProvider = Provider<SplashRepository>(
  (ref) => throw UnimplementedError(
    'splashRepositoryProvider has not been overridden. '
    'Make sure to override this provider in the composition root.',
  ),
);

/// Provider for the some splash operation use case
final someSplashOperationUseCaseProvider = Provider<SomeSplashOperationUseCase>(
  (ref) => SomeSplashOperationUseCase(
    splashRepository: ref.watch(splashRepositoryProvider),
  ),
);
