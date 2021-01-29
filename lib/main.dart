import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'screens/CreateAccountScreen.dart';
import 'screens/WelcomeScreen.dart';
import 'screens/MainScreen.dart';

var isUserSignedUp = false;
Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: const Color(0),
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: const Color(0xFFE7EEFB),
      systemNavigationBarDividerColor: const Color(0xFFE7EEFB),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isUserSignedUp = prefs.getBool('isUserSignedUp') ?? false;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      },
    );
  }
}
