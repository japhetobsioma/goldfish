import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

String dateToString(DateTime dateTime) {
  return DateFormat('d MMMM y').format(dateTime);
}

String timeToString(TimeOfDay timeOfDay, BuildContext context) {
  return timeOfDay.format(context);
}
