import 'package:flutter_firebase_auth_clean_arch/features/splash/data/providers/providers.dart';
import 'package:flutter_firebase_auth_clean_arch/features/splash/domain/usecases/some_splash_operation_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider for the some splash operation use case
final someSplashOperationUseCaseProvider = Provider<SomeSplashOperationUseCase>(
  (ref) => SomeSplashOperationUseCase(
    splashRepository: ref.watch(splashRepositoryProvider),
  ),
);
