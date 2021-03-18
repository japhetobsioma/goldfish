import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../models/createPlan.dart';

const _datePattern = 'd MMMM y';
const _timePattern = 'jm';
const _minimumAge = 6;

/// Return a string representing time of day based on given date.
///
/// The default time pattern is `jm`.
String dateToStingTime(DateTime date) {
  return DateFormat(_timePattern).format(date);
}

/// Return a string representing date based on given date.
///
/// The default date pattern is `d MMMM y`.
String dateToString(DateTime date) {
  return DateFormat(_datePattern).format(date);
}

/// Return a date based on given string representing date.
///
/// The default date pattern is `d MMMM y`.
DateTime stringToDate(String stringDate) {
  return DateFormat(_datePattern).parseStrict(stringDate);
}

/// Check if the string representing date is in valid format.
///
/// Return `true` if valid, otherwise `false`.
bool isDateFormatValid(String stringDate) {
  try {
    DateFormat(_datePattern).parseStrict(stringDate);
  } on FormatException {
    return false;
  }

  return true;
}

/// Return string representing time of day based on given time of day.
///
/// The default date pattern is `jm`.
String timeToString(TimeOfDay time) {
  final dateNow = DateTime.now();
  final date = DateTime(
    dateNow.year,
    dateNow.month,
    dateNow.day,
    time.hour,
    time.minute,
  );

  return DateFormat(_timePattern).format(date);
}

/// Return date based on given string representing time of day.
///
/// The default time patern is `jm`.
DateTime stringTimeToDate(String stringTime) {
  return DateFormat(_timePattern).parseStrict(stringTime);
}

/// Check if the string representing time of day is in valid format.
///
/// Return `true` if valid, otherwise `false`.
bool isTimeFormatValid(String timeOfDay) {
  try {
    DateFormat(_timePattern).parseStrict(timeOfDay);
  } on FormatException {
    return false;
  }

  return true;
}

/// Return age based on given birthday.
int getAge(DateTime birthday) {
  final todaysDate = DateTime.now();
  var age = todaysDate.year - birthday.year;

  if (todaysDate.year < birthday.year) age--;

  return age;
}

/// Checks if the age is within the minimum age.
///
/// Minimum age default value is `6`. Return `true` if its within the minimum
/// age, otherwise `false`.
bool isMinimumAge(String birthday) {
  final birthdayDateTime = stringToDate(birthday);
  final age = getAge(birthdayDateTime);

  if (age >= _minimumAge) {
    return true;
  }

  return false;
}

/// Return string representing gender based on given gender enum.
String genderToString(Gender gender) => {
      Gender.male: 'Male',
      Gender.female: 'Female',
      Gender.none: 'None',
    }[gender];

/// Return string representing liquid measurement based on given liquid
/// measurement enum.
String liquidMeasurementToString(LiquidMeasurement liquidMeasurement) => {
      LiquidMeasurement.ml: 'ml/per day',
      LiquidMeasurement.fl_oz: 'fl oz/per day',
    }[liquidMeasurement];

/// Return a daily goal based on given Gender, age.
///
/// Reference: https://www.who.int/water_sanitation_health/dwq/nutwaterrequir.pdf
///
/// This automatically converts the water volume based on given liquid
/// measurement.
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

/// Convert liters to milliliters.
///
/// This use the formula `liters * 1000`. This round off the result to get the
/// whole number. This was created because the documentation that we follow to
/// get the daily water goal is in liters.
int litersToMilliliters(double liters) {
  return (liters * 1000).round();
}

/// Convert liters to fluid ounce.
///
/// This use the formula `liters * 33.814`. This round off the result to the
/// whole number. This was created because the documentation that we follow
/// to get the daily water goal is in liters.
int litersToFluidOunce(double liters) {
  return (liters * 33.814).round();
}

/// Convert milliliters to fluid ounce.
///
/// This use the formula `milliliters / 29.574`. This round off the result to
/// get whole number.
int millilitersToFluidOunce(double milliliters) {
  return (milliliters / 29.574).round();
}

/// Convert milliliters to fluid ounce.
///
/// This use the formula `fluid ounce / 29.574`. This round off the result to
/// get the whole number.
int fluidOunceToMilliliters(double fluidOunce) {
  return (fluidOunce * 29.574).round();
}
