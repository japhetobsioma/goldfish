import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'water_intake.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
        ),
      ),
      body: WaterIntakeScreen(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => MenuBottomSheet(),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.local_drink),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class MenuBottomSheet extends StatelessWidget {
  const MenuBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          subtitle: const Text('Add water intake'),
          selected: true,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.waves),
          title: const Text('Aquarium'),
          subtitle: const Text('Interact with your fishes'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/aquarium');
          },
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('History'),
          subtitle: const Text('See your water intake history'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/history');
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          subtitle: const Text('Change settings'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/settings');
          },
        ),
      ],
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
