import 'package:flutter/material.dart';

class Completion {
  const Completion({
    @required this.allTimeRatio,
    @required this.totalCompletion,
  })  : assert(allTimeRatio != null),
        assert(totalCompletion != null);

  final double allTimeRatio;
  final int totalCompletion;
}
