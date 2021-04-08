import 'package:flutter/material.dart';

enum NotificationMode { Interval, Custom }

class NotificationsSettings {
  const NotificationsSettings({
    @required this.isNotificationTurnOn,
    @required this.notificationMode,
    @required this.totalActiveNotifications,
    @required this.intervalTimeHour,
    @required this.intervalTimeMinute,
  });

  final bool isNotificationTurnOn;
  final NotificationMode notificationMode;
  final int totalActiveNotifications;
  final int intervalTimeHour;
  final int intervalTimeMinute;
}
