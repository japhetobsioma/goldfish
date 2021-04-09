import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/helpers.dart';
import '../database/database_helper.dart';
import '../models/local_notification.dart';
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

  Future<void> setScheduledNotifications() async {
    final allScheduledNotifications =
        await dbHelper.fetchScheduledNotifications();
    final localNotificationList = <LocalNotification>[];

    if (allScheduledNotifications.isNotEmpty) {
      allScheduledNotifications.forEach((element) {
        final id = element['id'];
        final hour = element['hour'];
        final minute = element['minute'];
        final title = element['title'];
        final body = element['body'];

        localNotificationList.add(
          LocalNotification(
            hour: hour,
            minute: minute,
            id: id,
            title: title,
            body: body,
          ),
        );
      });

      localNotificationList.forEach((element) {
        element.setScheduledNotification();
      });
    }

    await fetchNotificationsManager();
  }

  Future<void> deleteAllScheduledNotifications() async {
    await dbHelper.deleteAllScheduledNotifications();

    await fetchNotificationsManager();
  }

  Future<void> insertSingleScheduledNotifications({
    @required int hour,
    @required int minute,
    @required String title,
    @required String body,
  }) async {
    await dbHelper.insertSingleScheduledNotifications(
      hour: hour,
      minute: minute,
      title: title,
      body: body,
    );

    await fetchNotificationsManager();
  }

  Future<void> deleteSingleScheduledNotifications({@required int id}) async {
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

  Future<void> cancelSingleScheduledNotifications({@required int id}) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}

final notificationsManagerProvider =
    StateNotifierProvider<NotificationsManagerNotifier>(
        (ref) => NotificationsManagerNotifier());
