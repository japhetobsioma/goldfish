import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/drink_type.dart';
import '../models/streaks.dart';
import '../models/tile_color.dart';
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

  TimeOfDay get toTimeOfDay => TimeOfDay.fromDateTime(this);
}

extension StringExtension on String {
  /// Return a formatted date.
  ///
  /// The default date pattern is `d MMMM y`.
  ///
  /// Output: `25 June 1997`
  DateTime get toDateTimeFormatted =>
      DateFormat(_datePattern).parseStrict(this);

  /// Return a date in human-readable format.
  ///
  /// e.g. `1997-06-25 00:00:00.000`
  DateTime get toDateTime => DateTime.parse(this);

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

  /// From String `8:30 AM` to TimeOfDay `TimeOfDay(08:30)`
  TimeOfDay get toTimeOfDay => TimeOfDay.fromDateTime(DateTime.parse(this));

  /// From String `8:30 AM` to TimeOfDay `8:30 AM`
  TimeOfDay get toTimeOfDayFormatted =>
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
  String get toDateTimeFormattedTypeString {
    final dateTime = toDateTime;

    return DateFormat(_datePattern).format(dateTime);
  }

  /// Return a formatted time in type of string.
  ///
  /// The default date pattern is `jm`.
  ///
  /// Output: `8:30 AM`
  String get toStringTime {
    final dateTime = toDateTime;

    return DateFormat(_timePattern).format(dateTime);
  }

  /// Check if the string is equal to `0`.
  bool get isZero => this == '0' ? true : false;

  DrinkTypes get toDrinkTypes => {
        'water': DrinkTypes.Water,
        'hot chocolate': DrinkTypes.HotChocolate,
        'coffee': DrinkTypes.Coffee,
        'lemonade': DrinkTypes.Lemonade,
        'iced tea': DrinkTypes.IcedTea,
        'juice': DrinkTypes.Juice,
        'milkshake': DrinkTypes.Milkshake,
        'tea': DrinkTypes.Tea,
        'milk': DrinkTypes.Milk,
        'beer': DrinkTypes.Beer,
        'soda': DrinkTypes.Soda,
        'wine': DrinkTypes.Wine,
        'liquor': DrinkTypes.Liquor,
      }[this];

  TileColors get toTileColors => {
        'default': TileColors.Default,
        'red': TileColors.Red,
        'orange': TileColors.Orange,
        'yellow': TileColors.Yellow,
        'green': TileColors.Green,
        'teal': TileColors.Teal,
        'blue': TileColors.Blue,
        'dark blue': TileColors.DarkBlue,
        'purple': TileColors.Purple,
        'pink': TileColors.Pink,
        'brown': TileColors.Brown,
        'grey': TileColors.Grey,
      }[this];

  /// Return a string in sentence case.
  ///
  /// ```dart
  /// 'alphabet'.toSentenceCase; // 'Alphabet'
  /// ```
  String get toSentenceCase {
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }

  /// Convert a String to LiquidMeasurement
  LiquidMeasurement get toLiquidMeasurement => {
        'ml': LiquidMeasurement.Milliliter,
        'fl oz': LiquidMeasurement.FluidOunce,
      }[this];

  Gender get toGender => {
        'male': Gender.Male,
        'female': Gender.Female,
      }[this];

  bool get toBool => {
        'true': true,
        'false': false,
      }[this];
}

