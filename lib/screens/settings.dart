import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../models/local_notification.dart';

class SettingsScreen extends HookWidget {
  const SettingsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            final scheduledNotifications = [
              LocalNotification(
                id: 0,
                hour: 15,
                minute: 55,
              ),
              LocalNotification(
                id: 1,
                hour: 15,
                minute: 58,
              )
            ];

            scheduledNotifications.forEach((element) {
              element.setScheduledNotification();
            });
          },
          child: const Text('Show Notification'),
        ),
      ),
    );
  }
}
