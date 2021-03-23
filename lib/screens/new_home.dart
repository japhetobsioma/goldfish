import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'aquarium.dart';

enum Screens {
  Home,
  Aquarium,
  History,
  Settings,
}

class NewHomeScreen extends HookWidget {
  const NewHomeScreen();

  @override
  Widget build(BuildContext context) {
    final navigationScreen = useState(Screens.Home);

    return Scaffold(
      body: () {
        switch (navigationScreen.value) {
          case Screens.Home:
            return Center(
              child: const Text('Home'),
            );
            break;
          case Screens.Aquarium:
            return Aquarium();
            break;
          case Screens.History:
            return Center(
              child: const Text('History'),
            );
            break;
          case Screens.Settings:
            return Center(
              child: const Text('Settings'),
            );
            break;
        }
      }(),
      appBar: () {
        switch (navigationScreen.value) {
          case Screens.Home:
            return null;
            break;
          case Screens.Aquarium:
            return AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => navigationScreen.value = Screens.Home,
              ),
              title: const Text('Aquarium'),
            );
            break;
          case Screens.History:
            return AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => navigationScreen.value = Screens.Home,
              ),
              title: const Text('History'),
            );
            break;
          case Screens.Settings:
            return AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => navigationScreen.value = Screens.Home,
              ),
              title: const Text('Settings'),
            );
            break;
        }
      }(),
      bottomNavigationBar: navigationScreen.value == Screens.Home
          ? BottomAppBar(
              shape: const CircularNotchedRectangle(),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Wrap(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.home),
                                title: const Text('Home'),
                                subtitle: const Text('Add water intake'),
                                selected: true,
                                onTap: () {
                                  navigationScreen.value = Screens.Home;
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.waves),
                                title: const Text('Aquarium'),
                                subtitle:
                                    const Text('Interact with your fishes'),
                                onTap: () {
                                  navigationScreen.value = Screens.Aquarium;
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.history),
                                title: const Text('History'),
                                subtitle:
                                    const Text('See your water intake history'),
                                onTap: () {
                                  navigationScreen.value = Screens.History;
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.settings),
                                title: const Text('Settings'),
                                subtitle: const Text('Change settings'),
                                onTap: () {
                                  navigationScreen.value = Screens.Settings;
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  Spacer(),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => MoreBottomSheet(),
                      );
                    },
                  ),
                ],
              ),
            )
          : null,
      floatingActionButton: navigationScreen.value == Screens.Home
          ? FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.local_drink),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class MoreBottomSheet extends HookWidget {
  const MoreBottomSheet();

  @override
  Widget build(BuildContext context) {
    final _quickAction = useState(true);

    return Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.cached),
          title: const Text('Change cup'),
          subtitle: const Text('200 ml'),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: const Icon(Icons.local_cafe),
          title: const Text('Change drink'),
          subtitle: const Text('Water'),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: const Icon(Icons.palette),
          title: const Text('Change color'),
          subtitle: const Text('Blue'),
          onTap: () => Navigator.pop(context),
        ),
        SwitchListTile(
          title: const Text('Quick add'),
          subtitle: const Text('Quickly insert new water intake'),
          secondary: const Icon(Icons.offline_bolt),
          value: _quickAction.value,
          onChanged: (bool value) => _quickAction.value = value,
        ),
      ],
    );
  }
}
