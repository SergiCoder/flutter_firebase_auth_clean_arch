# Authentication State Management

This document explains how authentication state is managed in the application.

## Architecture Overview

The authentication state management follows clean architecture principles with the following components:

1. **Domain Layer**
   - `AuthRepository` (interface): Defines the contract for authentication operations
   - Located in `lib/features/auth/domain/repositories/auth_repository.dart`
   - Provides methods for authentication operations and a stream of auth state changes

2. **Data Layer**
   - `FirebaseAuthRepository` (implementation): Implements the AuthRepository interface using Firebase Auth
   - Located in `lib/features/auth/data/repositories/firebase_auth_repository.dart`
   - Uses Firebase Auth to handle authentication and provide real-time auth state updates

3. **Presentation Layer**
   - `AuthRouterNotifier`: Listens to authentication state changes and notifies the router
   - Located in `lib/core/routing/auth_router_notifier.dart`
   - Acts as a bridge between the auth repository and the router
   
   - `AuthNotifierProvider`: Makes the AuthRouterNotifier available to the widget tree
   - Located in `lib/core/routing/auth_notifier_provider.dart`
   - Provides access to authentication state throughout the application
   
   - `AuthRepositoryProvider`: Makes the AuthRepository available to the widget tree
   - Located in `lib/features/auth/presentation/providers/auth_repository_provider.dart`
   - Provides access to authentication operations throughout the application

## Authentication Flow

1. **Initialization**:
   - Firebase is initialized in the `main()` function
   - `FirebaseAuthRepository` is created and passed to the app
   - `AuthRouterNotifier` is created and listens to auth state changes
   - GoRouter is configured with the `AuthRouterNotifier` as its `refreshListenable`

2. **State Changes**:
   - The `FirebaseAuthRepository` provides a stream of authentication state changes via the `authStateChanges` getter
   - The `AuthRouterNotifier` listens to this stream and updates its `isAuthenticated` state
   - When the authentication state changes, the `AuthRouterNotifier` calls `notifyListeners()`
   - The GoRouter is notified of the change and re-evaluates its redirect logic

3. **Routing Logic**:
   - The splash screen is always accessible regardless of authentication state
   - Unauthenticated users can only access the login and register screens
   - Authenticated users are redirected to the home screen when trying to access login or register screens
   - Authenticated users can access all protected routes

## Splash Screen Handling

The splash screen serves as the entry point to the application and is exempt from authentication redirects. This allows the app to:

1. **Initialize Firebase**: The splash screen provides time for Firebase to initialize
2. **Check Authentication State**: The app can determine if the user is already authenticated
3. **Load Initial Data**: Any necessary data can be loaded before proceeding

The splash screen automatically navigates to the appropriate screen after a delay:

```dart
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    
    // Navigate to the appropriate screen after a delay
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // The router will handle redirecting to the appropriate screen
        // based on authentication state
        context.goRoute(AppRoute.home);
      }
    });
  }
  
  // ...
}
```

In the router's redirect callback, we explicitly skip redirects for the splash screen:

```dart
redirect: (context, state) {
  // Skip redirect for splash screen
  if (state.matchedLocation == AppRoute.splash.path) {
    return null;
  }
  
  // Handle other redirects based on authentication state
  // ...
}
```

## Redirect Logic

```dart
redirect: (context, state) {
  // Skip redirect for splash screen
  if (state.matchedLocation == AppRoute.splash.path) {
    return null;
  }

  final isAuthenticated = authNotifier.isAuthenticated;

  // If the user is not authenticated, they can only access login and register
  if (!isAuthenticated) {
    if (state.matchedLocation != AppRoute.login.path &&
        state.matchedLocation != AppRoute.register.path) {
      return AppRoute.login.path;
    }
  }
  // If the user is authenticated, they shouldn't access login or register
  else {
    if (state.matchedLocation == AppRoute.login.path ||
        state.matchedLocation == AppRoute.register.path) {
      return AppRoute.home.path;
    }
  }

  return null;
}
```

## Accessing Authentication State

### In the Router

The router uses the `AuthRouterNotifier` to check if the user is authenticated:

```dart
final isAuthenticated = authNotifier.isAuthenticated;
```

### In Widgets

Widgets can access the authentication state in two ways:

1. **Via the `AuthNotifierProvider`**:

```dart
// Get the auth notifier
final authNotifier = AuthNotifierProvider.of(context);

// Check if the user is authenticated
final isAuthenticated = authNotifier.isAuthenticated;

// Use the authentication state in your UI
return isAuthenticated 
    ? const Text('Welcome back!') 
    : const Text('Please sign in');
```

2. **Via the `AuthRepositoryProvider`** to perform authentication operations:

```dart
// Get the auth repository
final authRepository = AuthRepositoryProvider.of(context);

// Sign in
try {
  await authRepository.signInWithEmailAndPassword(email, password);
  // Success - navigation will be handled by the router
} catch (e) {
  // Handle error
}

// Sign out
try {
  await authRepository.signOut();
  // Success - navigation will be handled by the router
} catch (e) {
  // Handle error
}

// Send password reset email
try {
  await authRepository.sendPasswordResetEmail(email);
  // Show success message
} catch (e) {
  // Handle error
}
```

## Testing Authentication

### Mocking the AuthRepository

For testing, you can create a mock implementation of the `AuthRepository`:

```dart
class MockAuthRepository implements AuthRepository {
  bool _isAuthenticated = false;
  final _authStateController = StreamController<bool>.broadcast();

  @override
  Stream<bool> get authStateChanges => _authStateController.stream;

  @override
  Future<bool> isAuthenticated() async => _isAuthenticated;

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    // Mock implementation
    _isAuthenticated = true;
    _authStateController.add(true);
  }

  @override
  Future<void> signOut() async {
    // Mock implementation
    _isAuthenticated = false;
    _authStateController.add(false);
  }

  // Implement other methods...
}
```

### Testing the Router

You can test the router's redirect logic by providing a mock `AuthRouterNotifier`:

```dart
testWidgets('Router redirects unauthenticated user to login', (tester) async {
  final mockAuthNotifier = MockAuthRouterNotifier(isAuthenticated: false);
  final router = AppRouter.createRouter(authNotifier: mockAuthNotifier);
  
  // Test router behavior
});
```

## Benefits of This Approach

1. **Clean Architecture**: Separation of concerns between domain, data, and presentation layers
2. **Testability**: Easy to mock the AuthRepository for testing
3. **Reactivity**: UI automatically updates when authentication state changes
4. **Centralized State**: Authentication state is managed in one place
5. **Type Safety**: Strong typing throughout the authentication flow
6. **Decoupling**: Authentication logic is decoupled from UI components
7. **Maintainability**: Easy to modify or extend authentication behavior 