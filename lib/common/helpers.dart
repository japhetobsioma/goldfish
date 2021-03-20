import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/user_info.dart';

// ignore_for_file: unnecessary_this

const _datePattern = 'd MMMM y';
const _timePattern = 'jm';
const _minimumAge = 6;

extension DateTimeExtension on DateTime {
  /// Return a formatted date in the type of string.
  ///
  /// The default date pattern is `d MMMM y`.
  ///
  /// Output: `25 June 1997`
  String get toFormattedString => DateFormat(_datePattern).format(this);
}

extension StringExtension on String {
  /// Return a formatted date.
  ///
  /// The default date pattern is `d MMMM y`.
  ///
  /// Output: `25 June 1997`
  DateTime get toFormattedDate => DateFormat(_datePattern).parseStrict(this);

  /// Return a date in human-readable format.
  ///
  /// e.g. `1997-06-25 00:00:00.000`
  DateTime get toDate => DateTime.parse(this);

  /// Check if the date is in a valid format.
  bool get dateFormatIsValid {
    try {
      DateFormat(_datePattern).parseStrict(this);
    } on FormatException {
      return false;
    }

    return true;
  }

  /// Check if the date is not in a valid format.
  bool get dateFormatIsNotValid => !this.dateFormatIsValid;

  /// Return a formatted time.
  ///
  /// The default time pattern is `jm`.
  ///
  /// Output: `8:30 AM`
  TimeOfDay get toTime =>
      TimeOfDay.fromDateTime(DateFormat(_timePattern).parse(this));

  /// Check if the time is in a valid format.
  bool get timeFormatIsValid {
    try {
      DateFormat(_timePattern).parseStrict(this);
    } on FormatException {
      return false;
    }

    return true;
  }

  /// Check if the time is not in a valid format.
  bool get timeFormatIsNotValid => !this.timeFormatIsValid;

  /// Return a formatted date in type of string.
  ///
  /// The default date pattern is `d MMMM y`.
  ///
  /// Output: `25 June 1997`
  String get toStringDate {
    final dateTime = toDate;

    return DateFormat(_datePattern).format(dateTime);
  }

  /// Return a formatted time in type of string.
  ///
  /// The default date pattern is `jm`.
  ///
  /// Output: `8:30 AM`
  String get toStringTime {
    final dateTime = toDate;

    return DateFormat(_timePattern).format(dateTime);
  }

  /// Check if the string is equal to `0`.
  bool get isZero => this == '0' ? true : false;
}

extension TimeOfDayExtension on TimeOfDay {
  /// Return a formatted time in type of string.
  ///
  /// The default date pattern is `jm`.
  ///
  /// Output: `8:30 AM`
  String get toFormattedString {
    final dateNow = DateTime.now();
    final dateTime = DateTime(
      dateNow.year,
      dateNow.month,
      dateNow.day,
      hour,
      minute,
    );

    return DateFormat(_timePattern).format(dateTime);
  }

  /// Return a date in human-readable format.
  ///
  /// e.g. `1997-06-25 00:00:00.000`
  String get toDate {
    final dateNow = DateTime.now();
    final dateTime = DateTime(
      dateNow.year,
      dateNow.month,
      dateNow.day,
      hour,
      minute,
    );

    return dateTime.toString();
  }
}

extension GenderExtension on Gender {
  /// Return a string representation of this gender.
  String get name => describeEnum(this);

  /// Check if the string is equal to `None`.
  bool get isNone => this.name == 'None' ? true : false;

  /// Check if the string is not equal to `None`.
  bool get isNotNone => !this.isNone;
}

extension LiquidMeasurementExtension on LiquidMeasurement {
  /// Return a string representation of this liquid measurement.
  String get name => describeEnum(this);

  /// Return a string description of this liquid measurement.
  String get description => {
        LiquidMeasurement.Milliliter: 'ml/per day',
        LiquidMeasurement.FluidOunce: 'fl oz/per day'
      }[this];
}

extension BooleanExtension on bool {
  /// Return `1` if its `true`, otherwise `0`.
  int get toInt => this ? 1 : 0;
}

extension IntegerExtension on int {
  /// Return `true` if its `1`, otherwise `0`.
  bool get toBool => this == 1 ? true : false;
}

/// Return an age based on the given birthday.
int getAge(DateTime birthday) {
  final todaysDate = DateTime.now();
  var age = todaysDate.year - birthday.year;

  if (todaysDate.year < birthday.year) age--;

  return age;
}

/// Check if the age is below the minimum age.
///
/// Minimum age default value is `6`.
bool isBelowMinimumAge(String birthday) {
  final age = getAge(birthday.toFormattedDate);

  if (age >= _minimumAge) {
    return false;
  }

  return true;
}

bool isNotBelowMinimumAge(String birthday) => !isBelowMinimumAge(birthday);

/// Return a daily goal based on the given gender and age.
///
/// Reference: https://www.who.int/water_sanitation_health/dwq/nutwaterrequir.pdf
///
/// This automatically converts the water volume based on the given liquid
/// measurement.
int getDailyGoal(
  Gender gender,
  int age,
  LiquidMeasurement liquidMeasurement,
) {
  double dailyGoal;
  int convertedDailyGoal;

  switch (gender) {
    case Gender.Male:
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
    case Gender.Female:
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
    case Gender.None:
      break;
  }

  switch (liquidMeasurement) {
    case LiquidMeasurement.Milliliter:
      convertedDailyGoal = litersToMilliliters(dailyGoal);
      break;
    case LiquidMeasurement.FluidOunce:
      convertedDailyGoal = litersToFluidOunce(dailyGoal);
      break;
  }

  return convertedDailyGoal;
}

/// Convert liters to milliliters.
///
/// This uses the formula `liters * 1000`. This rounds off the result to get
/// the whole number. This was created because the documentation that we follow
/// to get the daily water goal is in liters.
int litersToMilliliters(double liters) => (liters * 1000).round();

/// Convert liters to fluid ounce.
///
/// This uses the formula 'liters * 33.814'. This rounds off the result to get
/// the whole number. This was created because the documentation that we follow
/// to get the daily water goal is in liters.
int litersToFluidOunce(double liters) => (liters * 33.814).round();

/// Convert milliliters to fluid ounce.
///
/// This use the formula `milliliters / 29.574`. This round off the result to
/// get whole number.
int millilitersToFluidOunce(double milliliters) =>
    (milliliters / 29.574).round();

/// Convert milliliters to fluid ounce.
///
/// This use the formula `fluid ounce / 29.574`. This round off the result to
/// get the whole number.
int fluidOunceToMilliliters(double fluidOunce) => (fluidOunce * 29.574).round();
