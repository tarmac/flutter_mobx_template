SHELL := /bin/bash
.PHONY: ci-tests

# Generate flavorizr native configurations.
# This will override app.dart, flavors.dart and all main_X.dart.
# Only run if you know what you are doing.
# After running, the cited files need to be reset to their previous state.
gen-flavors:
	flutter pub run flutter_flavorizr

# Generate code
gen-code:
	flutter pub run build_runner build --delete-conflicting-outputs
	flutter format . -l 120

# CI Tests
ci-tests:
	flutter format --set-exit-if-changed -n . -l 120
	flutter analyze
	flutter test -r expanded

apply-lint:
	dart fix --dry-run
	dart fix --apply

# Format code:
format-code:
	flutter format . -l 150
	flutter pub run import_path_converter:main
