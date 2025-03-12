# Test Directory Structure

This directory contains tests for the Flutter Firebase Auth Clean Architecture project.

## Structure

The test directory follows the same structure as the `lib` directory to make it easy to locate tests for specific components:

```
test/
├── core/                  # Tests for core functionality
│   ├── di/                # Tests for dependency injection
│   └── ...
├── features/              # Tests for features
│   ├── auth/              # Tests for auth feature
│   │   ├── data/          # Tests for data layer
│   │   ├── domain/        # Tests for domain layer
│   │   └── presentation/  # Tests for presentation layer
│   ├── home/              # Tests for home feature
│   ├── splash/            # Tests for splash feature
│   └── ...
└── integration_tests/     # Integration tests
```

## Test Types

- **Unit Tests**: Test individual components in isolation
- **Widget Tests**: Test UI components
- **Integration Tests**: Test interactions between components

## Running Tests

To run all tests:

```bash
flutter test
```

To run a specific test file:

```bash
flutter test test/path/to/test_file.dart
```

## Test Coverage

To generate test coverage:

```bash
flutter test --coverage
```

This will generate a `coverage/lcov.info` file that can be used with tools like `lcov` to generate HTML reports. 