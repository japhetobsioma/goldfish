import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/helpers.dart';
import '../../models/notifications_settings.dart';
import '../../states/notifications_settings.dart';

class NotificationsSettingsScreens extends HookWidget {
  const NotificationsSettingsScreens();

  @override
  Widget build(BuildContext context) {
    final notificationsSettings =
        useProvider(notificationsSettingsProvider.state);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SwitchListTile(
              value: notificationsSettings.when(
                data: (value) => value.isNotificationTurnOn,
                loading: () => true,
                error: (_, __) => true,
              ),
              onChanged: (value) => context
                  .read(notificationsSettingsProvider)
                  .updateIsNotificationTurnOn(value),
              title: const Text('On'),
            ),
            const Divider(),
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
                          const Divider(),
                          value.notificationMode == NotificationMode.Interval
                              ? Column(
                                  children: [
                                    ListTile(
                                      title: const Text('Change interval'),
                                      subtitle: Text('${hour}h ${minute}m'),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) =>
                                              const ChangeIntervalDialog(),
                                        );
                                      },
                                    ),
                                    const Divider(),
                                  ],
                                )
                              : const SizedBox.shrink(),
                          ListTile(
                            title: const Text('Scheduled notifications'),
                            subtitle: Text(
                              value.notificationMode ==
                                      NotificationMode.Interval
                                  ? '10 active notification'
                                  : '0 active notification',
                            ),
                          ),
                          const Divider(),
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
        useProvider(notificationsSettingsProvider.state);

    return SimpleDialog(
      title: const Text('Select notification mode'),
      children: [
        notificationsSettings.when(
          data: (value) {
            return RadioListTile(
              title: const Text('Interval Mode'),
              value: NotificationMode.Interval,
              groupValue: value.notificationMode,
              onChanged: (value) {
                context
                    .read(notificationsSettingsProvider)
                    .updateNotificationMode(value);

                Navigator.pop(context);
              },
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        notificationsSettings.when(
          data: (value) {
            return RadioListTile(
              title: const Text('Custom Mode'),
              value: NotificationMode.Custom,
              groupValue: value.notificationMode,
              onChanged: (value) {
                context
                    .read(notificationsSettingsProvider)
                    .updateNotificationMode(value);

                Navigator.pop(context);
              },
            );
          },
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
        useProvider(notificationsSettingsProvider.state);
    final hourTextController = useTextEditingController();
    final hourFormKey = useState(GlobalKey<FormState>());
    final minuteTextController = useTextEditingController();
    final minuteFormKey = useState(GlobalKey<FormState>());

    return AlertDialog(
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
          onPressed: () {
            hourFormKey.value.currentState.validate();
            minuteFormKey.value.currentState.validate();

            if (hourFormKey.value.currentState.validate() &&
                minuteFormKey.value.currentState.validate()) {
              hourFormKey.value.currentState.validate();
              minuteFormKey.value.currentState.validate();

              context
                  .read(notificationsSettingsProvider)
                  .updateIntervalHour(hourTextController.text);

              context
                  .read(notificationsSettingsProvider)
                  .updateIntervalMinute(minuteTextController.text);

              Navigator.of(context).pop();
            }
          },
          child: Text('SAVE'),
        ),
      ],
    );
  }
}
