import 'package:flutter/material.dart';

import 'design_system/themes/dark_theme.dart';
import 'design_system/themes/light_theme.dart';
import 'flavors.dart';
import 'routes/route_names.dart';
import 'routes/routes.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appFlavor.appTitle,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: RouteNames.initialRoute,
      routes: routes,
    );
  }
}
