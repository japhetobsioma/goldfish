import 'package:flutter/material.dart';

class NotificationManager {
  const NotificationManager({
    @required this.allScheduledNotifications,
    @required this.totalScheduledNotifications,
  });

  final List<Map<String, dynamic>> allScheduledNotifications;
  final int totalScheduledNotifications;
}
