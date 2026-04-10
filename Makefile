SHELL := /bin/bash

# Generate flavorizr native configurations.
# This will override app.dart, flavors.dart and all main_X.dart.
# Only run if you know what you are doing.
# After running, the cited files need to be reset to their previous state.
gen-flavors:
	fvm flutter pub run flutter_flavorizr

# Generate code
gen-code:
	fvm flutter pub run build_runner build --delete-conflicting-outputs

# Generate code and format files
gen-code-and-format:
	make gen-code
	fvm dart format . -l 120

# CI Tests
ci-tests:
	fvm dart format --set-exit-if-changed . -l 120
	@if [ "$(genCode)" = "true" ]; then make gen-code; fi
	fvm flutter analyze
	fvm flutter test -r expanded

# Complete remote CI pipeline
remote-ci-pipeline-checks:
	fvm flutter packages pub get
	make ci-tests genCode=true
	fvm flutter build apk --debug --flavor dev -t lib/main_dev.dart


