import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/colors.dart';
import '../common/helpers.dart';
import '../common/routes.dart';
import '../models/user_info.dart';
import '../states/completion.dart';
import '../states/create_plan.dart';

class CreatePlanScreen extends StatelessWidget {
  const CreatePlanScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ScreenHeading(),
                const GenderField(),
                const BirthdayField(),
                const WakeupTimeField(),
                const BedtimeField(),
                const DailyGoal(),
                const BottomButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenHeading extends StatelessWidget {
  const ScreenHeading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 37.0,
        top: 25.0,
        right: 37.0,
      ),
      child: const Text(
        'Create your hydration plan',
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
    );
  }
}

class GenderField extends HookWidget {
  const GenderField();

  @override
  Widget build(BuildContext context) {
    final selectedGender = useProvider(selectedGenderProvider);
    final isGenderNone = useProvider(isGenderNoneProvider);
    final isUsingRecommendedDailyGoal =
        useProvider(isUsingRecommendedDailyGoalProvider);

    return Padding(
      padding: const EdgeInsets.only(
        left: 37.0,
        top: 30.0,
        right: 37.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.0,
                color: isGenderNone
                    ? Theme.of(context).errorColor
                    : goldfishContainerBorderColor,
              ),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'GENDER',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                RadioListTile(
                  title: Text(Gender.Male.name),
                  value: Gender.Male,
                  groupValue: selectedGender,
                  onChanged: (value) {
                    context
                        .read(createPlanFormProvider.notifier)
                        .setGender(value);

                    isUsingRecommendedDailyGoal
                        ? context
                            .read(createPlanFormProvider.notifier)
                            .calculateDailyGoal()
                        : context
                            .read(createPlanFormProvider.notifier)
                            .setDailyGoal('0');
                  },
                ),
                RadioListTile(
                  title: Text(Gender.Female.name),
                  value: Gender.Female,
                  groupValue: selectedGender,
                  onChanged: (value) {
                    context
                        .read(createPlanFormProvider.notifier)
                        .setGender(value);

                    isUsingRecommendedDailyGoal
                        ? context
                            .read(createPlanFormProvider.notifier)
                            .calculateDailyGoal()
                        : context
                            .read(createPlanFormProvider.notifier)
                            .setDailyGoal('0');
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 3.0,
              left: 13.0,
            ),
            child: Visibility(
              visible: isGenderNone,
              child: Text(
                'Enter gender',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).errorColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BirthdayField extends HookWidget {
  const BirthdayField();

  @override
  Widget build(BuildContext context) {
    final birthdayFormKey = useProvider(birthdayFormKeyProvider);
    final birthdayTextController = useProvider(birthdayTextControllerProvider);
    final isUsingRecommendedDailyGoal =
        useProvider(isUsingRecommendedDailyGoalProvider);

    return Padding(
      padding: const EdgeInsets.only(
        left: 37.0,
        top: 15.0,
        right: 37.0,
      ),
      child: Container(
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Form(
              key: birthdayFormKey,
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: birthdayTextController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Birthday',
                  hintText: 'e.g. ${DateTime.now().toText}',
                ),
                onChanged: (_) {
                  isUsingRecommendedDailyGoal
                      ? context
                          .read(createPlanFormProvider.notifier)
                          .calculateDailyGoal()
                      : context
                          .read(createPlanFormProvider.notifier)
                          .setDailyGoal('0');
                },
                validator: (birthday) {
                  if (birthday.isEmpty) return 'Enter birthday';

                  if (birthday.dateFormatIsNotValid) {
                    return 'Invalid date format';
                  }

                  if (isBelowMinimumAge(birthday)) {
                    return 'Your age is below our minimum age (6 years old) '
                        'requirement';
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
                    initialDate: birthdayTextController.text.isEmpty ||
                            birthdayTextController.text.dateFormatIsNotValid ||
                            !DateTime(1905, 1, 1).isBefore(
                                birthdayTextController.text.toDateTimeFormatted)
                        ? DateTime.now()
                        : birthdayTextController.text.toDateTimeFormatted,
                    firstDate: DateTime(1905, 1, 1),
                    lastDate: DateTime.now(),
                    initialDatePickerMode: DatePickerMode.year,
                  );

                  if (selectedDate != null) {
                    birthdayTextController.text = selectedDate.toText;
                    context
                        .read(createPlanFormProvider.notifier)
                        .calculateDailyGoal();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WakeupTimeField extends HookWidget {
  const WakeupTimeField();

  @override
  Widget build(BuildContext context) {
    final wakeupTimeFormKey = useProvider(wakeupTimeFormKeyProvider);
    final wakeupTimeTextController =
        useProvider(wakeupTimeTextControllerProvider);

    return Padding(
      padding: const EdgeInsets.only(
        left: 37.0,
        top: 15.0,
        right: 37.0,
      ),
      child: Container(
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Form(
              key: wakeupTimeFormKey,
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: wakeupTimeTextController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Wake-up Time',
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
                    initialTime: wakeupTimeTextController.text.isEmpty ||
                            wakeupTimeTextController.text.timeFormatIsNotValid
                        ? TimeOfDay(hour: 8, minute: 30)
                        : wakeupTimeTextController.text.toTimeOfDayFormatted,
                  );

                  if (selectedTime != null) {
                    wakeupTimeTextController.text =
                        selectedTime.toFormattedTypeString;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BedtimeField extends HookWidget {
  const BedtimeField();

  @override
  Widget build(BuildContext context) {
    final bedtimeFormKey = useProvider(bedtimeFormKeyProvider);
    final bedtimeTextController = useProvider(bedtimeTextControllerProvider);

    return Padding(
      padding: const EdgeInsets.only(
        left: 37.0,
        top: 15.0,
        right: 37.0,
      ),
      child: Container(
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Form(
              key: bedtimeFormKey,
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: bedtimeTextController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
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
                    initialTime: bedtimeTextController.text.isEmpty ||
                            bedtimeTextController.text.timeFormatIsNotValid
                        ? TimeOfDay(hour: 22, minute: 30)
                        : bedtimeTextController.text.toTimeOfDayFormatted,
                  );

                  if (selectedTime != null) {
                    bedtimeTextController.text =
                        selectedTime.toFormattedTypeString;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DailyGoal extends HookWidget {
  const DailyGoal();

  @override
  Widget build(BuildContext context) {
    final dailyGoalFormKey = useProvider(dailyGoalFormKeyProvider);
    final dailyGoalTextController =
        useProvider(dailyGoalTextControllerProvider);
    final isUsingRecommendedDailyGoal =
        useProvider(isUsingRecommendedDailyGoalProvider);
    final brightness = Theme.of(context).brightness;
    final darkModeOn = brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(
        left: 37.0,
        top: 15.0,
        right: 37.0,
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[
                Form(
                  key: dailyGoalFormKey,
                  child: GestureDetector(
                    onTap: () {
                      if (isUsingRecommendedDailyGoal) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Cannot change this'),
                            content: const Text(
                              'You are currently using recommended daily goal, '
                              'in which it automatically calculate your daily '
                              'goal based on your age and gender. Unselect the '
                              'Use recommended daily goal check box to change '
                              'this.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('CLOSE'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: dailyGoalTextController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Daily Goal',
                        suffixText: 'ml/per day',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      enabled: !isUsingRecommendedDailyGoal,
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
                ),
              ],
            ),
            CheckboxListTile(
              title: const Text(
                'Use recommended daily goal',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
              value: isUsingRecommendedDailyGoal,
              activeColor: darkModeOn
                  ? Theme.of(context).accentColor
                  : Theme.of(context).primaryColor,
              checkColor: darkModeOn
                  ? Theme.of(context).colorScheme.onSecondary
                  : Theme.of(context).colorScheme.onPrimary,
              onChanged: (value) {
                context
                    .read(createPlanFormProvider.notifier)
                    .setUsingRecommendedDailyGoal(value);

                value
                    ? context
                        .read(createPlanFormProvider.notifier)
                        .calculateDailyGoal()
                    : context
                        .read(createPlanFormProvider.notifier)
                        .setDailyGoal('0');
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}

class BottomButtons extends HookWidget {
  const BottomButtons();

  @override
  Widget build(BuildContext context) {
    final selectedGender = useProvider(selectedGenderProvider);
    final birthdayFormKey = useProvider(birthdayFormKeyProvider);
    final wakeupTimeFormKey = useProvider(wakeupTimeFormKeyProvider);
    final bedtimeFormKey = useProvider(bedtimeFormKeyProvider);
    final dailyGoalFormKey = useProvider(dailyGoalFormKeyProvider);
    final brightness = Theme.of(context).brightness;
    final darkModeOn = brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(
        left: 37.0,
        right: 37.0,
        bottom: 25.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Theme.of(context).accentColor,
            ),
            onPressed: () {
              context.read(createPlanFormProvider.notifier).clearAllFields();
            },
            child: const Text('CLEAR'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: darkModeOn
                  ? Theme.of(context).accentColor
                  : Theme.of(context).primaryColor,
              onPrimary: darkModeOn
                  ? Theme.of(context).colorScheme.onSecondary
                  : Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () async {
              // Validate all the fields.
              if (selectedGender.isNone) {
                // Show an error message if the gender is none.
                context
                    .read(createPlanFormProvider.notifier)
                    .setGenderNone(true);
              } else {
                context
                    .read(createPlanFormProvider.notifier)
                    .setGenderNone(false);
              }

              birthdayFormKey.currentState.validate();
              wakeupTimeFormKey.currentState.validate();
              bedtimeFormKey.currentState.validate();
              dailyGoalFormKey.currentState.validate();

              // If all the fields are correct, set all the data to users'
              // information, then insert all the data from the user's data
              // into the application's database.
              if (selectedGender.isNotNone &&
                  birthdayFormKey.currentState.validate() &&
                  wakeupTimeFormKey.currentState.validate() &&
                  bedtimeFormKey.currentState.validate() &&
                  dailyGoalFormKey.currentState.validate()) {
                // Call validate again to remove the red lines if the user have
                // inputted wrong format then correct format.
                birthdayFormKey.currentState.validate();
                wakeupTimeFormKey.currentState.validate();
                bedtimeFormKey.currentState.validate();
                dailyGoalFormKey.currentState.validate();

                await context
                    .read(createPlanFormProvider.notifier)
                    .setUserInfo();

                final sharedPreferences = await SharedPreferences.getInstance();
                await sharedPreferences.setBool('isUserSignedUp', true);

                await context
                    .read(completionProvider.notifier)
                    .initializeCompletionDates();

                await Navigator.pushNamedAndRemoveUntil(
                  context,
                  homeRoute,
                  (route) => false,
                );
              }
            },
            child: const Text('SAVE PLAN'),
          ),
        ],
      ),
    );
  }
}
