import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'home.dart';
import 'aquarium.dart';
import '../models/navigation_index.dart';

final _navigationIndexProvider =
    StateNotifierProvider((ref) => NavigationIndexNotifier());

class CentralScreen extends HookWidget {
  const CentralScreen();

  static const _itemLabels = ['Home', 'Aquarium', 'History', 'Settings'];

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _colorScheme = Theme.of(context).colorScheme;
    final _navigationIndexModel = useProvider(_navigationIndexProvider.state);
    final _availableScreens = [
      HomeScreen(),
      Aquarium(),
      Center(
        child: Text('History'),
      ),
      Center(
        child: Text('Settings'),
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      body: _availableScreens.elementAt(_navigationIndexModel.index),
      floatingActionButton:
          _navigationIndexModel.index == 0 ? ActionWidget() : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _navigationIndexModel.index,
        backgroundColor: _colorScheme.primary,
        selectedItemColor: _colorScheme.onPrimary,
        unselectedItemColor: _colorScheme.onPrimary.withOpacity(.75),
        selectedFontSize: 14,
        showUnselectedLabels: false,
        onTap: (value) {
          context.read(_navigationIndexProvider).selectIndex(value);
        },
        items: [
          BottomNavigationBarItem(
            label: _itemLabels[0],
            icon: const Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: _itemLabels[1],
            icon: const Icon(Icons.waves),
          ),
          BottomNavigationBarItem(
            label: _itemLabels[2],
            icon: const Icon(Icons.history),
          ),
          BottomNavigationBarItem(
            label: _itemLabels[3],
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}

class ActionWidget extends HookWidget {
  const ActionWidget();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.invert_colors,
      backgroundColor: colorScheme.secondary,
      foregroundColor: colorScheme.onSecondary,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.cached),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          onTap: () {},
          label: 'Change cup',
          labelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: colorScheme.onPrimary,
              fontSize: 16.0),
          labelBackgroundColor: colorScheme.primary,
        ),
        SpeedDialChild(
          child: Icon(Icons.local_drink),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          onTap: () {
            // context.read(waterIntakeProvider).addIntake();
          },
          label: 'Add intake',
          labelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: colorScheme.onPrimary,
              fontSize: 16.0),
          labelBackgroundColor: colorScheme.primary,
        ),
      ],
    );
  }
}
