import 'package:flutter/material.dart';

import '../components/welcomeScreen/FeaturesList.dart';
import '../components/welcomeScreen/ScreenTitle.dart';
import '../components/welcomeScreen/GetStarted.dart';
import '../constants.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: kBackgroundColor,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const ScreenTitle(),
                const FeaturesList(),
                const GetStarted(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
