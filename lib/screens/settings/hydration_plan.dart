import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/helpers.dart';
import '../../models/notification_settings.dart';
import '../../models/user_info.dart';
import '../../states/hydration_plan.dart';
import '../../states/notifications_manager.dart';
import '../../states/notifications_settings.dart';

class HydrationPlanSettingsScreen extends HookWidget {
  const HydrationPlanSettingsScreen();

  @override
  Widget build(BuildContext context) {
    final hydrationPlan = useProvider(hydrationPlanProvider.state);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hydration Plan'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            hydrationPlan.when(
              data: (value) {
                final gender = value.gender.name;
                final birthday = value.birthday.toText;
                final wakeupTime = value.wakeupTime;
                final bedtime = value.bedtime;
                final dailyGoal = value.dailyGoal;

                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.wc),
                      title: const Text('Change gender'),
                      subtitle: Text(gender),
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (_) => const GenderDialog(),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.cake),
                      title: const Text('Change birthday'),
                      subtitle: Text(birthday),
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (_) => const BirthdayDialog(),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.wb_sunny),
                      title: const Text('Change wake-up time'),
                      subtitle: Text(wakeupTime.toFormattedTypeString),
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (_) => const WakeupTimeDialog(),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.nightlight_round),
                      title: const Text('Change bedtime'),
                      subtitle: Text(bedtime.toFormattedTypeString),
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (_) => const BedtimeDialog(),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.flag),
                      title: const Text('Change daily goal'),
                      subtitle: Text(dailyGoal.toString()),
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (_) => const DailyGoalDialog(),
                        );
                      },
                    ),
                    const Divider(),
                  ],
                );
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

class GenderDialog extends HookWidget {
  const GenderDialog();

  @override
  Widget build(BuildContext context) {
    final hydrationPlan = useProvider(hydrationPlanProvider.state);
    final selectedGender = useState(Gender.Male);

    useEffect(() {
      selectedGender.value = hydrationPlan.when(
        data: (value) => value.gender,
        loading: () => Gender.Male,
        error: (_, __) => Gender.Male,
      );
      return () {};
    }, []);

    return AlertDialog(
      title: const Text('Select a gender'),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
      content: Wrap(
        children: [
          RadioListTile(
            title: Text(Gender.Male.name),
            value: Gender.Male,
            groupValue: selectedGender.value,
            onChanged: (value) async {
              selectedGender.value = value;
            },
          ),
          RadioListTile(
            title: Text(Gender.Female.name),
            value: Gender.Female,
            groupValue: selectedGender.value,
            onChanged: (value) async {
              selectedGender.value = value;
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () async {
            await context
                .read(hydrationPlanProvider)
                .updateGender(selectedGender.value);

            bool useRecommendedGoal;
            hydrationPlan.when(
              data: (value) => useRecommendedGoal = value.useRecommendedGoal,
              loading: () {},
              error: (_, __) {},
            );

            if (useRecommendedGoal) {
              await context.read(hydrationPlanProvider).calculateDailyGoal();
            }

            Navigator.pop(context);
          },
          child: const Text('SAVE'),
        ),
      ],
    );
  }
}

class BirthdayDialog extends HookWidget {
  const BirthdayDialog();

  @override
  Widget build(BuildContext context) {
    final hydrationPlan = useProvider(hydrationPlanProvider.state);
    final birthdayKey = useState(GlobalKey<FormState>());
    final birthdayController = useTextEditingController();

    useEffect(() {
      birthdayController.text = hydrationPlan.when(
        data: (value) => value.birthday.toText,
        loading: () => '',
        error: (_, __) => '',
      );
      return () {};
    }, []);

    return AlertDialog(
      title: const Text('Enter birthday'),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
      content: Container(
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Form(
              key: birthdayKey.value,
              child: TextFormField(
                controller: birthdayController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Birthday',
                  hintText: 'e.g. ${DateTime.now().toText}.',
                ),
                validator: (birthday) {
                  if (birthday.isEmpty) {
                    return 'Enter birthday';
                  }

                  if (birthday.dateFormatIsNotValid) {
                    return 'Invalid date format';
                  }

                  if (isBelowMinimumAge(birthday)) {
                    return 'Your age is below our minimum age requirement';
                  }

                  return null;
                },
              ),
            ),
            Positioned(
              top: 5.0,
              child: IconButton(
                icon: const Icon(Icons.insert_invitation),
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1905, 1, 1),
                    lastDate: DateTime.now(),
                  );

                  if (selectedDate != null) {
                    birthdayController.text = selectedDate.toText;
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
            Navigator.pop(context);
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () async {
            birthdayKey.value.currentState.validate();

            if (birthdayKey.value.currentState.validate()) {
              birthdayKey.value.currentState.validate();

              await context
                  .read(hydrationPlanProvider)
                  .updatebirthday(birthdayController.text.toDateTimeFormatted);

              bool useRecommendedGoal;
              hydrationPlan.when(
                data: (value) => useRecommendedGoal = value.useRecommendedGoal,
                loading: () {},
                error: (_, __) {},
              );

              if (useRecommendedGoal) {
                await context.read(hydrationPlanProvider).calculateDailyGoal();
              }

              Navigator.pop(context);
            }
          },
          child: const Text('SAVE'),
        ),
      ],
    );
  }
}

class WakeupTimeDialog extends HookWidget {
  const WakeupTimeDialog();

