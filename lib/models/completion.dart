import 'package:flutter/material.dart';

class Completion {
  const Completion({@required this.completionData})
      : assert(completionData != null);

  final List<Map<String, dynamic>> completionData;
}
