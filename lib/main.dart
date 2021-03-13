import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'screens/createPlan.dart';
import 'common/strings.dart';
import 'common/theme.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: myAppTitle,
      theme: goldfishTheme(),
      initialRoute: createPlanScreen,
      routes: {
        createPlanScreen: (context) => const CreatePlanScreen(),
      },
    );
  }
}
