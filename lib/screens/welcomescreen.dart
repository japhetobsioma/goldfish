import 'package:flutter/material.dart';
import 'package:goldfish/systemui_style.dart';

import '../components/welcomescreen/features_cardlist.dart';
import '../components/welcomescreen/getstarted_button.dart';
import '../components/welcomescreen/title_text.dart';
import '../constants.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen();
  @override
  Widget build(BuildContext context) {
    systemUIStyle(
      statusColor: const Color(0),
      statusBrightness: Brightness.dark,
      navigationColor: const Color(0xFFE7EEFB),
      navigationDividerColor: const Color(0xFFE7EEFB),
      navigationBrightness: Brightness.dark,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: kBackgroundColor,
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const WelcomeScreenTitle(),
                  const WelcomeScreenCardList(),
                  const WelcomeScreenButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
