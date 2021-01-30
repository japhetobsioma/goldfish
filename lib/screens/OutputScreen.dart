import 'package:flutter/material.dart';
import 'package:goldfish/model/CalculateWaterGoal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class OutputScreen extends StatefulWidget {
  @override
  _OutputScreenState createState() => _OutputScreenState();
}

class _OutputScreenState extends State<OutputScreen> {
  String userDOB, userGender, userWakeUptime, userBedtime;
  int userAge;
  double userWaterGoal;

  @override
  void initState() {
    super.initState();
    readAllUserData();
  }

  Future<void> readAllUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userDOB = prefs.getString('userDOB');
      userAge = prefs.getInt('userAge');
      userGender = prefs.getString('userGender');
      userWakeUptime = prefs.getString('userWakeUptime');
      userBedtime = prefs.getString('userBedtime');

      userWaterGoal = calculateWaterGoal(userAge, userGender);
      prefs.setDouble('userWaterGoal', userWaterGoal);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return Container(
            height: height,
            width: width,
            child: Text(
              'Date of birth: ${userDOB ?? null}'
              '\nAge: ${userAge.toString() ?? null}'
              '\nGender: ${userGender ?? null}'
              '\nWake-Up time: ${userWakeUptime ?? null}'
              '\nBedtime: ${userBedtime ?? null}'
              '\nWater goal: ${userWaterGoal.toString() ?? null} L/day',
              style: kTitle2Style,
            ),
          );
        },
      ),
    );
  }
}
