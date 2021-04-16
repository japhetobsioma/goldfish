import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../common/helpers.dart';
import '../models/daily_total.dart';
import '../states/completion.dart';
import '../states/daily_total.dart';
import '../states/drink_type.dart';
import '../states/streaks.dart';
import '../states/user_info.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return false;
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const ThisWeeksTitle(),
              const ThisWeeksCharts(),
              const Divider(
                indent: 30.0,
                endIndent: 30.0,
              ),
              const StreaksTitle(),
              const StreaksInfo(),
              const Divider(
                indent: 30.0,
                endIndent: 30.0,
              ),
              const TopDrinkTypes(),
            ],
          ),
        ),
      ),
    );
  }
}

class ThisWeeksTitle extends StatelessWidget {
  const ThisWeeksTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Text(
            'This Week'.toUpperCase(),
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class ThisWeeksCharts extends HookWidget {
  const ThisWeeksCharts();

  @override
  Widget build(BuildContext context) {
    final dailyTotal = useProvider(dailyTotalProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 30.0,
      ),
      child: Container(
        width: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: dailyTotal.when(
            data: (value) {
              final days = {
                WeekDays.Sunday: value.sundayTotal,
                WeekDays.Monday: value.mondayTotal,
                WeekDays.Tuesday: value.tuesdayTotal,
                WeekDays.Wednesday: value.wednesdayTotal,
                WeekDays.Thursday: value.thursdayTotal,
                WeekDays.Friday: value.fridayTotal,
                WeekDays.Saturday: value.saturdayTotal,
              };

              return days.entries.map((e) {
                return ThisWeeksLineGauge(
                  totalIntake: e.value,
                  dayName: e.key.name,
                );
              }).toList();
            },
            loading: () => const [SizedBox.shrink()],
            error: (_, __) => const [SizedBox.shrink()],
          ),
        ),
      ),
    );
  }
}

class ThisWeeksLineGauge extends HookWidget {
  const ThisWeeksLineGauge({
    @required this.totalIntake,
    @required this.dayName,
  });

  final int totalIntake;
  final String dayName;

  @override
  Widget build(BuildContext context) {
    final userInfo = useProvider(userInfoProvider);

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 30.0,
      ),
      child: Column(
        children: [
          Container(
            height: 150.0,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
              child: SfLinearGauge(
                maximum: userInfo.when(
                  data: (value) {
                    final maximum = value.userInfo[0]['dailyGoal'] ?? 100;
                    return maximum.toDouble();
                  },
                  loading: () => 100,
                  error: (_, __) => 100,
                ),
                orientation: LinearGaugeOrientation.vertical,
                interval: 20.0,
                showTicks: false,
                showLabels: false,
                minorTicksPerInterval: 0,
                axisTrackStyle: LinearAxisTrackStyle(
                  thickness: 20,
                  edgeStyle: LinearEdgeStyle.bothCurve,
                  borderWidth: 0,
                  borderColor: const Color.fromRGBO(75, 135, 185, 1),
                  color: const Color.fromRGBO(75, 135, 185, 0.15),
                ),
                barPointers: [
                  LinearBarPointer(
                    value: totalIntake.toDouble(),
                    thickness: 20,
                    edgeStyle: LinearEdgeStyle.startCurve,
                    color: Colors.blueAccent,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            '${dayName[0]}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class StreaksTitle extends StatelessWidget {
  const StreaksTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Text(
            'Streaks Info'.toUpperCase(),
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class StreaksInfo extends StatelessWidget {
  const StreaksInfo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30.0,
        bottom: 30.0,
      ),
      child: Container(
        width: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const BestStreaks(),
            const AllTime(),
            const Completions(),
          ],
        ),
      ),
    );
  }
}

class BestStreaks extends HookWidget {
  const BestStreaks();

  @override
  Widget build(BuildContext context) {
    final streaks = useProvider(streaksProvider);

    useEffect(() {
      context.read(streaksProvider.notifier).fetchStreaks();
      return () {};
    }, []);

    return Column(
      children: [
        Text(
          streaks.when(
            data: (value) {
              final streaks = value.lastStreaks;

              return streaks.toString();
            },
            loading: () => '',
            error: (_, __) => '',
          ),
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'BEST STREAK',
          style: TextStyle(
            fontSize: 10.0,
          ),
        ),
      ],
    );
  }
}

class AllTime extends HookWidget {
  const AllTime();

  @override
  Widget build(BuildContext context) {
    final completion = useProvider(completionProvider);

    useEffect(() {
      context.read(completionProvider.notifier).fetchCompletion();
      return () {};
    }, []);

    return Column(
      children: [
        Text(
          completion.when(
            data: (value) {
              final allTimeRatio = value.allTimeRatio;

              return "${allTimeRatio == 0 ? '0' : allTimeRatio.toString()}%";
            },
            loading: () => '',
            error: (_, __) => '',
          ),
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'ALL TIME',
          style: TextStyle(
            fontSize: 10.0,
          ),
        ),
      ],
    );
  }
}

class Completions extends HookWidget {
  const Completions();

  @override
  Widget build(BuildContext context) {
    final completion = useProvider(completionProvider);

    useEffect(() {
      context.read(completionProvider.notifier).fetchCompletion();
      return () {};
    }, []);

    return Column(
      children: [
        Text(
          completion.when(
            data: (value) {
              final totalCompletion = value.totalCompletion;

              return '${totalCompletion.toString()}';
            },
            loading: () => '',
            error: (_, __) => '',
          ),
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'COMPLETIONS',
          style: TextStyle(
            fontSize: 10.0,
          ),
        ),
      ],
    );
  }
}

class TopDrinkTypes extends StatelessWidget {
  const TopDrinkTypes();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const JoinedDate(),
          const MostDrinkTypes(),
        ],
      ),
    );
  }
}

class JoinedDate extends StatelessWidget {
  const JoinedDate();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Text(
        'Top Drink Type'.toUpperCase(),
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class MostDrinkTypes extends HookWidget {
  const MostDrinkTypes();

  @override
  Widget build(BuildContext context) {
    final drinkTypes = useProvider(drinkTypeProvider);

    useEffect(() {
      context.read(drinkTypeProvider.notifier).fetchDrinkType();
      return () {};
    }, []);

    return Padding(
        padding: EdgeInsets.only(
          left: 10.0,
          top: 20.0,
          right: 10.0,
          bottom: drinkTypes.when(
            data: (value) {
              final mostDrinkTypes = value.mostDrinkTypes;

              if (mostDrinkTypes.isEmpty) {
                return 0;
              }

              return 20.0;
            },
            loading: () => 0,
            error: (_, __) => 0,
          ),
        ),
        child: drinkTypes.when(
          data: (value) {
            final mostDrinkTypes = value.mostDrinkTypes;

            return Wrap(
              alignment: WrapAlignment.center,
              spacing: 10.0,
              children: mostDrinkTypes.map((e) {
                return ActionChip(
                  avatar: Icon((e['drinkTypes'] as String).toDrinkTypes.icon),
                  label: Text((e['drinkTypes'] as String).toSentenceCase),
                  onPressed: () {},
                );
              }).toList(),
            );
          },
          loading: () => SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ));
  }
}