extension TimeOfDayExtension on TimeOfDay {
  /// Return a formatted time in type of string.
  ///
  /// The default date pattern is `jm`.
  ///
  /// Output: `8:30 AM`
  String get toFormattedTypeString {
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
  String get toDateTimeTypeString {
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

  /// Convert TimeOfDay to DateTime
  DateTime get toDateTime {
    final dateNow = DateTime.now();

    return DateTime(
      dateNow.year,
      dateNow.month,
      dateNow.day,
      hour,
      minute,
    );
  }
}

extension GenderExtension on Gender {
  /// Return a string representation of this gender.
  String get name => describeEnum(this);

  String get nameLowerCase => describeEnum(this).toLowerCase();

  /// Check if the string is equal to `None`.
  bool get isNone => this.name == 'None' ? true : false;

  /// Check if the string is not equal to `None`.
  bool get isNotNone => !this.isNone;
}

extension LiquidMeasurementExtension on LiquidMeasurement {
  /// Return a string representation of this liquid measurement.
  String get name => describeEnum(this);

  /// Return a string description of this liquid measurement.
  String get descriptionPerDay => {
        LiquidMeasurement.Milliliter: 'ml/per day',
        LiquidMeasurement.FluidOunce: 'fl oz/per day'
      }[this];

  /// Return a String short description of this LiquidMeasurement
  String get description => {
        LiquidMeasurement.Milliliter: 'ml',
        LiquidMeasurement.FluidOunce: 'fl oz'
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
  final age = getAge(birthday.toDateTimeFormatted);

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

extension DrinkTypeExtension on DrinkTypes {
  /// Return a string representation of this drink type.
  String get name => describeEnum(this);

  /// Return a string description of this drink type.
  String get description => {
        DrinkTypes.Water: 'Water',
        DrinkTypes.HotChocolate: 'Hot chocolate',
        DrinkTypes.Coffee: 'Coffee',
        DrinkTypes.Lemonade: 'Lemonade',
        DrinkTypes.IcedTea: 'Iced tea',
        DrinkTypes.Juice: 'Juice',
        DrinkTypes.Milkshake: 'Milkshake',
        DrinkTypes.Tea: 'Tea',
        DrinkTypes.Milk: 'Milk',
        DrinkTypes.Beer: 'Beer',
        DrinkTypes.Soda: 'Soda',
        DrinkTypes.Wine: 'Wine',
        DrinkTypes.Liquor: 'Liquor',
      }[this];

  /// Return an Icon of this drink type.
  IconData get icon => {
        DrinkTypes.Water: Icons.local_cafe,
        DrinkTypes.HotChocolate: Icons.local_cafe,
        DrinkTypes.Coffee: Icons.local_cafe,
        DrinkTypes.Lemonade: Icons.local_cafe,
        DrinkTypes.IcedTea: Icons.local_cafe,
        DrinkTypes.Juice: Icons.local_cafe,
        DrinkTypes.Milkshake: Icons.local_cafe,
        DrinkTypes.Tea: Icons.emoji_food_beverage,
        DrinkTypes.Milk: Icons.local_cafe,
        DrinkTypes.Beer: Icons.sports_bar,
        DrinkTypes.Soda: Icons.fastfood,
        DrinkTypes.Wine: Icons.wine_bar,
        DrinkTypes.Liquor: Icons.liquor,
      }[this];
}

extension TileColorExtension on TileColors {
  /// Return a string representation of this liquid measurement.
  String get name => describeEnum(this);

  /// Return a string description of this tile color.
  String get description => {
        TileColors.Default: 'Default',
        TileColors.Red: 'Red',
        TileColors.Orange: 'Orange',
        TileColors.Yellow: 'Yellow',
        TileColors.Green: 'Green',
        TileColors.Teal: 'Teal',
        TileColors.Blue: 'Blue',
        TileColors.DarkBlue: 'Dark blue',
        TileColors.Purple: 'Purple',
        TileColors.Pink: 'Pink',
        TileColors.Brown: 'Brown',
        TileColors.Grey: 'Grey',
      }[this];

  /// Return a Color of this tile color.
  Color get color => {
        TileColors.Default: Colors.white,
        TileColors.Red: const Color(0xFFf28b82),
        TileColors.Orange: const Color(0xFFfbbc04),
        TileColors.Yellow: const Color(0xFFfff475),
        TileColors.Green: const Color(0xFFccff90),
        TileColors.Teal: const Color(0xFFa7ffeb),
        TileColors.Blue: const Color(0xFFcbf0f8),
        TileColors.DarkBlue: const Color(0xFFaecbfa),
        TileColors.Purple: const Color(0xFFd7aefb),
        TileColors.Pink: const Color(0xFFfdcfe8),
        TileColors.Brown: const Color(0xFFe6c9a8),
        TileColors.Grey: const Color(0xFFe8eaed),
      }[this];
}

/// Returns a time difference when subtracting `dateTime` from `now`.
///
/// Outputs: `Ns` for seconds, `Nm` for minutes, and `Nh` for hours,
/// where `N` is a number
String getTimeDifference(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 0) {
    return dateTime.toTimeOfDay.toFormattedTypeString;
  } else if (difference.inSeconds == 0) {
    return 'Now';
  } else if (difference.inSeconds < 60) {
    return '${difference.inSeconds.toString()}s';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes.toString()}m';
  } else {
    return '${difference.inHours.toString()}h';
  }
}

/// Return a Streaks object of this [completionData].
Streaks getStreaks(List<Map<String, dynamic>> completionData) {
  var currentStreaks = 0;
  var lastStreaks = 0;

  /// If the list has only 1 item, check the completion, then return the
  /// streaks result.
  if (completionData.length == 1) {
    /// 1 - true
    /// 0 - false
    if (completionData[0]['isCompleted'] == 1) {
      currentStreaks = 1;
      lastStreaks = currentStreaks;
    }
  } else {
    for (var index = 0; index < completionData.length; index++) {
      /// Check if this is the first item. On the next loop, this item will
      /// be compared to the current item.
      if (index == 0) {
        if (completionData[index]['isCompleted'] == 1) {
          currentStreaks = 1;
          lastStreaks = currentStreaks;
        }
      } else {
        /// Check the previous item and the current item. We compare them like
        /// this current item is today, and previous item is yesterday.
        if (completionData[index - 1]['isCompleted'] == 0 &&
            completionData[index]['isCompleted'] == 1) {
          currentStreaks += 1;
          lastStreaks = currentStreaks;
        } else if (completionData[index - 1]['isCompleted'] == 1 &&
            completionData[index]['isCompleted'] == 1) {
          currentStreaks += 1;
          lastStreaks = currentStreaks;
        } else if (completionData[index - 1]['isCompleted'] == 1 &&
            completionData[index]['isCompleted'] == 0) {
          lastStreaks = currentStreaks;
          currentStreaks = 0;
        }
      }
    }
  }

  return Streaks(
    currentStreaks: currentStreaks,
    lastStreaks: lastStreaks,
  );
}

/// Return the all time ratio of completed day since the joined date.
///
/// Completed day is when the user achieve the daily goal.
double getCompletionAllTimeRatio(List<Map<String, dynamic>> completionData) {
  var totalCompleted = 0.0;

  completionData.forEach((element) {
    /// 1 is true and 0 is false.
    if (element['isCompleted'] == 1) {
      totalCompleted += 1;
    }
  });

  return (totalCompleted / completionData.length) * 100;
}

int getTotalCompletion(List<Map<String, dynamic>> completionData) {
  var totalCompletion = 0;

  completionData.forEach((element) {
    /// 1 is true and 0 is false.
    if (element['isCompleted'] == 1) {
      totalCompletion += 1;
    }
  });

  return totalCompletion;
}

/// Return the total numbers of late dates from [completionDates].
///
/// Return 0 if the list is updated.
int getCompletionDayDifference(List<Map<String, dynamic>> completionDates) {
  final today = DateTime.now();
  final lastDate = (completionDates.last['currentDate'] as String).toDateTime;
  var dayDifference = 0;

  // Check if the last date of the list is not the same as today's date.
  if (lastDate != today) {
    final difference = today.difference(lastDate);
    dayDifference = difference.inDays;
  }

  return dayDifference;
}
