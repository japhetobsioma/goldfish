import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void systemUIStyle({
  @required Color statusColor,
  @required Brightness statusBrightness,
  @required Color navigationColor,
  @required Color navigationDividerColor,
  @required Brightness navigationBrightness,
}) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: statusColor,
      statusBarIconBrightness: statusBrightness,
      systemNavigationBarColor: navigationColor,
      systemNavigationBarDividerColor: navigationDividerColor,
      systemNavigationBarIconBrightness: navigationBrightness,
    ),
  );
}
