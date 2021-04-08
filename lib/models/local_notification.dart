import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../screens/home.dart';

class LocalNotification {
  const LocalNotification({
    @required this.hour,
    @required this.minute,
    @required this.id,
    @required this.title,
    @required this.body,
  })  : assert(hour <= 23),
        assert(minute <= 59);

  final int hour;
  final int minute;
  final int id;
  final String title;
  final String body;

  void setScheduledNotification() async {
    final currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    tz.TZDateTime scheduleTime() {
      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
      return scheduledDate;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleTime(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channelID',
          'channelName',
          'channelDescription',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
