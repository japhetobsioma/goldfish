import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/helpers.dart';
import '../../common/routes.dart';
import '../../states/notifications_manager.dart';

class ScheduledNotificationsScreen extends HookWidget {
  const ScheduledNotificationsScreen();

  @override
  Widget build(BuildContext context) {
    final notificationManager = useProvider(notificationsManagerProvider.state);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Notifications'),
      ),
      body: Container(
        width: double.maxFinite,
        child: notificationManager.when(
          data: (value) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: value.allScheduledNotifications.length,
              itemBuilder: (_, index) {
                final hour =
                    value.allScheduledNotifications[index]['hour'] as int;
                final minute =
                    value.allScheduledNotifications[index]['minute'] as int;
                final time = TimeOfDay(hour: hour, minute: minute);
                final title =
                    value.allScheduledNotifications[index]['title'] as String;
                final body =
                    value.allScheduledNotifications[index]['body'] as String;
                final id = value.allScheduledNotifications[index]['id'] as int;

                return Column(
                  children: [
                    NotificationItem(
                      hour: hour,
                      minute: minute,
                      time: time,
                      title: title,
                      body: body,
                      id: id,
                    ),
                    const Divider(),
                  ],
                );
              },
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const AddNotificationDialog(),
              fullscreenDialog: true,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    @required this.hour,
    @required this.minute,
    @required this.time,
    @required this.title,
    @required this.body,
    @required this.id,
  });

  final int hour;
  final int minute;
  final TimeOfDay time;
  final String title;
  final String body;
  final int id;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.notifications_active),
      title: Text('${time.toText}'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => EditDeleteNotificationDialog(
              hour: hour,
              minute: minute,
              title: title,
              body: body,
              id: id,
            ),
            fullscreenDialog: true,
          ),
        );
      },
    );
  }
}

class EditDeleteNotificationDialog extends HookWidget {
  const EditDeleteNotificationDialog({
    @required this.hour,
    @required this.minute,
    @required this.title,
    @required this.body,
    @required this.id,
  });

  final int hour;
  final int minute;
  final String title;
  final String body;
  final int id;

