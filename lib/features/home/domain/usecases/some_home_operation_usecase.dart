import 'package:flutter_firebase_auth_clean_arch/features/home/domain/repositories/home_repository.dart';

/// Use case for performing some home operation
class SomeHomeOperationUseCase {
  /// Creates a new [SomeHomeOperationUseCase] with the given repository
  ///
  /// [homeRepository] The repository that provides home operations
  const SomeHomeOperationUseCase({
    required HomeRepository homeRepository,
  }) : _homeRepository = homeRepository;

  /// The home repository used to perform operations
  final HomeRepository _homeRepository;

  /// Executes the home operation
  ///
  /// Returns a [Future] that completes when the operation is finished
  Future<void> execute() {
    return _homeRepository.someHomeOperation();
  }
}
