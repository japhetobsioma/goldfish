import 'package:flutter/material.dart';

import '../../constants.dart';

class ScreenTitle extends StatelessWidget {
  const ScreenTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Create your account',
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
                Rect.fromLTWH(0.0, 0.0, 350.0, 30.0),
              ),
          ),
        ),
        Text(
          'Please fill up the following.',
          style: kSubtitleStyle,
        ),
      ],
    );
  }
}
