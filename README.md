# Flutter Firebase Authentication with Clean Architecture

A cross-platform Flutter application implementing Firebase Authentication with Clean Architecture principles. This project demonstrates best practices for building scalable, maintainable, and testable Flutter applications.

## Features & Technical Stack

- **Cross-Platform Support**: Runs on iOS, Android, Web, macOS, Windows, and Linux
- **Clean Architecture**: Separation of concerns with domain, data, and presentation layers
- **Firebase Authentication**: Complete user authentication flow with email/password
- **State Management**: Powered by Riverpod and Flutter Hooks for predictable state handling
- **Navigation**: Declarative routing with go_router
- **Internationalization**: Multi-language support with Flutter's built-in localization
- **Environment Configuration**: Secure configuration using dotenv
- **Firebase App Check**: Enhanced security for Firebase services

## Architecture Overview

This project strictly follows Clean Architecture principles, dividing the application into three main layers:

### Domain Layer

The innermost layer containing business logic and rules:
- **Entities**: Core business objects
- **Repositories**: Interfaces defining data operations
- **Use Cases**: Application-specific business rules

### Data Layer

The middle layer responsible for data management:
- **Repositories**: Implementations of domain repository interfaces
- **Data Sources**: Remote (Firebase) and local data providers
- **Models**: Data representations of domain entities

> **Note**: In the current implementation, explicit model classes are not used as the authentication flow leverages Firebase Auth SDK's built-in data structures directly. Models would be added when implementing more complex features requiring data transformation between external sources and domain entities.

### Presentation Layer

The outermost layer handling UI and user interactions:
- **Screens**: User interface components
- **Providers**: State management using Riverpod
- **Widgets**: Reusable UI components

## Riverpod Integration

The project leverages Riverpod for state management and dependency injection:

- **Providers**: Organized by feature and layer for clear separation of concerns
- **StateNotifier**: Used for complex state management with immutable state objects
- **Provider Scopes**: Properly scoped providers to prevent unnecessary rebuilds
- **Dependency Injection**: Clean hierarchical provider dependencies
- **Provider Organization**: Consistent naming conventions (`xxxProvider`) and organization through barrel files
- **AutoDispose**: Strategic use of `autoDispose` based on actual lifecycle needs

Example of provider usage:
```dart
// Domain layer provider
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FirebaseAuthRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
  ),
);

// Use case provider
final signInWithEmailAndPasswordUseCaseProvider = 
    Provider<SignInWithEmailAndPasswordUseCase>(
  (ref) => SignInWithEmailAndPasswordUseCase(
    authRepository: ref.watch(authRepositoryProvider),
  ),
);

// Presentation layer provider
final loginProvider = 
    StateNotifierProvider.autoDispose<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(
    signInUseCase: ref.watch(signInWithEmailAndPasswordUseCaseProvider),
  ),
);
```

## Flutter Hooks Integration

The project uses Flutter Hooks to manage widget state and lifecycle:

- **HookConsumerWidget**: Combines Hooks and Riverpod for efficient state management
- **Built-in Hooks**: Leverages hooks like `useTextEditingController`, `useFocusNode`, and `useEffect`
- **Custom Hooks**: Implements reusable logic across widgets

Example of hooks usage:
```dart
class LoginScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final passwordFocusNode = useFocusNode();
    
    // Side effects with useEffect
    useEffect(() {
      if (loginState is LoginSuccess) {
        // Navigate on successful login
      }
      return null;
    }, [loginState]);
    
    // Rest of the build method...
  }
}
```

## Project Structure

