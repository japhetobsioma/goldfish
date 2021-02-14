import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'theme.dart';
import 'screens/central.dart';

// Wrap the entire application in a 'ProviderScope' so that it can read
// 'providers'. Check out https://riverpod.dev/ for more information.
void main() {
  // debugPaintSizeEnabled = true;
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
        '/': (context) => const CentralScreen(), // Testing home screen
      },
    );
  }
}
