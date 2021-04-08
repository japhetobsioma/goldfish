import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/helpers.dart';
import '../database/database_helper.dart';
import '../models/notifications_settings.dart';

class NotificationsSettingsNotifier
    extends StateNotifier<AsyncValue<NotificationsSettings>> {
  NotificationsSettingsNotifier() : super(const AsyncValue.loading()) {
    fetchNotificationsSettings();
  }

  static final dbHelper = DatabaseHelper.instance;

  Future<void> fetchNotificationsSettings() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final isNotificationTurnOn =
        sharedPreferences.getBool('isNotificationTurnOn') ?? true;
    final notificationMode =
        sharedPreferences.getString('notificationMode') ?? 'Interval';
    final totalActiveNotification = 10;
    final intervalTimeHour = sharedPreferences.getInt('intervalTimeHour') ?? 1;
    final intervalTimeMinute =
        sharedPreferences.getInt('intervalTimeMinute') ?? 30;

    state = AsyncValue.data(
      NotificationsSettings(
        isNotificationTurnOn: isNotificationTurnOn,
        notificationMode: notificationMode.toNotificationMode,
        totalActiveNotifications: totalActiveNotification,
        intervalTimeHour: intervalTimeHour,
        intervalTimeMinute: intervalTimeMinute,
      ),
    );
  }

  Future<void> updateIsNotificationTurnOn(bool value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('isNotificationTurnOn', value);

    await fetchNotificationsSettings();
  }

  Future<void> updateNotificationMode(NotificationMode value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('notificationMode', value.name);

    await fetchNotificationsSettings();
  }

  Future<void> updateIntervalHour(String value) async {
    final newValue = int.tryParse(value);

    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt('intervalTimeHour', newValue);

    await fetchNotificationsSettings();
  }

  Future<void> updateIntervalMinute(String value) async {
    final newValue = int.tryParse(value);

    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt('intervalTimeMinute', newValue);

    await fetchNotificationsSettings();
  }
}

final notificationsSettingsProvider =
    StateNotifierProvider<NotificationsSettingsNotifier>(
        (ref) => NotificationsSettingsNotifier());
