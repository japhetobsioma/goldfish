import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class Bedtime extends StatefulWidget {
  const Bedtime();
  @override
  _BedtimeState createState() => _BedtimeState();
}

class _BedtimeState extends State<Bedtime> {
  TimeOfDay bedtime = TimeOfDay(
    hour: 22,
    minute: 0,
  );

  void selectBedtime() async {
    final newBedtime = await showTimePicker(
      context: context,
      initialTime: bedtime,
    );
    if (newBedtime != null) {
      setState(() {
        bedtime = newBedtime;
      });
      await saveUserBedtime();
    }
  }

  @override
  void initState() {
    super.initState();
    saveUserBedtime();
  }

  Future<void> saveUserBedtime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userBedtime', bedtime.format(context));
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
            'Bedtime',
            style: kTitle2Style,
          ),
          SizedBox(
            height: 5.0,
          ),
          InkWell(
            onTap: selectBedtime,
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
                      Icons.bedtime,
                      color: kPrimaryLabelColor,
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Text(
                      '${bedtime.format(context)}',
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
