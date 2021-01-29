import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp();

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('isUserSignedUp', true);

        Navigator.pushNamed(context, 'MainScreen');
      },
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: 120.0,
        maxHeight: 50.0,
      ),
      child: Container(
        width: 200.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00AEFF),
              Color(0xFF0076FF),
            ],
          ),
          borderRadius: BorderRadius.circular(14.0),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF00AEFF).withOpacity(0.30),
              offset: Offset(0, 20),
              blurRadius: 30.0,
            ),
            BoxShadow(
              color: Color(0xFF0076FF).withOpacity(0.30),
              offset: Offset(0, 20),
              blurRadius: 30.0,
            ),
          ],
        ),
        child: const Text(
          'SIGN UP',
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
          textAlign: TextAlign.center,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 14.0,
        ),
      ),
    );
  }
}
