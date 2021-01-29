import 'package:flutter/material.dart';

import '../components/createAccountScreen/DateOfBirth.dart';
import '../components/createAccountScreen/ScreenTitle.dart';
import '../components/createAccountScreen/WakeUptime.dart';
import '../components/createAccountScreen/Bedtime.dart';
import '../components/createAccountScreen/Gender.dart';
import '../components/createAccountScreen/SignUp.dart';
import '../constants.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen();

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
                Column(
                  children: [
                    const DateOfBirth(),
                    SizedBox(
                      height: 20.0,
                    ),
                    const Gender(),
                    SizedBox(
                      height: 20.0,
                    ),
                    const WakeUptime(),
                    SizedBox(
                      height: 20.0,
                    ),
                    const Bedtime(),
                  ],
                ),
                const SignUp(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
