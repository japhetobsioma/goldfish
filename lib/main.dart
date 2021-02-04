import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'screens/CreateAccountScreen.dart';
import 'screens/OutputScreen.dart';
import 'screens/WelcomeScreen.dart';
import 'screens/MainScreen.dart';

var isUserSignedUp = false;
Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0),
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: const Color(0xFFE7EEFB),
      systemNavigationBarDividerColor: const Color(0xFFE7EEFB),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();
  var prefs = await SharedPreferences.getInstance();
  isUserSignedUp = prefs.getBool('isUserSignedUp') ?? false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'goldfish',
      initialRoute: isUserSignedUp ? 'MainScreen' : 'WelcomeScreen',
      routes: {
        'WelcomeScreen': (context) => WelcomeScreen(),
        'CreateAccountScreen': (context) => CreateAccountScreen(),
        'MainScreen': (context) => MainScreen(),
        'OutputScreen': (context) => OutputScreen(),
      },
    );
  }
}
