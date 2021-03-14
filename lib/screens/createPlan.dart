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
                  },
                ),
                RadioListTile(
                  title: Text(genderToString(Gender.female)),
                  value: Gender.female,
                  groupValue: selectedGender,
                  onChanged: (value) {
                    context.read(createPlanProvider).setGender(value);
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
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter birthday';
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
                    wakeupTimeTextController.text =
                        timeToString(selectedTime, context);
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
                    bedtimeTextController.text =
                        timeToString(selectedTime, context);
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
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter daily goal';
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
                onSelected: (value) => context
                    .read(createPlanProvider)
                    .setLiquideMeasurement(value),
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
      padding: const EdgeInsets.symmetric(
        vertical: 25.0,
        horizontal: 37.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              context.read(createPlanProvider).clearCreatePlan();
            },
            child: const Text('Clear'),
          ),
          ElevatedButton(
            onPressed: () {
              if (genderToString(selectedGender) == 'None') {
                context.read(createPlanProvider).isGenderHasError(true);
              } else {
                context.read(createPlanProvider).isGenderHasError(false);
                print('Gender Field is filled up');
              }

              if (birthdayFormKey.currentState.validate()) {
                print('Birthday Field is filled up.');
              }

              if (wakeupTimeFormKey.currentState.validate()) {
                print('Wake-up time Field is filled up.');
              }

              if (bedtimeFormKey.currentState.validate()) {
                print('Bedtime Field is filled up.');
              }

              if (dailyGoalFormKey.currentState.validate()) {
                print('Daily goal Field is filled up.');
              }
            },
            child: const Text('Save Plan'),
          ),
        ],
      ),
    );
  }
}
