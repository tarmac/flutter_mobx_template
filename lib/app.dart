import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'flavors.dart';
import 'routes/route_names.dart';
import 'routes/routes.dart';
import 'services/providers.dart';
import 'themes/dark_theme.dart';
import 'themes/light_theme.dart';

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
