import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../common/helpers.dart';
import '../database/database_helper.dart';
import '../models/notifications_manager.dart';
import '../screens/home.dart';

class NotificationsManagerNotifier
    extends StateNotifier<AsyncValue<NotificationsManager>> {
  NotificationsManagerNotifier() : super(const AsyncValue.loading()) {
    fetchNotificationsManager();
  }

  static final dbHelper = DatabaseHelper.instance;

  Future<void> fetchNotificationsManager() async {
    final allScheduledNotifications =
        await dbHelper.fetchScheduledNotifications();
    final totalScheduledNotifications =
        await dbHelper.getTotalScheduledNotifications();

    state = AsyncValue.data(
      NotificationsManager(
        allScheduledNotifications: allScheduledNotifications,
        totalScheduledNotifications: totalScheduledNotifications,
      ),
    );
  }

  Future<void> generateScheduledNotifications() async {
    final hydrationPlan = await dbHelper.readHydrationPlan();
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

        if (index != intervalTimes.length - 1) {
          query += "($hour, $minute, 'title', 'body'),";
        } else {
          query += "($hour, $minute, 'title', 'body')";
        }
      }

      await dbHelper.insertMultipleScheduledNotifications(query);
    }

    await fetchNotificationsManager();
  }

  Future<void> setTimeZones() async {
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

          setSingleScheduledNotifications(
            id: id,
            hour: hour,
            minute: minute,
            title: title,
            body: body,
          );
        },
      );
    }

    await fetchNotificationsManager();
  }

  Future<void> setSingleScheduledNotifications({
    @required int id,
    @required int hour,
    @required int minute,
    @required String title,
    @required String body,
  }) async {
    await setTimeZones();

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

    await fetchNotificationsManager();
  }

  Future<int> insertSingleScheduledNotifications({
    @required int hour,
    @required int minute,
    @required String title,
    @required String body,
  }) async {
    final id = await dbHelper.insertSingleScheduledNotifications(
      hour: hour,
      minute: minute,
      title: title,
      body: body,
    );

    await fetchNotificationsManager();

    return id;
  }

  Future<void> deleteSingleScheduledNotifications(int id) async {
    await dbHelper.deleteSingleScheduledNotifications(
      id: id,
    );

    await fetchNotificationsManager();
  }

  Future<void> updateScheduledNotificationsHourMinute({
    @required int hour,
    @required int minute,
    @required int id,
  }) async {
    await dbHelper.updateScheduledNotificationsHourMinute(
      hour: hour,
      minute: minute,
      id: id,
    );

    await fetchNotificationsManager();
  }

  Future<void> updateScheduledNotificationsTitle({
    @required String title,
    @required int id,
  }) async {
    await dbHelper.updateScheduledNotificationsTitle(
      title: title,
      id: id,
    );

    await fetchNotificationsManager();
  }

  Future<void> updateScheduledNotificationsBody({
    @required String body,
    @required int id,
  }) async {
    await dbHelper.updateScheduledNotificationsBody(
      body: body,
      id: id,
    );

    await fetchNotificationsManager();
  }

  Future<void> cancelAllScheduledNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> cancelSingleScheduledNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}

final notificationsManagerProvider =
    StateNotifierProvider<NotificationsManagerNotifier>(
        (ref) => NotificationsManagerNotifier());
