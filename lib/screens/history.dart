import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../common/helpers.dart';
import '../models/daily_total.dart';
import '../states/completion.dart';
import '../states/daily_total.dart';
import '../states/drink_type.dart';
import '../states/streaks.dart';
import '../states/user_info.dart';
import '../states/water_intake.dart';

class HistoryScreen extends HookWidget {
  const HistoryScreen();

  @override
  Widget build(BuildContext context) {
    final userInfo = useProvider(userInfoProvider.state);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const TopDrinkTypes(),
            const Divider(
              indent: 30.0,
              endIndent: 30.0,
            ),
            const StreaksInfo(),
            const Divider(
              indent: 30.0,
              endIndent: 30.0,
            ),
            userInfo.when(
              data: (value) {
                final joinedDate =
                    (value.userInfo[0]['joinedDate'] as String).toDateTime;

                if (joinedDate == DateTime.now()) {
                  return Column(
                    children: [
                      const ChartDays(),
                      const ChartDaysBottomTexts(),
                      const Divider(
                        indent: 30.0,
                        endIndent: 30.0,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                    ],
                  );
                }

                return const SizedBox(
                  height: 0.0,
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const ChartHourlyTitle(),
            const ChartHourly(),
            const ChartHourlyBottomTexts(),
          ],
        ),
      ),
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

class JoinedDate extends HookWidget {
  const JoinedDate();

  @override
  Widget build(BuildContext context) {
    final userInfo = useProvider(userInfoProvider.state);

    return userInfo.when(
      data: (value) {
        final joinedDate = (value.userInfo[0]['joinedDate'] as String)
            .toDateTimeFormattedTypeString;

        return Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Text(
            'Since $joinedDate'.toUpperCase(),
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class MostDrinkTypes extends HookWidget {
  const MostDrinkTypes();

  @override
  Widget build(BuildContext context) {
    final drinkTypes = useProvider(drinkTypeProvider.state);

    useEffect(() {
      context.read(drinkTypeProvider).fetchDrinkType();
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
    final streaks = useProvider(streaksProvider.state);

    useEffect(() {
      context.read(streaksProvider).fetchStreaks();
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
    final completion = useProvider(completionProvider.state);

    useEffect(() {
      context.read(completionProvider).fetchCompletion();
      return () {};
    }, []);

    return Column(
      children: [
        Text(
          completion.when(
            data: (value) {
              final allTimeRatio = value.allTimeRatio;

              return '${allTimeRatio.toString()}%';
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
    final completion = useProvider(completionProvider.state);

    useEffect(() {
      context.read(completionProvider).fetchCompletion();
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

class _SplineAreaData {
  _SplineAreaData({this.year, this.amount});
  final double year;
  final double amount;
}

class ChartDays extends HookWidget {
  const ChartDays();

  @override
  Widget build(BuildContext context) {
    final waterIntake = useProvider(waterIntakeProvider.state);

    List<ChartSeries<_SplineAreaData, double>> _getSplieAreaSeries() {
      final chartData = <_SplineAreaData>[];

      return <ChartSeries<_SplineAreaData, double>>[
        SplineAreaSeries<_SplineAreaData, double>(
          dataSource: waterIntake.when(
            data: (value) {
              value.allWaterIntake.forEach((element) {
                final year = double.tryParse(
                    element["strftime('%d%m%Y', date)"] as String);
                final amount = (element['COUNT(amount)'] as int).toDouble();

                chartData.add(
                  _SplineAreaData(
                    year: year,
                    amount: amount,
                  ),
                );
              });

              return chartData;
            },
            loading: () => chartData,
            error: (_, __) => chartData,
          ),
          color: const Color.fromRGBO(75, 135, 185, 0.15),
          borderColor: const Color.fromRGBO(75, 135, 185, 1),
          borderWidth: 8,
          xValueMapper: (_SplineAreaData data, _) => data.year,
          yValueMapper: (_SplineAreaData data, _) => data.amount,
        ),
      ];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: Container(
        width: double.maxFinite,
        child: SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: NumericAxis(
            isVisible: false,
          ),
          primaryYAxis: NumericAxis(
            isVisible: false,
          ),
          series: _getSplieAreaSeries(),
        ),
      ),
    );
  }
}

class ChartDaysBottomTexts extends HookWidget {
  const ChartDaysBottomTexts();

  @override
  Widget build(BuildContext context) {
    final userInfo = useProvider(userInfoProvider.state);

    return Padding(
      padding: const EdgeInsets.only(
        left: 25.0,
        right: 25.0,
        bottom: 30.0,
      ),
      child: Container(
        width: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              userInfo.when(
                data: (value) {
                  final joinedDate = (value.userInfo[0]['joinedDate'] as String)
                      .toDateTimeFormattedTypeString;

                  return joinedDate.toUpperCase();
                },
                loading: () => '',
                error: (_, __) => '',
              ),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'TODAY',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IntakeWeek extends HookWidget {
  const IntakeWeek();

  @override
  Widget build(BuildContext context) {
    final dailyTotal = useProvider(dailyTotalProvider.state);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
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
                return LineGaugeDay(
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

class LineGaugeDay extends HookWidget {
  const LineGaugeDay({
    @required this.totalIntake,
    @required this.dayName,
  });

  final int totalIntake;
  final String dayName;

  @override
  Widget build(BuildContext context) {
    final userInfo = useProvider(userInfoProvider.state);

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

class ChartHourlyTitle extends StatelessWidget {
  const ChartHourlyTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 30.0,
          ),
          child: Text(
            'Today'.toUpperCase(),
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

class _HourlyData {
  _HourlyData({
    @required this.hour,
    @required this.amount,
  });
  final double hour;
  final double amount;
}

class ChartHourly extends HookWidget {
  const ChartHourly();

  @override
  Widget build(BuildContext context) {
    List<ChartSeries<_HourlyData, double>> _getSplieAreaSeries() {
      final chartData = <_HourlyData>[
        _HourlyData(hour: 0000, amount: (500.0 + 0)),
        _HourlyData(hour: 0100, amount: (500.0 + 0)),
        _HourlyData(hour: 0200, amount: (500.0 + 0)),
        _HourlyData(hour: 0300, amount: (500.0 + 0)),
        _HourlyData(hour: 0400, amount: (500.0 + 0)),
        _HourlyData(hour: 0500, amount: (500.0 + 0)),
        _HourlyData(hour: 0600, amount: (500.0 + 0)),
        _HourlyData(hour: 0700, amount: (500.0 + 0)),
        _HourlyData(hour: 0800, amount: (500.0 + 500)),
        _HourlyData(hour: 0900, amount: (500.0 + 200)),
        _HourlyData(hour: 1000, amount: (500.0 + 0)),
        _HourlyData(hour: 1100, amount: (500.0 + 400)),
        _HourlyData(hour: 1200, amount: (500.0 + 500)),
        _HourlyData(hour: 1300, amount: (500.0 + 0)),
        _HourlyData(hour: 1400, amount: (500.0 + 200)),
        _HourlyData(hour: 1500, amount: (500.0 + 200)),
        _HourlyData(hour: 1600, amount: (500.0 + 0)),
        _HourlyData(hour: 1700, amount: (500.0 + 0)),
        _HourlyData(hour: 1800, amount: (500.0 + 0)),
        _HourlyData(hour: 1900, amount: (500.0 + 500)),
        _HourlyData(hour: 2000, amount: (500.0 + 500)),
        _HourlyData(hour: 2100, amount: (500.0 + 0)),
        _HourlyData(hour: 2200, amount: (500.0 + 200)),
        _HourlyData(hour: 2300, amount: (500.0 + 0)),
        _HourlyData(hour: 2400, amount: (500.0 + 0)),
      ];

      return <ChartSeries<_HourlyData, double>>[
        SplineAreaSeries<_HourlyData, double>(
          dataSource: chartData,
          color: const Color.fromRGBO(75, 135, 185, 0.15),
          borderColor: const Color.fromRGBO(75, 135, 185, 1),
          borderWidth: 8,
          xValueMapper: (_HourlyData data, _) => data.hour,
          yValueMapper: (_HourlyData data, _) => data.amount,
        ),
      ];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: Container(
        width: double.maxFinite,
        child: SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: NumericAxis(
            isVisible: false,
          ),
          primaryYAxis: NumericAxis(
            isVisible: false,
          ),
          series: _getSplieAreaSeries(),
        ),
      ),
    );
  }
}

class ChartHourlyBottomTexts extends HookWidget {
  const ChartHourlyBottomTexts();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 25.0,
        right: 25.0,
        bottom: 30.0,
      ),
      child: Container(
        width: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 100.0,
              height: 15.0,
              child: FittedBox(
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Start of day',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
            Container(
              width: 100.0,
              height: 15.0,
              child: FittedBox(
                fit: BoxFit.contain,
                alignment: Alignment.center,
                child: Text(
                  'Noon',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
            Container(
              width: 100.0,
              height: 15.0,
              child: FittedBox(
                fit: BoxFit.contain,
                alignment: Alignment.centerRight,
                child: Text(
                  'End of day',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
