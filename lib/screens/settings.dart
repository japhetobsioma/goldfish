import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/routes.dart';
import '../providers/app_theme.dart';

class SettingsScreen extends HookWidget {
  const SettingsScreen();

  @override
  Widget build(BuildContext context) {
    final appTheme = useProvider(appThemeProvider);

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
              leading: const Icon(Icons.palette),
              title: const Text('Theme'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text('Change Application Theme'),
                      contentPadding: const EdgeInsets.fromLTRB(
                        24.0,
                        20.0,
                        24.0,
                        20.0,
                      ),
                      content: Wrap(
                        children: [
                          RadioListTile(
                            title: const Text('System settings'),
                            value: 0,
                            groupValue: appTheme.when(
                              data: (value) => value,
                              loading: () => 0,
                              error: (_, __) => 0,
                            ),
                            onChanged: (value) async {
                              await context
                                  .read(appThemeProvider.notifier)
                                  .updateAppTheme(value);

                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile(
                            title: const Text('Light'),
                            value: 1,
                            groupValue: appTheme.when(
                              data: (value) => value,
                              loading: () => 0,
                              error: (_, __) => 0,
                            ),
                            onChanged: (value) async {
                              await context
                                  .read(appThemeProvider.notifier)
                                  .updateAppTheme(value);
                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile(
                            title: const Text('Dark'),
                            value: 2,
                            groupValue: appTheme.when(
                              data: (value) => value,
                              loading: () => 0,
                              error: (_, __) => 0,
                            ),
                            onChanged: (value) async {
                              await context
                                  .read(appThemeProvider.notifier)
                                  .updateAppTheme(value);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
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
