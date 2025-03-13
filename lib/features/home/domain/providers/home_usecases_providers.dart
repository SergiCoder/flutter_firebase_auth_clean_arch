import 'package:flutter_firebase_auth_clean_arch/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/domain/usecases/some_home_operation_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider for the home repository.
/// This is a placeholder that should be overridden in the composition root.
/// This approach maintains clean architecture by ensuring the domain layer
/// doesn't depend on the data layer.
final homeRepositoryDomainProvider = Provider<HomeRepository>(
  (ref) => throw UnimplementedError(
    'homeRepositoryDomainProvider has not been overridden. '
    'Make sure to override this provider in the composition root.',
  ),
);

/// Provider for the some home operation use case
final someHomeOperationUseCaseProvider = Provider<SomeHomeOperationUseCase>(
  (ref) => SomeHomeOperationUseCase(
    homeRepository: ref.watch(homeRepositoryDomainProvider),
  ),
);
