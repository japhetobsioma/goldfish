import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../models/createPlan.dart';

const datePattern = 'd MMMM y';
const timePattern = 'jm';
const minimumAge = 6;

String dateTimeToString(DateTime dateTime) {
  return DateFormat(datePattern).format(dateTime);
}

DateTime stringToDateTime(String value) {
  return DateFormat(datePattern).parseStrict(value);
}

bool isDateFormatValid(String dateTime) {
  try {
    DateFormat(datePattern).parseStrict(dateTime);
  } on FormatException {
    return false;
  }

  return true;
}

int getAge(DateTime birthday) {
  final todaysDate = DateTime.now();
  var age = todaysDate.year - birthday.year;

  if (todaysDate.year < birthday.year) age--;

  return age;
}

bool isMinimumAge(String birthday) {
  final birthdayDateTime = stringToDateTime(birthday);
  final age = getAge(birthdayDateTime);

  if (age >= minimumAge) {
    return true;
  }

  return false;
}

String timeOfDayToString(TimeOfDay timeOfDay, BuildContext context) {
  return timeOfDay.format(context);
}

bool isTimeFormatCorrect(String timeOfDay, BuildContext context) {
  try {
    DateFormat(timePattern).parseStrict(timeOfDay);
  } on FormatException {
    return false;
  }

  return true;
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

int getDailyGoal(
  Gender gender,
  int age,
  LiquidMeasurement liquidMeasurement,
) {
  double dailyGoal;
  int convertedDailyGoal;

  switch (gender) {
    case Gender.male:
      {
        if (age == 0) {
          dailyGoal = 0.8;
        } else if (age <= 3) {
          dailyGoal = 1.3;
        } else if (age <= 8) {
          dailyGoal = 1.7;
        } else if (age <= 13) {
          dailyGoal = 2.4;
        } else if (age <= 18) {
          dailyGoal = 3.3;
        } else if (age >= 19) {
          dailyGoal = 3.7;
        }
      }
      break;
    case Gender.female:
      if (age == 0) {
        dailyGoal = 0.8;
      } else if (age <= 3) {
        dailyGoal = 1.3;
      } else if (age <= 8) {
        dailyGoal = 1.7;
      } else if (age <= 13) {
        dailyGoal = 2.1;
      } else if (age <= 18) {
        dailyGoal = 2.3;
      } else if (age >= 19) {
        dailyGoal = 2.7;
      }
      break;
    case Gender.none:
      break;
  }

  switch (liquidMeasurement) {
    case LiquidMeasurement.ml:
      convertedDailyGoal = litersToMilliliters(dailyGoal);
      break;
    case LiquidMeasurement.fl_oz:
      convertedDailyGoal = litersToFluidOunce(dailyGoal);
      break;
  }

  return convertedDailyGoal;
}

int litersToMilliliters(double liters) {
  return (liters * 1000).round();
}

int litersToFluidOunce(double liters) {
  return (liters * 33.814).round();
}

int millilitersToFluidOunce(double milliliters) {
  return (milliliters / 29.574).round();
}

int fluidOunceToMilliliters(double fluidOunce) {
  return (fluidOunce * 29.574).round();
}
