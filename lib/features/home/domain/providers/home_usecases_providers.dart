import 'package:flutter_firebase_auth_clean_arch/features/home/data/providers/providers.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/domain/usecases/some_home_operation_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider for the some home operation use case
final someHomeOperationUseCaseProvider = Provider<SomeHomeOperationUseCase>(
  (ref) => SomeHomeOperationUseCase(
    homeRepository: ref.watch(homeRepositoryProvider),
  ),
);
