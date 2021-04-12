import 'package:android_power_manager/android_power_manager.dart';
import 'package:battery_optimization/battery_optimization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/helpers.dart';
import '../../common/routes.dart';
import '../../models/notification_settings.dart';
import '../../states/notifications_manager.dart';
import '../../states/notifications_settings.dart';

class NotificationSettingsScreen extends HookWidget {
  const NotificationSettingsScreen();

  @override
  Widget build(BuildContext context) {
    final notificationsSettings =
        useProvider(notificationSettingsProvider.state);
    final notificationManager = useProvider(notificationManagerProvider.state);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            notificationsSettings.when(
              data: (value) {
                final isIgnoringBatteryOptimizations =
                    value.isIgnoringBatteryOptimizations;

                if (isIgnoringBatteryOptimizations == false) {
                  return MaterialBanner(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      child: Icon(Icons.warning),
                    ),
                    content:
                        Text('Notifications may not be shown on your device'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (_) => const FixItDialog(),
                          );

                          await context
                              .read(notificationSettingsProvider)
                              .fetchNotificationSettings();
                        },
                        child: const Text('FIX IT'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (_) => const LearnMoreDialog(),
                          );
                        },
                        child: const Text('LEARN MORE'),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            SwitchListTile(
              value: notificationsSettings.when(
                data: (value) => value.isNotificationTurnOn,
                loading: () => true,
                error: (_, __) => true,
              ),
              onChanged: (value) async {
                await context
                    .read(notificationSettingsProvider)
                    .updateIsNotificationTurnOn(value);

                NotificationMode notificationMode;

                notificationsSettings.when(
                  data: (value) => notificationMode = value.notificationMode,
                  loading: () {},
                  error: (_, __) {},
                );

                if (value && notificationMode == NotificationMode.Custom) {
                  await context
                      .read(notificationManagerProvider)
                      .setAllScheduledNotifications();
                } else if (value == false &&
                    notificationMode == NotificationMode.Custom) {
                  await context
                      .read(notificationManagerProvider)
                      .cancelAllScheduledNotifications();
                }

                if (value && notificationMode == NotificationMode.Interval) {
                  await context
                      .read(notificationManagerProvider)
                      .generateScheduledNotifications();
                  await context
                      .read(notificationManagerProvider)
                      .setAllScheduledNotifications();
                } else if (value == false &&
                    notificationMode == NotificationMode.Interval) {
                  await context
                      .read(notificationManagerProvider)
                      .deleteAllScheduledNotifications();
                  await context
                      .read(notificationManagerProvider)
                      .cancelAllScheduledNotifications();
                }
              },
              title: const Text('On'),
            ),
            const Divider(height: 1),
            notificationsSettings.when(
              data: (value) {
                final hour = value.intervalTimeHour.toString();
                final minute = value.intervalTimeMinute.toString();

                return value.isNotificationTurnOn == true
                    ? Column(
                        children: [
                          ListTile(
                            title: const Text('Notification Mode'),
                            subtitle: Text(
                              '${value.notificationMode.name} mode',
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => const NotificationModeDialog(),
                              );
                            },
                          ),
                          const Divider(height: 1),
                          value.notificationMode == NotificationMode.Interval
                              ? Column(
                                  children: [
                                    ListTile(
                                      title: const Text('Change interval'),
                                      subtitle: Text('${hour}h ${minute}m'),
                                      onTap: () {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (_) =>
                                              const ChangeIntervalDialog(),
                                        );
                                      },
                                    ),
                                    const Divider(height: 1),
                                  ],
                                )
                              : const SizedBox.shrink(),
                          ListTile(
                            title: const Text('Scheduled notifications'),
                            subtitle: Text(
                              notificationManager.when(
                                data: (value) {
                                  final total =
                                      value.totalScheduledNotifications;
                                  return '$total active notifications';
                                },
                                loading: () => '',
                                error: (_, __) => '',
                              ),
                            ),
                            onTap: () => Navigator.pushNamed(
                              context,
                              scheduledNotificationRoute,
                            ),
                          ),
                          const Divider(height: 1),
                        ],
                      )
                    : const SizedBox.shrink();
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationModeDialog extends HookWidget {
  const NotificationModeDialog();

  @override
  Widget build(BuildContext context) {
    final notificationsSettings =
        useProvider(notificationSettingsProvider.state);

    return SimpleDialog(
      title: const Text('Select notification mode'),
      children: [
        notificationsSettings.when(
          data: (value) {
            return RadioListTile(
              title: const Text('Interval mode'),
              subtitle: const Text(
                'Generate notifications times based on the interval that you '
                'set. You can also add custom notifications times.',
              ),
              isThreeLine: true,
              value: NotificationMode.Interval,
              groupValue: value.notificationMode,
              onChanged: (value) async {
                await context
                    .read(notificationSettingsProvider)
                    .updateNotificationMode(value);

                await context
                    .read(notificationManagerProvider)
                    .deleteAllScheduledNotifications();

                await context
                    .read(notificationManagerProvider)
                    .cancelAllScheduledNotifications();

                await context
                    .read(notificationManagerProvider)
                    .generateScheduledNotifications();

                await context
                    .read(notificationManagerProvider)
                    .setAllScheduledNotifications();

                Navigator.pop(context);
              },
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        notificationsSettings.when(
          data: (value) => RadioListTile(
            title: const Text('Custom mode'),
            subtitle: const Text('Add your own custom notifications times.'),
            value: NotificationMode.Custom,
            groupValue: value.notificationMode,
            onChanged: (value) async {
              await context
                  .read(notificationSettingsProvider)
                  .updateNotificationMode(value);

              await context
                  .read(notificationManagerProvider)
                  .deleteAllScheduledNotifications();

              await context
                  .read(notificationManagerProvider)
                  .cancelAllScheduledNotifications();

              Navigator.pop(context);
            },
          ),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class ChangeIntervalDialog extends HookWidget {
  const ChangeIntervalDialog();

  @override
  Widget build(BuildContext context) {
    final notificationsSettings =
        useProvider(notificationSettingsProvider.state);
    final hourTextController = useTextEditingController();
    final hourFormKey = useState(GlobalKey<FormState>());
    final minuteTextController = useTextEditingController();
    final minuteFormKey = useState(GlobalKey<FormState>());

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
      title: const Text('Set interval time'),
      content: Wrap(
        children: [
          notificationsSettings.when(
            data: (value) {
              return Form(
                key: hourFormKey.value,
                child: TextFormField(
                  controller: hourTextController
                    ..text = value.intervalTimeHour.toString(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Hour',
                    hintText: 'e.g. 0..23',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter hour';
                    }

                    if (int.tryParse(value) > 23) {
                      return 'Invalid hour value';
                    }

                    return null;
                  },
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          notificationsSettings.when(
            data: (value) {
              return Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Form(
                  key: minuteFormKey.value,
                  child: TextFormField(
                    controller: minuteTextController
                      ..text = value.intervalTimeMinute.toString(),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Minute',
                      hintText: 'e.g. 0..59',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter minute';
                      }

                      if (int.tryParse(value) > 59) {
                        return 'Invalid minute number';
                      }

                      return null;
                    },
                  ),
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('CANCEL'),
        ),
        TextButton(
          onPressed: () async {
            hourFormKey.value.currentState.validate();
            minuteFormKey.value.currentState.validate();

            if (hourFormKey.value.currentState.validate() &&
                minuteFormKey.value.currentState.validate()) {
              hourFormKey.value.currentState.validate();
              minuteFormKey.value.currentState.validate();

              await context
                  .read(notificationSettingsProvider)
                  .updateIntervalHour(hourTextController.text);
              await context
                  .read(notificationSettingsProvider)
                  .updateIntervalMinute(minuteTextController.text);

              await context
                  .read(notificationManagerProvider)
                  .deleteAllScheduledNotifications();
              await context
                  .read(notificationManagerProvider)
                  .generateScheduledNotifications();
              await context
                  .read(notificationManagerProvider)
                  .setAllScheduledNotifications();

              Navigator.of(context).pop();
            }
          },
          child: Text('SAVE'),
        ),
      ],
    );
  }
}

class LearnMoreDialog extends StatelessWidget {
  const LearnMoreDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Why do notifications may not work?',
      ),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
      content: const Text(
        'Sometimes this application does not ring at the scheduled time, '
        'because of cleaner apps or phone system shut off this application '
        'notifications.\n\n'
        'If you have installed cleaner apps such as CM Security, please make '
        'sure that they do not stop this app from sending notifications.\n\n'
        'Some devices, specially Samsung, have strict power plans, the system '
        'will shut off this application after locking your screen. \n\n'
        'We suggest you add this application to the Unmonitored Apps list to '
        'avoid missing reminders.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('CLOSE'),
        ),
      ],
    );
  }
}

class FixItDialog extends StatelessWidget {
  const FixItDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'How to fix notifications?',
      ),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
      content: const Text(
        'You have two options to ring notification at the scheduled time: '
        'Accept the request to remove this app from battery optimization, or '
        'go to settings and remove this app from the list manually.',
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await AndroidPowerManager.requestIgnoreBatteryOptimizations();
          },
          child: const Text('SHOW REQUEST DIALOG'),
        ),
        TextButton(
          onPressed: () async {
            await BatteryOptimization.openBatteryOptimizationSettings();
          },
          child: const Text('GO TO SETTINGS'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
          child: const Text('CLOSE'),
        ),
      ],
    );
  }
}
