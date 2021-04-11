import 'package:flutter/material.dart';

import '../common/routes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.local_drink),
              title: const Text('Hydration plan'),
              onTap: () async {
                await Navigator.pushNamed(context, hydrationPlanRoute);
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () async {
                await Navigator.pushNamed(context, notificationsSettingsRoute);
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.local_cafe),
              title: const Text('Cup'),
              onTap: () async {
                await Navigator.pushNamed(context, cupManagerRoute);
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Theme'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }
}
