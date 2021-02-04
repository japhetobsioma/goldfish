import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class Gender extends StatefulWidget {
  const Gender();

  @override
  _GenderState createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  String gender = 'Male';

  @override
  void initState() {
    super.initState();
    saveUserGender();
  }

  Future<void> saveUserGender() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userGender', gender);
  }

  @override
  Widget build(BuildContext context) {
    final dialog = SimpleDialog(
      title: Text('Select gender'),
      children: [
        GenderDialog(
          icon: Icons.account_circle,
          text: 'Male',
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('userGender', 'Male');

            setState(() {
              gender = 'Male';
            });

            Navigator.pop(context);
          },
        ),
        GenderDialog(
          icon: Icons.account_circle,
          text: 'Female',
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('userGender', 'Male');

            setState(() {
              gender = 'Female';
            });

            Navigator.pop(context);
          },
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 33.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: kTitle2Style,
          ),
          SizedBox(
            height: 5.0,
          ),
          InkWell(
            onTap: () {
              showDialog<void>(context: context, builder: (context) => dialog);
            },
            child: Container(
              height: 60.0,
              width: 280.0,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.wc,
                      color: kPrimaryLabelColor,
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Text(
                      '$gender',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: kPrimaryLabelColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GenderDialog extends StatelessWidget {
  const GenderDialog({this.icon, this.text, this.onPressed});

  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 36.0,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 16.0),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
