import 'package:flutter/material.dart';

import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class Aquarium extends StatefulWidget {
  const Aquarium();

  @override
  _AquariumState createState() => _AquariumState();
}

class _AquariumState extends State<Aquarium> {
  // ignore: unused_field
  UnityWidgetController _unityWidgetController;

  @override
  Widget build(BuildContext context) {
    return UnityWidget(
      onUnityCreated: onUnityCreated,
    );
  }

  void onUnityCreated(controller) {
    _unityWidgetController = controller;
  }
}
