import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../common/helpers.dart';
import '../database/database_helper.dart';
import '../models/notification_manager.dart';
import '../screens/home.dart';

class NotificationManagerNotifier
    extends StateNotifier<AsyncValue<NotificationManager>> {
  NotificationManagerNotifier() : super(const AsyncValue.loading()) {
    fetchNotificationManager();
  }

  static final dbHelper = DatabaseHelper.instance;

  static final defaultNotificationTitle = "Hey, it''s time to drink!";
  static final defaultNotificationBody = [
    'Consume water now',
    'Time for a glass of water',
    'Time to drink water',
    "Let''s drink some water",
    'Drink some water',
    'Have you had any water yet?',
    'Remember to drink some water!',
    'Frequently supplementing your body with water is good for your health',
    'Frequently supplementing your body with water is good for your skin',
    'Frequently supplementing your body with water is good for your brain',
    'Frequently supplementing your body with water is good for your digestive '
        'system',
    'Frequently supplementing your body with water helps maintain your blood '
        'pressure',
    'Frequently supplementing your body with water prevents kidney damage',
    'Frequently supplementing your body with water helps with weight loss',
    "Don''t forget to drink your water!",
    'Hydration makes the body happy',
    "Don''t forget to drink!",
  ];

  Future<void> fetchNotificationManager() async {
    final allScheduledNotifications =
        await dbHelper.fetchScheduledNotifications();
    final totalScheduledNotifications =
        await dbHelper.getTotalScheduledNotifications();

    state = AsyncValue.data(
      NotificationManager(
        allScheduledNotifications: allScheduledNotifications,
        totalScheduledNotifications: totalScheduledNotifications,
      ),
    );
  }

  Future<void> generateScheduledNotifications() async {
    final hydrationPlan = await dbHelper.fetchHydrationPlan();
    final wakeupTime = (hydrationPlan[0]['wakeupTime'] as String).toDateTime;
    final bedtime = (hydrationPlan[0]['bedtime'] as String).toDateTime;

    final sharedPreferences = await SharedPreferences.getInstance();
    final intervalTimeHour = sharedPreferences.getInt('intervalTimeHour') ?? 1;
    final intervalTimeMinute =
        sharedPreferences.getInt('intervalTimeMinute') ?? 30;
    final interval =
        TimeOfDay(hour: intervalTimeHour, minute: intervalTimeMinute);

    final intervalTimes = getIntervalTimes(
      wakeupTime: wakeupTime,
      bedtime: bedtime,
      interval: interval,
    );

    if (intervalTimes.isNotEmpty) {
      var query = '';

      for (var index = 0; index < intervalTimes.length; index++) {
        final hour = intervalTimes[index].hour;
        final minute = intervalTimes[index].minute;
        final randomNumber = Random().nextInt(defaultNotificationBody.length);

        if (index != intervalTimes.length - 1) {
          query += "($hour, $minute, '$defaultNotificationTitle', "
              "'${defaultNotificationBody[randomNumber]}'),";
        } else {
          query += "($hour, $minute, '$defaultNotificationTitle', "
              "'${defaultNotificationBody[randomNumber]}')";
        }
      }

      await dbHelper.insertMultipleScheduledNotifications(query);
    }

    await fetchNotificationManager();
  }

  Future<void> setTimeZone() async {
    final currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }

  tz.TZDateTime scheduledDate({@required int hour, @required int minute}) {
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

  Future<void> setAllScheduledNotifications() async {
    final allScheduledNotifications =
        await dbHelper.fetchScheduledNotifications();

    if (allScheduledNotifications.isNotEmpty) {
      allScheduledNotifications.forEach(
        (element) {
          final id = element['id'];
          final hour = element['hour'];
          final minute = element['minute'];
          final title = element['title'];
          final body = element['body'];

          setSingleScheduledNotification(
            id: id,
            hour: hour,
            minute: minute,
            title: title,
            body: body,
          );
        },
      );
    }

    await fetchNotificationManager();
  }

  Future<void> setSingleScheduledNotification({
    @required int id,
    @required int hour,
    @required int minute,
    @required String title,
    @required String body,
  }) async {
    await setTimeZone();

    title = title.replaceAll(RegExp(r"''"), "'");
    body = body.replaceAll(RegExp(r"''"), "'");

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate(hour: hour, minute: minute),
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

  Future<void> deleteAllScheduledNotifications() async {
    await dbHelper.deleteAllScheduledNotifications();

    await fetchNotificationManager();
  }

  Future<int> insertSingleScheduledNotification({
    @required int hour,
    @required int minute,
    @required String title,
    @required String body,
  }) async {
    title = title.replaceAll(RegExp(r"'"), "''");
    body = body.replaceAll(RegExp(r"'"), "''");

    final id = await dbHelper.insertSingleScheduledNotification(
      hour: hour,
      minute: minute,
      title: title,
      body: body,
    );

    await fetchNotificationManager();

    return id;
  }

  Future<void> deleteSingleScheduledNotification(int id) async {
    await dbHelper.deleteSingleScheduledNotification(
      id: id,
    );

    await fetchNotificationManager();
  }

  Future<void> updateScheduledNotificationHourMinute({
    @required int hour,
    @required int minute,
    @required int id,
  }) async {
    await dbHelper.updateScheduledNotificationHourMinute(
      hour: hour,
      minute: minute,
      id: id,
    );

    await fetchNotificationManager();
  }

  Future<void> updateScheduledNotificationTitle({
    @required String title,
    @required int id,
  }) async {
    title = title.replaceAll(RegExp(r"'"), "''");

    await dbHelper.updateScheduledNotificationTitle(
      title: title,
      id: id,
    );

    await fetchNotificationManager();
  }

  Future<void> updateScheduledNotificationBody({
    @required String body,
    @required int id,
  }) async {
    body = body.replaceAll(RegExp(r"'"), "''");

    await dbHelper.updateScheduledNotificationBody(
      body: body,
      id: id,
    );

    await fetchNotificationManager();
  }

  Future<void> cancelAllScheduledNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> cancelSingleScheduledNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}

final notificationManagerProvider =
    StateNotifierProvider<NotificationManagerNotifier>(
        (ref) => NotificationManagerNotifier());
