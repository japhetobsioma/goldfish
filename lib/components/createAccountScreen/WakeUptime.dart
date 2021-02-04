import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class WakeUptime extends StatefulWidget {
  const WakeUptime();

  @override
  _WakeUptimeState createState() => _WakeUptimeState();
}

class _WakeUptimeState extends State<WakeUptime> {
  TimeOfDay wakeUpTime = TimeOfDay(
    hour: 8,
    minute: 30,
  );

  void selectWakeUptime() async {
    final newWakeUpTime = await showTimePicker(
      context: context,
      initialTime: wakeUpTime,
    );
    if (newWakeUpTime != null) {
      setState(() {
        wakeUpTime = newWakeUpTime;
      });
      await saveUserWakeUptime();
    }
  }

  @override
  void initState() {
    super.initState();
    saveUserWakeUptime();
  }

  Future<void> saveUserWakeUptime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userWakeUptime', wakeUpTime.format(context));
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
            'Wake-Up time',
            style: kTitle2Style,
          ),
          SizedBox(
            height: 5.0,
          ),
          InkWell(
            onTap: selectWakeUptime,
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
                      Icons.wb_sunny,
                      color: kPrimaryLabelColor,
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Text(
                      '${wakeUpTime.format(context)}',
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
