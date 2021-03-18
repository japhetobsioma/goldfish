import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/createPlan.dart';
import '../states/createPlan.dart';
import '../common/colors.dart';
import '../common/helpers.dart';

class CreatePlanScreen extends HookWidget {
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
                const BuildScreenHeading(),
                const BuildGenderField(),
                const BuildBirthdayField(),
                const BuildWakeupTimeField(),
                const BuildBedtimeField(),
                const BuildDailyGoal(),
                const BuildBottomButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuildScreenHeading extends StatelessWidget {
  const BuildScreenHeading();

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
          color: goldfishHeading1Color,
        ),
      ),
    );
  }
}

class BuildGenderField extends HookWidget {
  const BuildGenderField();

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
                    color: goldfishContainerTextColor,
                  ),
                ),
                RadioListTile(
                  title: Text(genderToString(Gender.male)),
                  value: Gender.male,
                  groupValue: selectedGender,
                  onChanged: (value) {
                    context.read(createPlanProvider).setGender(value);

                    isUsingRecommendedDailyGoal
                        ? context.read(createPlanProvider).calculateDailyGoal()
                        : context.read(createPlanProvider).setDailyGoal('0');
                  },
                ),
                RadioListTile(
                  title: Text(genderToString(Gender.female)),
                  value: Gender.female,
                  groupValue: selectedGender,
                  onChanged: (value) {
                    context.read(createPlanProvider).setGender(value);

                    isUsingRecommendedDailyGoal
                        ? context.read(createPlanProvider).calculateDailyGoal()
                        : context.read(createPlanProvider).setDailyGoal('0');
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

class BuildBirthdayField extends HookWidget {
  const BuildBirthdayField();

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
                controller: birthdayTextController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Birthday',
                  hintText: 'e.g. ${dateToString(DateTime.now())}',
                ),
                onChanged: (_) {
                  isUsingRecommendedDailyGoal
                      ? context.read(createPlanProvider).calculateDailyGoal()
                      : context.read(createPlanProvider).setDailyGoal('0');
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter birthday';
                  }

                  if (!isDateFormatValid(value)) {
                    return 'Invalid date format';
                  }

                  if (!isMinimumAge(value)) {
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
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1905, 1, 1),
                    lastDate: DateTime.now(),
                  );

                  if (selectedDate != null) {
                    birthdayTextController.text = dateToString(selectedDate);
                    context.read(createPlanProvider).calculateDailyGoal();
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

class BuildWakeupTimeField extends HookWidget {
  const BuildWakeupTimeField();

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
                controller: wakeupTimeTextController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Wake-up Time',
                  hintText: 'e.g. 8:30 AM',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter wake-up time';
                  }

                  if (!isTimeFormatValid(value)) {
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
                    wakeupTimeTextController.text = timeToString(selectedTime);
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

class BuildBedtimeField extends HookWidget {
  const BuildBedtimeField();

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
                controller: bedtimeTextController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Bedtime',
                  hintText: 'e.g. 10:30 PM',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter bedtime';
                  }

                  if (!isTimeFormatValid(value)) {
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
                    initialTime: TimeOfDay(hour: 22, minute: 00),
                  );

                  if (selectedTime != null) {
                    bedtimeTextController.text = timeToString(selectedTime);
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

class BuildDailyGoal extends HookWidget {
  const BuildDailyGoal();

  @override
  Widget build(BuildContext context) {
    final dailyGoalFormKey = useProvider(dailyGoalFormKeyProvider);
    final dailyGoalTextController =
        useProvider(dailyGoalTextControllerProvider);
    final selectedLiquidMeasurement =
        useProvider(selectedLiquidMeasurementProvider);
    final isUsingRecommendedDailyGoal =
        useProvider(isUsingRecommendedDailyGoalProvider);

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
                  child: TextFormField(
                    controller: dailyGoalTextController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Daily Goal',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    enabled: !isUsingRecommendedDailyGoal,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter daily goal';
                      }

                      if (value == '0') {
                        return 'Daily goal cannot be 0';
                      }

                      if (int.tryParse(value) == null) {
                        return 'Invalid number format';
                      }

                      return null;
                    },
                  ),
                ),
                Positioned(
                  top: 10.0,
                  right: 5.0,
                  child: PopupMenuButton(
                    initialValue: selectedLiquidMeasurement,
                    onSelected: (value) {
                      context
                          .read(createPlanProvider)
                          .setLiquidMeasurement(value);

                      isUsingRecommendedDailyGoal
                          ? context
                              .read(createPlanProvider)
                              .calculateDailyGoal()
                          : context.read(createPlanProvider).convertDailyGoal();
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      const PopupMenuItem(
                        value: LiquidMeasurement.ml,
                        child: Text('milliliter'),
                      ),
                      const PopupMenuItem(
                        value: LiquidMeasurement.fl_oz,
                        child: Text('fluid ounce'),
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        liquidMeasurementToString(selectedLiquidMeasurement),
                        style: TextStyle(color: goldfishBlack),
                      ),
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
              onChanged: (value) {
                context
                    .read(createPlanProvider)
                    .setUsingRecommendedDailyGoal(value);

                value
                    ? context.read(createPlanProvider).calculateDailyGoal()
                    : context.read(createPlanProvider).setDailyGoal('0');
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

class BuildBottomButtons extends HookWidget {
  const BuildBottomButtons();

  @override
  Widget build(BuildContext context) {
    final selectedGender = useProvider(selectedGenderProvider);
    final birthdayFormKey = useProvider(birthdayFormKeyProvider);
    final wakeupTimeFormKey = useProvider(wakeupTimeFormKeyProvider);
    final bedtimeFormKey = useProvider(bedtimeFormKeyProvider);
    final dailyGoalFormKey = useProvider(dailyGoalFormKeyProvider);

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
            onPressed: () {
              context.read(createPlanProvider).clearAllFields();
            },
            child: const Text('Clear'),
          ),
          ElevatedButton(
            // Validate every fields, then insert all the data to database.
            onPressed: () {
              if (genderToString(selectedGender) == 'None') {
                context.read(createPlanProvider).setGenderNone(true);
              } else {
                context.read(createPlanProvider).setGenderNone(false);
              }

              birthdayFormKey.currentState.validate();
              wakeupTimeFormKey.currentState.validate();
              bedtimeFormKey.currentState.validate();
              dailyGoalFormKey.currentState.validate();

              if (genderToString(selectedGender) != 'None' &&
                  birthdayFormKey.currentState.validate() &&
                  wakeupTimeFormKey.currentState.validate() &&
                  bedtimeFormKey.currentState.validate() &&
                  dailyGoalFormKey.currentState.validate()) {
                context.read(createPlanProvider).deleteHydrationPlan();
                context.read(createPlanProvider).createHydrationPlan();
                context.read(createPlanProvider).printHydrationPlan();
              }
            },
            child: const Text('Save Plan'),
          ),
        ],
      ),
    );
  }
}