  @override
  Widget build(BuildContext context) {
    final timeText = useState(TimeOfDay(hour: hour, minute: minute).toText);
    final timeTextController =
        useTextEditingController(text: '${timeText.value}');
    final timeFormKey = useState(GlobalKey<FormState>());
    final titleText = useState(title);
    final titleTextController = useTextEditingController(text: titleText.value);
    final titleFormKey = useState(GlobalKey<FormState>());
    final bodyText = useState(body);
    final bodyTextController = useTextEditingController(text: bodyText.value);
    final bodyFormKey = useState(GlobalKey<FormState>());

    useEffect(() {
      context.read(notificationsManagerProvider).fetchNotificationsManager();
      return () {};
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Notification'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: const Text('Delete this notification?'),
                    content: const Text(
                      'This will delete your selected notification',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CANCEL'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await context
                              .read(notificationsManagerProvider)
                              .deleteSingleScheduledNotifications(id);

                          await context
                              .read(notificationsManagerProvider)
                              .cancelSingleScheduledNotifications(id);

                          Navigator.popUntil(context,
                              ModalRoute.withName(scheduledNotificationRoute));
                        },
                        child: const Text('DELETE'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Set time'),
              subtitle: Text(timeText.value),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text('Set time'),
                      content: Container(
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Form(
                              key: timeFormKey.value,
                              child: TextFormField(
                                controller: timeTextController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Time',
                                  hintText: 'e.g. ${TimeOfDay.now().toText}.',
                                ),
                                validator: (wakeupTime) {
                                  if (wakeupTime.isEmpty) {
                                    return 'Enter wake-up time';
                                  }

                                  if (wakeupTime.timeFormatIsNotValid) {
                                    return 'Invalid time format';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            Positioned(
                              top: 5.0,
                              child: IconButton(
                                icon: const Icon(Icons.schedule),
                                onPressed: () async {
                                  final selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );

                                  if (selectedTime != null) {
                                    timeTextController.text =
                                        selectedTime.toText;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () async {
                            timeFormKey.value.currentState.validate();

                            if (timeFormKey.value.currentState.validate()) {
                              timeFormKey.value.currentState.validate();

                              timeText.value = timeTextController.text;

                              final time =
                                  timeTextController.text.toTimeOfDayFormatted;
                              final newHour = time.hour;
                              final newMinute = time.minute;

                              await context
                                  .read(notificationsManagerProvider)
                                  .updateScheduledNotificationsHourMinute(
                                    hour: newHour,
                                    minute: newMinute,
                                    id: id,
                                  );

                              await context
                                  .read(notificationsManagerProvider)
                                  .cancelSingleScheduledNotifications(id);

                              await context
                                  .read(notificationsManagerProvider)
                                  .setSingleScheduledNotifications(
                                    id: id,
                                    hour: hour,
                                    minute: minute,
                                    title: title,
                                    body: body,
                                  );

                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('SAVE'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.text_snippet),
              title: const Text('Set title'),
              subtitle: Text(titleText.value),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text('Set title'),
                      content: Wrap(
                        children: [
                          Form(
                            key: titleFormKey.value,
                            child: TextFormField(
                              controller: titleTextController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Title',
                                hintText: 'e.g. title.',
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter title';
                                }

                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () async {
                            titleFormKey.value.currentState.validate();

                            if (titleFormKey.value.currentState.validate()) {
                              titleFormKey.value.currentState.validate();

                              titleText.value = titleTextController.text;

                              await context
                                  .read(notificationsManagerProvider)
                                  .updateScheduledNotificationsTitle(
                                    title: titleTextController.text,
                                    id: id,
                                  );

                              await context
                                  .read(notificationsManagerProvider)
                                  .cancelSingleScheduledNotifications(id);

                              await context
                                  .read(notificationsManagerProvider)
                                  .setSingleScheduledNotifications(
                                    id: id,
                                    hour: hour,
                                    minute: minute,
                                    title: title,
                                    body: body,
                                  );

                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('SAVE'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.text_snippet),
              title: const Text('Set body'),
              subtitle: Text(bodyText.value),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text('Set body'),
                      content: Wrap(
                        children: [
                          Form(
                            key: bodyFormKey.value,
                            child: TextFormField(
                              controller: bodyTextController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Body',
                                hintText: 'e.g. body.',
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter body';
                                }

                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () async {
                            bodyFormKey.value.currentState.validate();

                            if (bodyFormKey.value.currentState.validate()) {
                              bodyFormKey.value.currentState.validate();

                              bodyText.value = bodyTextController.text;

                              await context
                                  .read(notificationsManagerProvider)
                                  .updateScheduledNotificationsBody(
                                    body: bodyTextController.text,
                                    id: id,
                                  );

                              await context
                                  .read(notificationsManagerProvider)
                                  .cancelSingleScheduledNotifications(id);

                              await context
                                  .read(notificationsManagerProvider)
                                  .setSingleScheduledNotifications(
                                    id: id,
                                    hour: hour,
                                    minute: minute,
                                    title: title,
                                    body: body,
                                  );

                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('SAVE'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

class AddNotificationDialog extends HookWidget {
  const AddNotificationDialog();

  @override
  Widget build(BuildContext context) {
    final timeTextController = useTextEditingController();
    final timeFormKey = useState(GlobalKey<FormState>());
    final titleTextController = useTextEditingController();
    final titleFormKey = useState(GlobalKey<FormState>());
    final bodyTextController = useTextEditingController();
    final bodyFormKey = useState(GlobalKey<FormState>());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Notification'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 20.0),
              child: Container(
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Form(
                      key: timeFormKey.value,
                      child: TextFormField(
                        controller: timeTextController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Time',
                          hintText: 'e.g. ${TimeOfDay.now().toText}',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter wake-up time';
                          }

                          if (value.timeFormatIsNotValid) {
                            return 'Invalid time format';
                          }

                          return null;
                        },
                      ),
                    ),
                    Positioned(
                      top: 5.0,
                      child: IconButton(
                        icon: const Icon(Icons.schedule),
                        onPressed: () async {
                          final selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (selectedTime != null) {
                            timeTextController.text = selectedTime.toText;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 20.0),
              child: Form(
                key: titleFormKey.value,
                child: TextFormField(
                  controller: titleTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                    hintText: 'e.g. title.',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter title';
                    }

                    return null;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 20.0),
              child: Form(
                key: bodyFormKey.value,
                child: TextFormField(
                  controller: bodyTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Body',
                    hintText: 'e.g. body.',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter body';
                    }

                    return null;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: ElevatedButton(
                onPressed: () async {
                  timeFormKey.value.currentState.validate();
                  titleFormKey.value.currentState.validate();
                  bodyFormKey.value.currentState.validate();

                  if (timeFormKey.value.currentState.validate() &&
                      titleFormKey.value.currentState.validate() &&
                      bodyFormKey.value.currentState.validate()) {
                    timeFormKey.value.currentState.validate();
                    titleFormKey.value.currentState.validate();
                    bodyFormKey.value.currentState.validate();

                    final time = timeTextController.text.toTimeOfDayFormatted;
                    final hour = time.hour;
                    final minute = time.minute;
                    final title = titleTextController.text;
                    final body = bodyTextController.text;

                    final id = await context
                        .read(notificationsManagerProvider)
                        .insertSingleScheduledNotifications(
                          hour: hour,
                          minute: minute,
                          title: title,
                          body: body,
                        );

                    await context
                        .read(notificationsManagerProvider)
                        .setSingleScheduledNotifications(
                          id: id,
                          hour: hour,
                          minute: minute,
                          title: title,
                          body: body,
                        );

                    Navigator.pop(context);
                  }
                },
                child: const Text('ADD NOTIFICATION'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
