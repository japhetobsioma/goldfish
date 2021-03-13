import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/colors.dart';
import '../common/helpers.dart';
import '../common/strings.dart';

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
        top: 24,
        left: 37.0,
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

enum Gender { male, female }

class BuildGenderField extends StatefulWidget {
  const BuildGenderField({Key key}) : super(key: key);

  @override
  _BuildGenderFieldState createState() => _BuildGenderFieldState();
}

class _BuildGenderFieldState extends State<BuildGenderField> {
  Gender _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 37.0,
        right: 37.0,
        top: 35.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: goldfishContainerBorderColor,
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
              title: const Text('Male'),
              value: Gender.male,
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
            RadioListTile(
              title: const Text('Female'),
              value: Gender.female,
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

class BuildBirthdayField extends StatefulWidget {
  const BuildBirthdayField({Key key}) : super(key: key);

  @override
  _BuildBirthdayFieldState createState() => _BuildBirthdayFieldState();
}

class _BuildBirthdayFieldState extends State<BuildBirthdayField> {
  final _birthdayFormKey = GlobalKey<FormState>();
  final _birthdayTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 37.0,
        right: 37.0,
        top: 24.0,
      ),
      child: Container(
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            TextFormField(
              key: _birthdayFormKey,
              controller: _birthdayTextController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: birthdayLabel,
                hintText: 'Ex. ${dateToString(DateTime.now())}',
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
                    _birthdayTextController.text = dateToString(selectedDate);
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

class BuildWakeupTimeField extends StatefulWidget {
  const BuildWakeupTimeField({Key key}) : super(key: key);

  @override
  _BuildWakeupTimeFieldState createState() => _BuildWakeupTimeFieldState();
}

class _BuildWakeupTimeFieldState extends State<BuildWakeupTimeField> {
  final _wakeupTimeFormKey = GlobalKey<FormState>();
  final _wakeUpTimetextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 37.0,
        right: 37.0,
        top: 24.0,
      ),
      child: Container(
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            TextFormField(
              key: _wakeupTimeFormKey,
              controller: _wakeUpTimetextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: wakeupTimeLabel,
                hintText: wakeupTimeHint,
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
                    _wakeUpTimetextController.text =
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

class BuildBedtimeField extends StatefulWidget {
  const BuildBedtimeField({Key key}) : super(key: key);

  @override
  _BuildBedtimeFieldState createState() => _BuildBedtimeFieldState();
}

class _BuildBedtimeFieldState extends State<BuildBedtimeField> {
  final _bedtimeFormKey = GlobalKey<FormState>();
  final _bedtimeTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 37.0,
        right: 37.0,
        top: 24.0,
      ),
      child: Container(
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            TextFormField(
              key: _bedtimeFormKey,
              controller: _bedtimeTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: bedtimeLabel,
                hintText: bedtimeHint,
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
                    _bedtimeTextController.text =
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

enum LiquidMeasurement { ml, fl_oz }

class BuildDailyGoal extends StatefulWidget {
  const BuildDailyGoal({Key key}) : super(key: key);

  @override
  _BuildDailyGoalState createState() => _BuildDailyGoalState();
}

class _BuildDailyGoalState extends State<BuildDailyGoal> {
  final _dailyGoalformKey = GlobalKey<FormState>();
  final _dailyGoaltextController = TextEditingController();

  var _selectedLiquidMeasurement = LiquidMeasurement.ml;

  void setLiquidMeasurement(LiquidMeasurement value) {
    setState(() {
      _selectedLiquidMeasurement = value;
    });
  }

  String liquidMeasurementToString(LiquidMeasurement value) => {
        LiquidMeasurement.ml: milliliterPerDay,
        LiquidMeasurement.fl_oz: fluidOuncePerDay,
      }[value];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 37.0,
        right: 37.0,
        top: 24.0,
      ),
      child: Container(
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            TextFormField(
              key: _dailyGoalformKey,
              controller: _dailyGoaltextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Daily Goal',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            Positioned(
              right: 5.0,
              child: PopupMenuButton(
                padding: EdgeInsets.zero,
                initialValue: _selectedLiquidMeasurement,
                onSelected: (value) => setLiquidMeasurement(value),
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
                    liquidMeasurementToString(_selectedLiquidMeasurement),
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

class BuildBottomButtons extends StatelessWidget {
  const BuildBottomButtons();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 37.0,
        right: 37.0,
        top: 24.0,
        bottom: 24.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {},
            child: const Text('Clear'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Save Plan'),
          ),
        ],
      ),
    );
  }
}
