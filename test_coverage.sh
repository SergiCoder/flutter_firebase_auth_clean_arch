#!/bin/bash

# Run tests with coverage
flutter test --coverage

# Remove generated files from coverage report
lcov --remove coverage/lcov.info "lib/generated/*.dart" -o coverage/lcov.info

# Verify that generated files were removed
echo "Verifying that generated files were removed from coverage report..."
if grep -q "lib/generated/" coverage/lcov.info; then
  echo "Warning: Generated files are still present in the coverage report."
  echo "You might need to adjust the pattern in the lcov command."
else
  echo "Success: No generated files found in the coverage report."
fi

# Generate HTML report (optional)
genhtml coverage/lcov.info -o coverage/html

echo "Coverage report generated. Open coverage/html/index.html to view it."