import 'package:flutter/material.dart';

import './screens/tabs_screen.dart';
import './screens/splash_screen.dart';
import './screens/login_screen.dart';
import './utils/constants.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData.dark();

    return MaterialApp(
      title: appTitle,
      restorationScopeId: 'ratings-app',
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: Colors.green,
          secondary: Colors.green,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            primary: Colors.green,
          ),
        ),
        textTheme: TextTheme(
          headline5: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/ideas': (_) => TabsScreen(title: appTitle),
      },
    );
  }
}
