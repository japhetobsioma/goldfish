import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../models/createPlan.dart';

String dateToString(DateTime dateTime) {
  return DateFormat('d MMMM y').format(dateTime);
}

String timeToString(TimeOfDay timeOfDay, BuildContext context) {
  return timeOfDay.format(context);
}

String genderToString(Gender gender) => {
      Gender.male: 'Male',
      Gender.female: 'Female',
      Gender.none: 'None',
    }[gender];

String liquidMeasurementToString(LiquidMeasurement liquidMeasurement) => {
      LiquidMeasurement.ml: 'ml/per day',
      LiquidMeasurement.fl_oz: 'fl oz/per day',
    }[liquidMeasurement];