```
lib/
├── core/                     # Core functionality shared across features
│   ├── firebase/             # Firebase configuration
│   ├── localization/         # Internationalization setup
│   ├── presentation/         # Shared UI components
│   ├── routing/              # Application routing
│   ├── theme/                # App theme and styling
│   └── url_strategy/         # URL handling for web
├── features/                 # Feature modules
│   ├── auth/                 # Authentication feature
│   │   ├── data/             # Data layer
│   │   │   ├── providers/    # Data providers
│   │   │   └── repositories/ # Repository implementations
│   │   ├── domain/           # Domain layer
│   │   │   ├── providers/    # Domain providers
│   │   │   ├── repositories/ # Repository interfaces
│   │   │   └── usecases/     # Business logic
│   │   └── presentation/     # Presentation layer
│   │       ├── providers/    # UI state providers
│   │       └── screens       # UI components
│   ├── home/                 # Home feature
│   ├── splash/               # Splash screen feature
│   └── error/                # Error handling feature
├── generated/                # Generated code
├── l10n/                     # Localization resources
└── main.dart                 # Application entry point
```

## Barrel Files and Export Patterns

The project uses a consistent barrel file pattern to organize and export code:

- **Feature-Level Barrels**: Each feature has a main barrel file (e.g., `auth.dart`) that exports all its layers
- **Layer-Level Barrels**: Each layer within a feature has its own barrel file (e.g., `data.dart`, `domain.dart`)
- **Component-Level Barrels**: Groups of related components have dedicated barrel files (e.g., `providers.dart`, `repositories.dart`)

This pattern provides several benefits:
- **Clean Imports**: Allows importing multiple related components with a single import statement
- **Encapsulation**: Hides internal implementation details while exposing only what's needed
- **Maintainability**: Makes it easier to refactor and reorganize code without breaking imports
- **Discoverability**: Provides a clear entry point for each feature and layer

Example of the barrel file hierarchy:
```dart
// Feature-level barrel (auth.dart)
export 'data/data.dart';
export 'domain/domain.dart';
export 'presentation/presentation.dart';

// Layer-level barrel (domain.dart)
export 'providers/providers.dart';
export 'repositories/repositories.dart';
export 'usecases/usecases.dart';

// Component-level barrel (usecases.dart)
export 'create_user_with_email_and_password_usecase.dart';
export 'is_authenticated_usecase.dart';
export 'sign_in_with_email_and_password_usecase.dart';
export 'sign_out_usecase.dart';
```

## Authentication Flow

The application implements a complete authentication flow:

1. **Splash Screen**: Checks authentication status
2. **Login/Register**: User authentication with email and password
3. **Home Screen**: Protected content for authenticated users
4. **Sign Out**: User logout functionality

## Getting Started

### Prerequisites

- Flutter SDK (version 3.5.4 or later)
- Firebase project setup
- IDE (VS Code, Android Studio, or IntelliJ)

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/flutter_firebase_auth_clean_arch.git
   ```

2. Navigate to the project directory:
   ```
   cd flutter_firebase_auth_clean_arch
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Configure Firebase:
   - Create a Firebase project
   - Enable Authentication with Email/Password
   - Add your application to the Firebase project
   - Download and add the configuration files

5. Set up environment variables:
   - Copy `.env.example` to `.env`
   - Update the values with your Firebase configuration

6. Run the application:
   ```
   flutter run
   ```

## Testing

The project includes comprehensive tests:

- **Unit Tests**: Testing individual components (use cases, repositories)
- **Widget Tests**: Testing UI components
- **Integration Tests**: Testing feature workflows

Run tests with:
```
flutter test
```

For test coverage:
```
./test_coverage.sh
```

## Best Practices Implemented

- **Separation of Concerns**: Clear boundaries between layers
- **Dependency Inversion**: Domain layer defines interfaces implemented by outer layers
- **Single Responsibility**: Each class has a single purpose
- **Testability**: Dependencies are injected for easy mocking
- **Code Documentation**: Comprehensive documentation for public APIs
- **Error Handling**: Robust error handling with user-friendly messages
- **Organized Exports**: Consistent barrel file pattern for clean imports and better code organization
- **Resource Management**: Proper lifecycle management with strategic use of `autoDispose`

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Firebase for authentication services
- Contributors to the Riverpod, flutter_hooks, and go_router packages
