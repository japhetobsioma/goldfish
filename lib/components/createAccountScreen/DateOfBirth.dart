import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';

class DateOfBirth extends StatefulWidget {
  const DateOfBirth();

  @override
  _DateOfBirthState createState() => _DateOfBirthState();
}

class _DateOfBirthState extends State<DateOfBirth> {
  static DateTime date = DateTime.now();
  String formattedDate = DateFormat('yMd').format(date);
  int age = 0;

  void selectDate() async {
    var today = DateTime.now();

    final DateTime newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1905, 1),
      lastDate: DateTime.now(),
      helpText: 'Select a date',
    );

    var newAge = today.year - newDate.year;

    if (today.year < newDate.year) newAge--;

    if (newDate != null) {
      setState(() {
        date = newDate;
        formattedDate = DateFormat('yMd').format(date);
        age = newAge;
      });

      saveUserDOB();
      saveUserAge();
    }
  }

  @override
  void initState() {
    super.initState();
    saveUserDOB();
    saveUserAge();
  }

  Future<void> saveUserDOB() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userDOB', formattedDate);
  }

  Future<void> saveUserAge() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('userAge', age);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 33.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date of birth',
            style: kTitle2Style,
          ),
          SizedBox(
            height: 5.0,
          ),
          InkWell(
            onTap: selectDate,
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
                      Icons.event,
                      color: kPrimaryLabelColor,
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Text(
                      '$formattedDate',
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
