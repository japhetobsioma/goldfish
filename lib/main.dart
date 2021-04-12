import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/routes.dart';
import 'common/theme.dart';
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

  final sharedPreferences = await SharedPreferences.getInstance();
  final isUserSignedUp = sharedPreferences.getBool('isUserSignedUp') ?? false;

  runApp(
    ProviderScope(
      child: MyApp(isUserSignedUp: isUserSignedUp),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({@required this.isUserSignedUp}) : assert(isUserSignedUp != null);

  final bool isUserSignedUp;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Project goldfish',
      theme: goldfishTheme(),
      initialRoute: isUserSignedUp ? homeRoute : onboardingRoute,
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
    );
  }
}
