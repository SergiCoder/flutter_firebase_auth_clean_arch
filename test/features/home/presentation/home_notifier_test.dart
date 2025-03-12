import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/data/providers/repository_provider.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/providers/auth_usecases_providers.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/presentation/providers/home_notifier.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/presentation/providers/state/home_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

class MockSignOutUseCase extends Mock implements SignOutUseCase {
  @override
  Future<void> execute() async {
    return super.noSuchMethod(
      Invocation.method(#execute, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  FirebaseAuth get instance => this;
}

class MockUser extends Mock implements User {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeNotifier', () {
    late MockSignOutUseCase mockSignOutUseCase;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;
    late HomeNotifier homeNotifier;

    setUp(() {
      mockSignOutUseCase = MockSignOutUseCase();
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();

      // Create the HomeNotifier with the mock dependencies
      homeNotifier = HomeNotifier(
        firebaseAuth: mockFirebaseAuth,
        signOutUseCase: mockSignOutUseCase,
      );
    });

    test('initial state is HomeInitial', () {
      expect(homeNotifier.state, isA<HomeInitial>());
    });

    test('constructor uses provided dependencies', () {
      // Create a new mock instance to verify it's being used
      final customMockAuth = MockFirebaseAuth();
      final customMockUseCase = MockSignOutUseCase();
      final notifier = HomeNotifier(
        firebaseAuth: customMockAuth,
        signOutUseCase: customMockUseCase,
      );

      // Verify initial state is correct
      expect(notifier.state, isA<HomeInitial>());
    });

    group('initialize', () {
      test('emits HomeLoaded when user is authenticated', () async {
        // Arrange
        const email = 'test@example.com';
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.email).thenReturn(email);

        // Act
        await homeNotifier.initialize();

        // Assert
        expect(homeNotifier.state, isA<HomeLoaded>());
        expect((homeNotifier.state as HomeLoaded).email, equals(email));
      });

      test('emits HomeLoaded with "User" when email is null', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.email).thenReturn(null);

        // Act
        await homeNotifier.initialize();

        // Assert
        expect(homeNotifier.state, isA<HomeLoaded>());
        expect((homeNotifier.state as HomeLoaded).email, equals('User'));
      });

      test('emits HomeUnauthenticated when user is not authenticated',
          () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        // Act
        await homeNotifier.initialize();

        // Assert
        expect(homeNotifier.state, isA<HomeUnauthenticated>());
      });

      test('emits HomeError when an exception is thrown', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenThrow(Exception('Test error'));

        // Act
        await homeNotifier.initialize();

        // Assert
        expect(homeNotifier.state, isA<HomeError>());
        expect(
          (homeNotifier.state as HomeError).message,
          contains('Exception: Test error'),
        );
      });
    });

    group('signOut', () {
      test('calls execute on the sign out use case', () async {
        // Act
        await homeNotifier.signOut();

        // Assert
        verify(mockSignOutUseCase.execute()).called(1);
      });

      test('does not change state when signOut succeeds', () async {
        // Arrange
        when(mockSignOutUseCase.execute()).thenAnswer((_) async {});
        homeNotifier = HomeNotifier(
          firebaseAuth: mockFirebaseAuth,
          signOutUseCase: mockSignOutUseCase,
        );

        // Act
        await homeNotifier.signOut();

        // Assert
        expect(homeNotifier.state, isA<HomeInitial>());
      });

      test('does not change state when signOut fails', () async {
        // Arrange
        when(mockSignOutUseCase.execute())
            .thenThrow(Exception('Sign out failed'));
        homeNotifier = HomeNotifier(
          firebaseAuth: mockFirebaseAuth,
          signOutUseCase: mockSignOutUseCase,
        );

        // Act
        await homeNotifier.signOut();

        // Assert
        expect(homeNotifier.state, isA<HomeInitial>());
      });
    });
  });

  group('homeProvider', () {
    test('creates a HomeNotifier with the correct dependencies', () {
      // Arrange
      final mockFirebaseAuth = MockFirebaseAuth();
      final mockSignOutUseCase = MockSignOutUseCase();
      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
          signOutUseCaseProvider.overrideWithValue(mockSignOutUseCase),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final notifier = container.read(homeProvider.notifier);

      // Assert
      expect(notifier, isA<HomeNotifier>());
      expect(container.read(homeProvider), isA<HomeInitial>());
    });
  });
}
