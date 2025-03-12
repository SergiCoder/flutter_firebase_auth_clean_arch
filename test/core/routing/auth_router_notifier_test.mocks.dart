// Mocks generated by Mockito 5.4.5 from annotations
// in flutter_firebase_auth_clean_arch/test/core/routing/auth_router_notifier_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/usecases/get_auth_state_changes_usecase.dart'
    as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [GetAuthStateChangesUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetAuthStateChangesUseCase extends _i1.Mock
    implements _i2.GetAuthStateChangesUseCase {
  MockGetAuthStateChangesUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Stream<bool> execute() =>
      (super.noSuchMethod(
            Invocation.method(#execute, []),
            returnValue: _i3.Stream<bool>.empty(),
          )
          as _i3.Stream<bool>);
}
