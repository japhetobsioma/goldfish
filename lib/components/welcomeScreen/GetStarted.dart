import 'package:flutter/material.dart';

import '../../constants.dart';

class GetStarted extends StatelessWidget {
  const GetStarted();

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        Navigator.pushNamed(context, 'CreateAccountScreen');
      },
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: 120.0,
        maxHeight: 50.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.0),
          boxShadow: [
            BoxShadow(
              color: kShadowColor,
              offset: Offset(0, 12),
              blurRadius: 16.0,
            ),
          ],
        ),
        child: const Text(
          'GET STARTED',
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            color: kPrimaryLabelColor,
            decoration: TextDecoration.none,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 14.0,
        ),
      ),
    );
  }
}
