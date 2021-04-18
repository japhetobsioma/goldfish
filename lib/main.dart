import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'common/routes.dart';
import 'providers/app_theme.dart';
import 'providers/user_status.dart';
import 'screens/aquarium.dart';
import 'screens/create_plan.dart';
import 'screens/history.dart';
import 'screens/home.dart';
import 'screens/onboarding.dart';
import 'screens/settings.dart';
import 'screens/settings/cup_manager.dart';
import 'screens/settings/hydration_plan.dart';
import 'screens/settings/notification.dart';
import 'screens/settings/scheduled_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends HookWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    final appTheme = useProvider(appThemeProvider);
    final isUserSignedUp = useProvider(userStatusProvider);

    return appTheme.when(
      data: (value) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Project goldfish',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.values[value],
        initialRoute: isUserSignedUp.when(
          data: (value) => value,
          loading: () => false,
          error: (_, __) => false,
        )
            ? homeRoute
            : onboardingRoute,
        routes: {
          onboardingRoute: (context) => const OnboardingScreen(),
          createPlanRoute: (context) => const CreatePlanScreen(),
          homeRoute: (context) => const HomeScreen(),
          aquariumRoute: (context) => const Aquarium(),
          historyRoute: (context) => const HistoryScreen(),
          settingsRoute: (context) => const SettingsScreen(),
          notificationsSettingsRoute: (context) =>
              const NotificationSettingsScreen(),
          scheduledNotificationRoute: (context) =>
              const ScheduledNotificationSettingsScreen(),
          hydrationPlanRoute: (context) => const HydrationPlanSettingsScreen(),
          cupManagerRoute: (context) => CupManagerScreen(),
        },
      ),
      loading: () => SizedBox.expand(
        child: Container(
          color: Colors.white,
        ),
      ),
      error: (_, __) => SizedBox.expand(
        child: Container(
          color: Colors.white,
        ),
      ),
    );
  }
}
