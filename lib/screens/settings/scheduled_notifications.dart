import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/helpers.dart';
import '../../states/notifications_manager.dart';

class ScheduledNotificationsScreen extends HookWidget {
  const ScheduledNotificationsScreen();

  @override
  Widget build(BuildContext context) {
    final notificationManager = useProvider(notificationsManagerProvider.state);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const AddNotificationDialog(),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
        ],
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

                return Column(
                  children: [
                    NotificationItem(
                      hour: hour,
                      minute: minute,
                      time: time,
                      title: title,
                      body: body,
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
  });

  final int hour;
  final int minute;
  final TimeOfDay time;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.schedule),
      title: Text('${time.toText}'),
    );
  }
}

class AddNotificationDialog extends HookWidget {
  const AddNotificationDialog();

  @override
  Widget build(BuildContext context) {
    final time = useState(TimeOfDay.now());
    final timeTextController =
        useTextEditingController(text: '${time.value.toText}');
    final timeFormKey = useState(GlobalKey<FormState>());
    final isTimeCorrect = useState(false);
    final titleTextController = useTextEditingController(text: 'Example title');
    final titleFormKey = useState(GlobalKey<FormState>());
    final isTitleCorrect = useState(false);
    final bodyTextController = useTextEditingController(text: 'Example body');
    final bodyFormKey = useState(GlobalKey<FormState>());
    final isBodyCorrect = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Notification'),
        actions: isTitleCorrect.value &&
                isBodyCorrect.value &&
                isTimeCorrect.value
            ? [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () async {
                    if (isTitleCorrect.value &&
                        isBodyCorrect.value &&
                        isTimeCorrect.value) {
                      final time = timeTextController.text.toTimeOfDayFormatted;
                      final hour = time.hour;
                      final minute = time.minute;
                      final title = titleTextController.text;
                      final body = bodyTextController.text;

                      await context
                          .read(notificationsManagerProvider)
                          .insertSingleScheduledNotifications(
                            hour: hour,
                            minute: minute,
                            title: title,
                            body: body,
                          );
                      await context
                          .read(notificationsManagerProvider)
                          .setScheduledNotifications();

                      Navigator.pop(context);
                    }
                  },
                ),
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: null,
                ),
              ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Set time'),
              subtitle: Text(timeTextController.text),
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
                                  hintText: 'e.g. ${time.value.toText}.',
                                ),
                                validator: (wakeupTime) {
                                  if (wakeupTime.isEmpty) {
                                    isTimeCorrect.value = false;

                                    return 'Enter wake-up time';
                                  }

                                  if (wakeupTime.timeFormatIsNotValid) {
                                    isTimeCorrect.value = false;

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
                                    initialTime: TimeOfDay(hour: 8, minute: 30),
                                  );

                                  if (selectedTime != null) {
                                    time.value = selectedTime;
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
                          onPressed: () {
                            timeFormKey.value.currentState.validate();

                            if (timeFormKey.value.currentState.validate()) {
                              timeFormKey.value.currentState.validate();

                              isTimeCorrect.value = true;

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
              subtitle: Text(titleTextController.text),
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
                                  isTitleCorrect.value = false;

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
                          onPressed: () {
                            titleFormKey.value.currentState.validate();

                            if (titleFormKey.value.currentState.validate()) {
                              titleFormKey.value.currentState.validate();

                              isTitleCorrect.value = true;

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
              subtitle: Text(bodyTextController.text),
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
                                  isBodyCorrect.value = false;

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
                          onPressed: () {
                            bodyFormKey.value.currentState.validate();

                            if (bodyFormKey.value.currentState.validate()) {
                              bodyFormKey.value.currentState.validate();

                              isBodyCorrect.value = true;

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
