import 'package:flutter/material.dart';

class NotificationsManager {
  const NotificationsManager({
    @required this.allScheduledNotifications,
    @required this.totalScheduledNotifications,
  });

  final List<Map<String, dynamic>> allScheduledNotifications;
  final int totalScheduledNotifications;
}
