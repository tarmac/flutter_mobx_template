import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'design_system/themes/dark_theme.dart';
import 'design_system/themes/light_theme.dart';
import 'flavors.dart';
import 'routes/route_names.dart';
import 'routes/routes.dart';
import 'services/providers.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: appFlavor!.appTitle,
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: RouteNames.initialRoute,
        routes: routes,
      ),
    );
  }
}
