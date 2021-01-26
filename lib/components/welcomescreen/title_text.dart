import 'package:flutter/material.dart';

import '../../constants.dart';

class WelcomeScreenTitle extends StatelessWidget {
  const WelcomeScreenTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Application Title here',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
            foreground: Paint()
              ..shader = LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF00AEFF),
                  Color(0xFF0076FF),
                ],
              ).createShader(
                Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
              ),
          ),
        ),
        Text(
          'Application Subtitle here',
          style: kSubtitleStyle,
        ),
      ],
    );
  }
}
