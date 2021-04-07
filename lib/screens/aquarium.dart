import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class Aquarium extends HookWidget {
  const Aquarium();

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context).settings.arguments as Map;

    UnityWidgetController unityWidgetController;

    void addCoin(String waterAmount) {
      unityWidgetController.postMessage(
        'GameManager',
        'AddWaterLevel',
        waterAmount,
      );
    }

    void onUnityCreated(controller) {
      unityWidgetController = controller;
      addCoin(arguments['water']);
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: UnityWidget(
            onUnityCreated: onUnityCreated,
          ),
        ),
      ),
    );
  }
}
