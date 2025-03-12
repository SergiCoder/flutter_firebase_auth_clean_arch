import 'package:flutter_firebase_auth_clean_arch/features/splash/domain/repositories/splash_repository.dart';

/// Use case for performing some splash operation
class SomeSplashOperationUseCase {
  /// Creates a new [SomeSplashOperationUseCase] with the given repository
  ///
  /// [splashRepository] The repository that provides splash operations
  const SomeSplashOperationUseCase({
    required SplashRepository splashRepository,
  }) : _splashRepository = splashRepository;

  /// The splash repository used to perform operations
  final SplashRepository _splashRepository;

  /// Executes the splash operation
  ///
  /// Returns a [Future] that completes when the operation is finished
  Future<void> execute() {
    return _splashRepository.someSplashOperation();
  }
}
