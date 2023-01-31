import 'dart:async';

import 'package:flutter/material.dart';

import 'app.dart';
import 'helpers/dependencies/repository_locator.dart';
import 'helpers/dependencies/service_locator.dart';

Future<void> boot() async {
  return runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    setupRepositoryLocator();
    setupServiceLocator();

    FlutterError.onError = (details) {
      // TODO(DavidGrunheidt): Add error handling here
      debugPrint(details.toString());
    };

    runApp(const App());
  }, (error, stackTrace) {
    // TODO(DavidGrunheidt): Add error handling here
    debugPrint('Unhandled Error: $error StackTrace: $stackTrace');
  });
}
