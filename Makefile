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

# Generate code and format files
gen-code-and-format:
	make gen-code
	flutter format . -l 120

# CI Tests
ci-tests:
	flutter format --set-exit-if-changed -n . -l 120
	@if [ "$(genCode)" = "true" ]; then make gen-code; fi
	flutter analyze
	flutter test -r expanded

# Complete remote CI pipeline
remote-ci-pipeline-checks:
	flutter packages pub get
	make ci-tests genCode=true
	flutter build apk --debug --flavor dev -t lib/main_dev.dart


