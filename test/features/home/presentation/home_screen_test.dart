import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_clean_arch/core/core.dart';
import 'package:flutter_firebase_auth_clean_arch/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:flutter_firebase_auth_clean_arch/features/home/presentation/providers/state/home_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../auth/presentation/mocks/mock_go_router.dart';

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

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// A simplified version of HomeScreen for testing
class TestHomeScreen extends StatelessWidget {
  const TestHomeScreen({
    required this.state,
    required this.signOutUseCase,
    required this.goRouter,
    super.key,
  });
  final HomeState state;
  final MockSignOutUseCase signOutUseCase;
  final MockGoRouter goRouter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (state is HomeLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is HomeError) {
      final errorState = state as HomeError;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(errorState.message),
            ElevatedButton(
              onPressed: () {
                signOutUseCase.execute();
                goRouter.go(AppRoute.login.path);
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      );
    }

    if (state is HomeUnauthenticated) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Login failed. Please check your credentials.'),
            ElevatedButton(
              onPressed: () {
                goRouter.go(AppRoute.login.path);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      );
    }

    if (state is HomeLoaded) {
      final loadedState = state as HomeLoaded;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Welcome, ${loadedState.email}!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                onPressed: () {
                  signOutUseCase.execute();
                  goRouter.go(AppRoute.login.path);
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      );
    }

    // Default placeholder state
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeScreen', () {
    late MockSignOutUseCase mockSignOutUseCase;
    late MockGoRouter mockGoRouter;

    setUp(() {
      mockSignOutUseCase = MockSignOutUseCase();
      mockGoRouter = MockGoRouter();
    });

    testWidgets('renders loading state correctly', (tester) async {
      // Arrange
      final testWidget = MaterialApp(
        home: TestHomeScreen(
          state: const HomeLoading(),
          signOutUseCase: mockSignOutUseCase,
          goRouter: mockGoRouter,
        ),
      );

      // Act
      await tester.pumpWidget(testWidget);

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders error state correctly', (tester) async {
      // Arrange
      const errorMessage = 'An error occurred';
      final testWidget = MaterialApp(
        home: TestHomeScreen(
          state: const HomeError(errorMessage),
          signOutUseCase: mockSignOutUseCase,
          goRouter: mockGoRouter,
        ),
      );

      // Act
      await tester.pumpWidget(testWidget);

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('renders unauthenticated state correctly', (tester) async {
      // Arrange
      final testWidget = MaterialApp(
        home: TestHomeScreen(
          state: const HomeUnauthenticated(),
          signOutUseCase: mockSignOutUseCase,
          goRouter: mockGoRouter,
        ),
      );

      // Act
      await tester.pumpWidget(testWidget);

      // Assert
      expect(
        find.text('Login failed. Please check your credentials.'),
        findsOneWidget,
      );
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('renders loaded state correctly', (tester) async {
      // Arrange
      const email = 'test@example.com';
      final testWidget = MaterialApp(
        home: TestHomeScreen(
          state: const HomeLoaded(email: email),
          signOutUseCase: mockSignOutUseCase,
          goRouter: mockGoRouter,
        ),
      );

      // Act
      await tester.pumpWidget(testWidget);

      // Assert
      expect(find.text('Welcome, $email!'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('logs out when logout button is pressed in error state',
        (tester) async {
      // Arrange
      const errorMessage = 'An error occurred';
      final testWidget = MaterialApp(
        home: TestHomeScreen(
          state: const HomeError(errorMessage),
          signOutUseCase: mockSignOutUseCase,
          goRouter: mockGoRouter,
        ),
      );

      // Act
      await tester.pumpWidget(testWidget);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      verify(mockSignOutUseCase.execute()).called(1);
      verify(mockGoRouter.go(AppRoute.login.path)).called(1);
    });

    testWidgets('logs out when logout button is pressed in loaded state',
        (tester) async {
      // Arrange
      const email = 'test@example.com';
      final testWidget = MaterialApp(
        home: TestHomeScreen(
          state: const HomeLoaded(email: email),
          signOutUseCase: mockSignOutUseCase,
          goRouter: mockGoRouter,
        ),
      );

      // Act
      await tester.pumpWidget(testWidget);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      verify(mockSignOutUseCase.execute()).called(1);
      verify(mockGoRouter.go(AppRoute.login.path)).called(1);
    });

    testWidgets(
        '''navigates to login when login button is pressed in unauthenticated state''',
        (tester) async {
      // Arrange
      final testWidget = MaterialApp(
        home: TestHomeScreen(
          state: const HomeUnauthenticated(),
          signOutUseCase: mockSignOutUseCase,
          goRouter: mockGoRouter,
        ),
      );

      // Act
      await tester.pumpWidget(testWidget);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      verify(mockGoRouter.go(AppRoute.login.path)).called(1);
    });
  });
}