  @override
  Widget build(BuildContext context) {
    final hydrationPlan = useProvider(hydrationPlanProvider.state);
    final notificationSettings = useProvider(
      notificationSettingsProvider.state,
    );
    final wakeupTimeKey = useState(GlobalKey<FormState>());
    final wakeupTimeController = useTextEditingController();

    useEffect(() {
      wakeupTimeController.text = hydrationPlan.when(
        data: (value) => value.wakeupTime.toText,
        loading: () => '',
        error: (_, __) => '',
      );
      return () {};
    }, []);

    return AlertDialog(
      title: const Text('Enter Wake-up time'),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
      content: Container(
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Form(
              key: wakeupTimeKey.value,
              child: TextFormField(
                controller: wakeupTimeController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Wake-up time',
                  hintText: 'e.g. 8:30 AM',
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
                    initialTime: TimeOfDay(hour: 8, minute: 30),
                  );

                  if (selectedTime != null) {
                    wakeupTimeController.text =
                        selectedTime.toFormattedTypeString;
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
            Navigator.pop(context);
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () async {
            wakeupTimeKey.value.currentState.validate();

            if (wakeupTimeKey.value.currentState.validate()) {
              wakeupTimeKey.value.currentState.validate();

              await context.read(hydrationPlanProvider).updateWakeupTime(
                  wakeupTimeController.text.toTimeOfDayFormatted);

              bool isNotificationTurnOn;
              NotificationMode notificationMode;
              notificationSettings.when(
                data: (value) {
                  isNotificationTurnOn = value.isNotificationTurnOn;
                  notificationMode = value.notificationMode;
                },
                loading: () {},
                error: (_, __) {},
              );

              if (notificationMode == NotificationMode.Interval &&
                  isNotificationTurnOn == true) {
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
              }

              Navigator.pop(context);
            }
          },
          child: const Text('SAVE'),
        ),
      ],
    );
  }
}

class BedtimeDialog extends HookWidget {
  const BedtimeDialog();

