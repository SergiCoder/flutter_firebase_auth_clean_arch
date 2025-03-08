# Flutter Firebase Authentication with Clean Architecture

A cross-platform Flutter application implementing Firebase Authentication with Clean Architecture principles. This project demonstrates best practices for building scalable, maintainable, and testable Flutter applications.

## Features & Technical Stack

- **Cross-Platform Support**: Runs on iOS, Android, Web, macOS, Windows, and Linux
- **Clean Architecture**: Separation of concerns with domain, data, and presentation layers
- **Firebase Authentication**: Complete user authentication flow
- **State Management**: Powered by Riverpod for predictable state handling
- **Navigation**: Declarative routing with go_router
- **Code Reusability**: Custom Flutter Hooks for improved code sharing

## Pages

The application consists of four main pages:

1. **Splash Screen**: Initial loading screen with app branding
2. **Login**: User authentication with email and password
3. **Register**: New user registration
4. **Welcome**: Protected page shown after successful authentication

## Custom Hooks

This project implements two custom Flutter hooks to improve code sharing:

1. First custom hook (details to be added)
2. Second custom hook (details to be added)

Additionally, the project utilizes two hooks from the flutter_hooks package:

1. First package hook (details to be added)
2. Second package hook (details to be added)

## Error Handling

The application handles the following error cases:

1. **Network Connectivity**: Graceful handling when there is no internet connection
2. **Authentication Errors**: User-friendly messages for incorrect credentials

## Project Structure

```
lib/
├── core/
│   ├── error/
│   ├── network/
│   └── use_cases/
├── features/
│   └── auth/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── use_cases/
│       └── presentation/
│           ├── bloc/
│           ├── pages/
│           └── widgets/
└── main.dart
```

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
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
   - Add your application to the Firebase project
   - Download and add the configuration files (google-services.json for Android, GoogleService-Info.plist for iOS)

5. Run the application:
   ```
   flutter run
   ```

## Testing

The project includes unit, widget, and integration tests:

```
flutter test
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Firebase for authentication services
- Contributors to the Riverpod, flutter_hooks, and go_router packages
