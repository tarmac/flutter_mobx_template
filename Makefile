SHELL := /bin/bash

ifeq ($(shell command -v fvm >/dev/null 2>&1; echo $$?),0)
FLUTTER := fvm flutter
DART := fvm dart
else
FLUTTER := flutter
DART := dart
endif

# Generate flavorizr native configurations.
# This will override app.dart, flavors.dart and all main_X.dart.
# Only run if you know what you are doing.
# After running, the cited files need to be reset to their previous state.
gen-flavors:
	$(FLUTTER) pub run flutter_flavorizr

# Generate code and watch
format:
	$(DART) format . -l 120

# Generate code
gen-code:
	$(FLUTTER) pub run build_runner build --delete-conflicting-outputs

# Generate code and format files
gen-code-and-format:
	$(MAKE) gen-code
	$(MAKE) format

# Generate code and watch
gen-code-watch:
	$(FLUTTER) pub run build_runner watch --delete-conflicting-outputs

# CI Tests
ci-tests:
	$(DART) format --set-exit-if-changed . -l 120
	@if [ "$(genCode)" = "true" ]; then $(MAKE) gen-code; fi
	$(FLUTTER) analyze
	$(FLUTTER) test -r expanded

# Complete remote CI pipeline
remote-ci-pipeline-checks:
	$(FLUTTER) packages pub get
	$(MAKE) ci-tests genCode=true
	$(FLUTTER) build apk --debug --flavor dev -t lib/main_dev.dart

