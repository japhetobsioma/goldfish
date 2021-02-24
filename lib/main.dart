import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'theme.dart';
import 'screens/welcome.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App();

  static const appTitle = 'project goldfish';
  static const initialRouteName = '/';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: goldfishTheme(),
      title: appTitle,
      initialRoute: initialRouteName,
      routes: {
        initialRouteName: (context) => const WelcomeScreen(),
      },
    );
  }
}
