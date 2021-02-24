import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'screens/central.dart';

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
  static const welcomeScreen = '/';
  static const centralScreen = 'CentralScreen';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: goldfishTheme(),
      title: appTitle,
      initialRoute: welcomeScreen,
      routes: {
        welcomeScreen: (context) => const WelcomeScreen(),
        centralScreen: (context) => const CentralScreen(),
      },
    );
  }
}
