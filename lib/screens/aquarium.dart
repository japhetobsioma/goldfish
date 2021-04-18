import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:hardware_buttons/hardware_buttons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../states/intake_bank.dart';
import '../states/unity_loading.dart';

class Aquarium extends StatefulWidget {
  const Aquarium();

  @override
  _AquariumState createState() => _AquariumState();
}

class _AquariumState extends State<Aquarium> with WidgetsBindingObserver {
  UnityWidgetController _unityWidgetController;
  StreamSubscription<HomeButtonEvent> _homeButtonSubscription;
  StreamSubscription<LockButtonEvent> _lockButtonSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    /// If the user pressed the home button, pause the Unity app.
    ///
    /// This prevents the application from playing the music in the
    /// background.
    _homeButtonSubscription = homeButtonEvents.listen(
      (_) async => await _unityWidgetController.pause(),
    );

    /// If the user pressed the lock button, exit the application.
    ///
    /// This prevents the application from playing the music in the
    /// background.
    _lockButtonSubscription = lockButtonEvents.listen((_) => exit(0));
  }

  /// This will pause or resume the Unity application based on the current
  /// state of the application.
  ///
  /// Pause the Unity application when the application state is `paused` and
  /// `inactive`, resume when it is `resumed`, and unload when it is in a
  /// `detached` state.
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        await _unityWidgetController.resume();
        break;
      case AppLifecycleState.inactive:
        await _unityWidgetController.pause();
        break;
      case AppLifecycleState.paused:
        await _unityWidgetController.pause();
        break;
      case AppLifecycleState.detached:
        await _unityWidgetController.unload();
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _unityWidgetController.dispose();
    _homeButtonSubscription?.cancel();
    _lockButtonSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// This will get the data passed from the home screen to this screen.
    ///
    /// [_arguments] will be used to add water amount to the Unity app.
    final _arguments = ModalRoute.of(context).settings.arguments as Map;

    /// This will transfer water amount from the data passed on to this screen.
    void transferWaterAmount() async {
      await _unityWidgetController.postMessage(
        'GameManager',
        'AddWaterLevel',
        _arguments['water'],
      );

      await context
          .read(intakeBankProvider.notifier)
          .updateIntakeBank(value: 0, arithmeticOperator: '*');
    }

    void onUnityCreated(UnityWidgetController controller) async {
      _unityWidgetController = controller;
      await _unityWidgetController.resume();

      transferWaterAmount();
    }

    return WillPopScope(
      /// This will pause the Unity application if the user pressed the back
      /// button.
      ///
      /// This prevents the application from playing the music in the
      /// background while on the other screen.
      onWillPop: () async {
        await _unityWidgetController.pause();

        /// Set [isFirstTimeOpeningUnity] to `false` so that it will show the
        /// loading dialog one time only.
        context
            .read(unityLoadingProvider.notifier)
            .setIsFirstTimeOpeningUnity(false);

        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: UnityWidget(
              onUnityCreated: (controller) => onUnityCreated(controller),
            ),
          ),
        ),
      ),
    );
  }
}
