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
              title: const Text('Manage cups'),
              onTap: () async {
                await Navigator.pushNamed(context, cupManagerRoute);
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Aqua',
                  applicationVersion: 'v1.0',
                  applicationIcon: const Icon(Icons.local_drink),
                  children: [
                    const Text(
                      'Description',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'A Flutter application that can track user\'s water '
                      'intake.',
                    ),
                    const Text(
                      '\nAuthors',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Japhet Mert Catilo Obsioma (Dart, Flutter, SQLite)'
                      '\nShamsul Bin Majid (Unity, C#)',
                    ),
                    const Text(
                      '\nGitHub',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'github.com/japhetobsioma/goldfish',
                    ),
                  ],
                );
              },
            ),
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }
}
