import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../common/helpers.dart';
import '../states/completion.dart';
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
            const ChartDays(),
            const ChartDaysBottomTexts(),
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
        padding: const EdgeInsets.only(
          left: 10.0,
          top: 20.0,
          right: 10.0,
          bottom: 20.0,
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
  _SplineAreaData(this.year, this.intake);
  final double year;
  final double intake;
}

class ChartDays extends HookWidget {
  const ChartDays();

  @override
  Widget build(BuildContext context) {
    List<ChartSeries<_SplineAreaData, double>> _getSplieAreaSeries() {
      final chartData = <_SplineAreaData>[
        _SplineAreaData(012021, 5),
        _SplineAreaData(022021, 6),
        _SplineAreaData(032021, 3),
        _SplineAreaData(042021, 6),
        _SplineAreaData(052021, 8),
        _SplineAreaData(062021, 5),
        _SplineAreaData(072021, 6),
        _SplineAreaData(082021, 6),
        _SplineAreaData(092021, 6),
        _SplineAreaData(102021, 9),
        _SplineAreaData(112021, 9),
        _SplineAreaData(122021, 5),
      ];

      return <ChartSeries<_SplineAreaData, double>>[
        SplineAreaSeries<_SplineAreaData, double>(
          dataSource: chartData,
          color: const Color.fromRGBO(75, 135, 185, 0.15),
          borderColor: const Color.fromRGBO(75, 135, 185, 1),
          borderWidth: 8,
          xValueMapper: (_SplineAreaData data, _) => data.year,
          yValueMapper: (_SplineAreaData data, _) => data.intake,
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

class ChartDaysBottomTexts extends StatelessWidget {
  const ChartDaysBottomTexts();

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
                  '22 MAY 2019',
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
                child: Text(
                  '101 DAYS',
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
                  'TODAY',
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