  @override
  Widget build(BuildContext context) {
    final hydrationPlan = useProvider(hydrationPlanProvider.state);
    final notificationSettings = useProvider(
      notificationSettingsProvider.state,
    );
    final bedtimeKey = useState(GlobalKey<FormState>());
    final bedtimeController = useTextEditingController();

    useEffect(() {
      bedtimeController.text = hydrationPlan.when(
        data: (value) => value.bedtime.toText,
        loading: () => '',
        error: (_, __) => '',
      );
      return () {};
    }, []);

    return AlertDialog(
      title: const Text('Enter Bedtime'),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
      content: Container(
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Form(
              key: bedtimeKey.value,
              child: TextFormField(
                controller: bedtimeController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Bedtime',
                  hintText: 'e.g. 10:30 PM',
                ),
                validator: (bedtime) {
                  if (bedtime.isEmpty) {
                    return 'Enter bedtime';
                  }

                  if (bedtime.timeFormatIsNotValid) {
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
                    initialTime: TimeOfDay(hour: 22, minute: 30),
                  );

                  if (selectedTime != null) {
                    bedtimeController.text = selectedTime.toFormattedTypeString;
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
            Navigator.pop(context);
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () async {
            bedtimeKey.value.currentState.validate();

            if (bedtimeKey.value.currentState.validate()) {
              bedtimeKey.value.currentState.validate();

              await context
                  .read(hydrationPlanProvider)
                  .updateBedtime(bedtimeController.text.toTimeOfDayFormatted);

              bool isNotificationTurnOn;
              NotificationMode notificationMode;
              notificationSettings.when(
                data: (value) {
                  isNotificationTurnOn = value.isNotificationTurnOn;
                  notificationMode = value.notificationMode;
                },
                loading: () {},
                error: (_, __) {},
              );

              if (notificationMode == NotificationMode.Interval &&
                  isNotificationTurnOn == true) {
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
              }

              Navigator.pop(context);
            }
          },
          child: const Text('SAVE'),
        ),
      ],
    );
  }
}

class DailyGoalDialog extends HookWidget {
  const DailyGoalDialog();

  @override
  Widget build(BuildContext context) {
    final hydrationPlan = useProvider(hydrationPlanProvider.state);
    final dailyGoalKey = useState(GlobalKey<FormState>());
    final dailyGoalController = useTextEditingController();
    final useRecommendedGoal = useState(true);

    useEffect(() {
      dailyGoalController.text = hydrationPlan.when(
        data: (value) => value.dailyGoal.toString(),
        loading: () => '',
        error: (_, __) => '',
      );
      useRecommendedGoal.value = hydrationPlan.when(
        data: (value) => value.useRecommendedGoal,
        loading: () => true,
        error: (_, __) => true,
      );
      return () {};
    }, []);

    return AlertDialog(
      title: const Text('Enter Daily Goal'),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
      content: Wrap(
        children: [
          Form(
            key: dailyGoalKey.value,
            child: TextFormField(
              controller: dailyGoalController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Daily Goal',
                hintText: 'e.g. 3000',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              enabled: !useRecommendedGoal.value,
              validator: (dailyGoal) {
                if (dailyGoal.isEmpty) {
                  return 'Enter daily goal';
                }

                if (dailyGoal.isZero) {
                  return 'Daily goal cannot be 0';
                }

                if (int.tryParse(dailyGoal) == null) {
                  return 'Invalid number format';
                }

                return null;
              },
            ),
          ),
          CheckboxListTile(
            title: const Text(
              'Use recommended daily goal',
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
            value: useRecommendedGoal.value,
            onChanged: (value) async {
              useRecommendedGoal.value = value;

              if (value) {
                final dailyGoal = await context
                    .read(hydrationPlanProvider)
                    .calculateDailyGoal();
                dailyGoalController.text = dailyGoal.toString();
              } else {
                dailyGoalController.text = '0';
              }
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () async {
            dailyGoalKey.value.currentState.validate();

            if (dailyGoalKey.value.currentState.validate()) {
              dailyGoalKey.value.currentState.validate();

              await context
                  .read(hydrationPlanProvider)
                  .updateDailyGoal(int.tryParse(dailyGoalController.text));

              await context
                  .read(hydrationPlanProvider)
                  .updateUseRecommendedGoal(useRecommendedGoal.value);

              Navigator.pop(context);
            }
          },
          child: const Text('SAVE'),
        ),
      ],
    );
  }
}