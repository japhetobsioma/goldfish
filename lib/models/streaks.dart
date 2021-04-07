import 'package:flutter/material.dart';

class Streaks {
  const Streaks({
    @required this.currentStreaks,
    @required this.lastStreaks,
  })  : assert(currentStreaks != null),
        assert(lastStreaks != null);

  final int currentStreaks;
  final int lastStreaks;

  @override
  String toString() {
    return 'currentStreaks: $currentStreaks, lastStreaks: $lastStreaks';
  }
}
