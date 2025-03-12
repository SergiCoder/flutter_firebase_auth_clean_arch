// Mocks generated by Mockito 5.4.5 from annotations
// in flutter_firebase_auth_clean_arch/test/features/auth/presentation/login_screen_widget_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/repositories/auth_repository.dart'
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

/// A class which mocks [AuthRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthRepository extends _i1.Mock implements _i2.AuthRepository {
  MockAuthRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Stream<bool> get authStateChanges =>
      (super.noSuchMethod(
            Invocation.getter(#authStateChanges),
            returnValue: _i3.Stream<bool>.empty(),
          )
          as _i3.Stream<bool>);

  @override
  _i3.Future<bool> isAuthenticated() =>
      (super.noSuchMethod(
            Invocation.method(#isAuthenticated, []),
            returnValue: _i3.Future<bool>.value(false),
          )
          as _i3.Future<bool>);

  @override
  _i3.Future<void> signInWithEmailAndPassword(
    String? email,
    String? password,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#signInWithEmailAndPassword, [email, password]),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);

  @override
  _i3.Future<void> createUserWithEmailAndPassword(
    String? email,
    String? password,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#createUserWithEmailAndPassword, [
              email,
              password,
            ]),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);

  @override
  _i3.Future<void> signOut() =>
      (super.noSuchMethod(
            Invocation.method(#signOut, []),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);

  @override
  _i3.Future<void> sendPasswordResetEmail(String? email) =>
      (super.noSuchMethod(
            Invocation.method(#sendPasswordResetEmail, [email]),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);
}
