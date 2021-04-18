import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../common/helpers.dart';
import '../common/routes.dart';
import '../models/cup.dart';
import '../models/drink_type.dart';
import '../models/tile_color.dart';
import '../models/water_intake.dart';
import '../providers/goal_tips_banner.dart';
import '../states/animated_key.dart';
import '../states/cup.dart';
import '../states/drink_type.dart';
import '../states/edit_intake.dart';
import '../states/tile_color.dart';
import '../states/user_info.dart';
import '../states/water_intake.dart';

class WaterIntakeScreen extends HookWidget {
  const WaterIntakeScreen();

  @override
  Widget build(BuildContext context) {
    final goalTipsBanner = useProvider(goalTipsBannerProvider);

    return RefreshIndicator(
      onRefresh: () =>
          context.read(waterIntakeProvider.notifier).fetchWaterIntake(),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return false;
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              goalTipsBanner.when(
                data: (value) {
                  if (value) {
                    return MaterialBanner(
                      forceActionsBelow: true,
                      leading: const CircleAvatar(
                        child: Icon(Icons.lightbulb),
                      ),
                      content: const Text(
                        'Achieve your today\'s goal to put your water intake '
                        'into your virtual aquarium.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            await context
                                .read(goalTipsBannerProvider.notifier)
                                .setGoalTipsBanner(false);
                          },
                          child: const Text('Hide'),
                        ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
                loading: () => const SizedBox.shrink(),
                error: (error, stackTrace) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 30.0),
              const WaterIntakeGauge(),
              const WaterIntakeLists(),
              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}

class WaterIntakeGauge extends HookWidget {
  const WaterIntakeGauge();

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final darkModeOn = brightness == Brightness.dark;
    final waterIntake = useProvider(waterIntakeProvider);
    final userInfo = useProvider(userInfoProvider);

    return Container(
      child: SfRadialGauge(
        enableLoadingAnimation: true,
        axes: [
          RadialAxis(
            minimum: 0,
            maximum: userInfo.when(
              data: (value) {
                final maximum = value.userInfo[0]['dailyGoal'] ?? 100;
                return maximum.toDouble();
              },
              loading: () => 100,
              error: (error, stackTrace) {
                print('error: $error');
                print('stackTrace: $stackTrace');

                return 100;
              },
            ),
            showTicks: false,
            showLabels: false,
            axisLineStyle: AxisLineStyle(
              thickness: 25.0,
              color: Theme.of(context).chipTheme.backgroundColor,
            ),
            pointers: [
              RangePointer(
                value: waterIntake.when(
                  data: (value) {
                    final total = value.todaysTotalIntakes ?? 0;
                    return total.toDouble();
                  },
                  loading: () => 0,
                  error: (error, stackTrace) {
                    print('error: $error');
                    print('stackTrace: $stackTrace');

                    return 0;
                  },
                ),
                width: 25.0,
                color: darkModeOn
                    ? Theme.of(context).accentColor
                    : Theme.of(context).primaryColor,
                enableAnimation: true,
              ),
            ],
            annotations: [
              GaugeAnnotation(
                angle: 90,
                axisValue: 5,
                positionFactor: 0.1,
                widget: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                    children: [
                      TextSpan(
                        text: waterIntake.when(
                          data: (value) {
                            final total = value.todaysTotalIntakes ?? 0;
                            return total.toString();
                          },
                          loading: () => '',
                          error: (error, stackTrace) {
                            print('error: $error');
                            print('stackTrace: $stackTrace');

                            return '';
                          },
                        ),
                        style: TextStyle(
                          color: darkModeOn
                              ? Theme.of(context).accentColor
                              : Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0,
                        ),
                      ),
                      TextSpan(
                        text: userInfo.when(
                          data: (value) {
                            final amount = value.userInfo[0]['dailyGoal'] ?? 0;
                            final measurement =
                                value.userInfo[0]['liquidMeasurement'] ?? 'ml';
                            return ' / $amount $measurement';
                          },
                          loading: () => '/ 0 ml',
                          error: (error, stackTrace) {
                            print('error: $error');
                            print('stackTrace: $stackTrace');

                            return '/ 0 ml';
                          },
                        ),
                        style: TextStyle(
                          color: darkModeOn ? Colors.white : Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WaterIntakeLists extends HookWidget {
  const WaterIntakeLists();

  @override
  Widget build(BuildContext context) {
    final waterIntake = useProvider(waterIntakeProvider);
    final animatedList = useProvider(animatedListKeyProvider);

    return waterIntake.when(
      data: (value) {
        return Container(
          child: value.todaysIntakes.isNotEmpty
              ? NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (notification) {
                    notification.disallowGlow();
                    return false;
                  },
                  child: AnimatedList(
                    key: animatedList.key,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    initialItemCount: value.todaysIntakes.length,
                    itemBuilder: (context, index, animation) {
                      final String getDrinkTypes =
                          value.todaysIntakes[index]['drinkTypes'];
                      final drinkTypes = getDrinkTypes.toDrinkTypes;
                      final String getTileColors =
                          value.todaysIntakes[index]['tileColors'];
                      final tileColors = getTileColors.toTileColors;
                      final String getDate = value.todaysIntakes[index]['date'];
                      final date = getDate.toDateTime;
                      final timeDifference = getTimeDifference(date);

                      return WaterIntakeItem(
                        tileColors: tileColors,
                        drinkTypes: drinkTypes,
                        date: date,
                        timeDifference: timeDifference,
                        animation: animation,
                        value: value,
                        index: index,
                      );
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 1.0,
                  ),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        'Start drinking water',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) {
        print('error: $error');
        print('stackTrace: $stackTrace');

        return const SizedBox.shrink();
      },
    );
  }
}

class WaterIntakeItem extends StatelessWidget {
  const WaterIntakeItem({
    this.tileColors,
    this.drinkTypes,
    this.date,
    this.timeDifference,
    this.animation,
    this.value,
    this.index,
  });

  final TileColors tileColors;
  final DrinkTypes drinkTypes;
  final DateTime date;
  final String timeDifference;
  final Animation<double> animation;
  final WaterIntake value;
  final int index;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final darkModeOn = brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 1.0,
      ),
      child: SizeTransition(
        sizeFactor: animation,
        child: Card(
          color: tileColors.color == Colors.white && darkModeOn
              ? Theme.of(context).chipTheme.backgroundColor
              : tileColors.color,
          child: ListTile(
            leading: tileColors.color == Colors.white
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: tileColors.color == Colors.white && darkModeOn
                            ? Theme.of(context).chipTheme.backgroundColor
                            : const Color(0xFFe0e0e0),
                        width: 1.0,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor:
                          tileColors.color == Colors.white && darkModeOn
                              ? Theme.of(context).chipTheme.backgroundColor
                              : tileColors.color,
                      child: Icon(
                        drinkTypes.icon,
                        color: const Color(0xFF202124),
                      ),
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: const Color(0x14000000),
                    child: Icon(
                      drinkTypes.icon,
                      color: const Color(0xFF202124),
                    ),
                  ),
            title: Text(
              '${value.todaysIntakes[index]['amount']} '
              '${value.todaysIntakes[index]['measurement']} ',
              style: TextStyle(
                color: const Color(0xFF202124),
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            subtitle: Text(
              '${drinkTypes.description} · $timeDifference',
              style: TextStyle(
                color: const Color(0xFF202124),
              ),
            ),
            onTap: () {
              final String measurementString =
                  value.todaysIntakes[index]['measurement'];
              final measurement = measurementString.toLiquidMeasurement;

              context.read(editIntakeProvider.notifier).setEditIntake(
                    waterIntakeID: value.todaysIntakes[index]['waterIntakeID'],
                    amount: value.todaysIntakes[index]['amount'],
                    measurement: measurement,
                    date: date.toTimeOfDay,
                    drinkTypes: drinkTypes,
                    tileColors: tileColors,
                    index: index,
                  );

              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const WaterIntakeDialog(),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class WaterIntakeDialog extends HookWidget {
  const WaterIntakeDialog();

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final darkModeOn = brightness == Brightness.dark;
    final tileColors = useProvider(editTileColorsProvider);
    final amount = useProvider(editAmountProvider);
    final measurement = useProvider(editMeasurementProvider);
    final drinkTypes = useProvider(editDrinkTypesProvider);
    final date = useProvider(editDateProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: darkModeOn && tileColors.color == Colors.white
              ? Colors.white
              : const Color(0xFF202124),
        ),
        backgroundColor: tileColors.color == Colors.white && darkModeOn
            ? Theme.of(context).chipTheme.backgroundColor
            : tileColors.color,
        title: Text(
          'Edit intake information',
          style: TextStyle(
            color: darkModeOn && tileColors.color == Colors.white
                ? Colors.white
                : Color(0xFF202124),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const DeleteWaterIntakeDialog(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.cached),
              title: const Text('Change cup'),
              subtitle: Text(
                '$amount ${measurement.description}',
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const EditCupDialog(),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_cafe),
              title: const Text('Change drink'),
              subtitle: Text(drinkTypes.description),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const EditDrinkTypeDialog(),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Change color'),
              subtitle: Text(tileColors.description.toSentenceCase),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const EditTileColorDialog(),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Change time'),
              subtitle: Text(date.toFormattedTypeString),
              onTap: () async {
                final selectedTime = await showTimePicker(
                  helpText: 'Select a time',
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (selectedTime != null) {
                  context
                      .read(editIntakeProvider.notifier)
                      .setSelectedDate(date: selectedTime);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteWaterIntakeDialog extends HookWidget {
  const DeleteWaterIntakeDialog();

  @override
  Widget build(BuildContext context) {
    final animatedList = useProvider(animatedListKeyProvider);
    final waterIntake = useProvider(waterIntakeProvider);
    final index = useProvider(editIndexProvider);

    return AlertDialog(
      title: const Text('Delete this intake?'),
      content: const Text(
        'This will delete your selected intake information.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('CANCEL'),
        ),
        TextButton(
          onPressed: () async {
            await context.read(editIntakeProvider.notifier).deleteWaterIntake();

            final builder = (context, animation) {
              return waterIntake.when(
                data: (value) {
                  final String getDrinkTypes =
                      value.todaysIntakes[index]['drinkTypes'];
                  final drinkTypes = getDrinkTypes.toDrinkTypes;
                  final String getTileColors =
                      value.todaysIntakes[index]['tileColors'];
                  final tileColors = getTileColors.toTileColors;
                  final String getDate = value.todaysIntakes[index]['date'];
                  final date = getDate.toDateTime;
                  final timeDifference = getTimeDifference(date);

                  return WaterIntakeItem(
                    tileColors: tileColors,
                    drinkTypes: drinkTypes,
                    date: date,
                    timeDifference: timeDifference,
                    animation: animation,
                    value: value,
                    index: index,
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (error, stackTrace) {
                  print('error: $error');
                  print('stackTrace: $stackTrace');

                  return const SizedBox.shrink();
                },
              );
            };

            animatedList.key.currentState.removeItem(
              index,
              builder,
              duration: const Duration(milliseconds: 500),
            );

            Navigator.popUntil(context, ModalRoute.withName(homeRoute));
          },
          child: Text('DELETE'),
        ),
      ],
    );
  }
}

class EditCupDialog extends StatelessWidget {
  const EditCupDialog();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select a cup'),
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: double.maxFinite,
            height: 250.0,
            child: const Scrollbar(
              child: EditCupLists(),
            ),
          ),
        ),
      ],
    );
  }
}

class EditCupLists extends HookWidget {
  const EditCupLists();

  @override
  Widget build(BuildContext context) {
    final cup = useProvider(cupProvider);

    return cup.when(
      data: (value) => ListView.builder(
        shrinkWrap: true,
        itemCount: value.allCup.length,
        itemBuilder: (context, index) {
          return EditCupItem(
            value: value,
            index: index,
          );
        },
      ),
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) {
        print('error: $error');
        print('stackTrace: $stackTrace');

        return const SizedBox.shrink();
      },
    );
  }
}

class EditCupItem extends HookWidget {
  const EditCupItem({
    this.value,
    this.index,
  });

  final Cup value;
  final int index;

  @override
  Widget build(BuildContext context) {
    final amount = useProvider(editAmountProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.local_drink),
            ),
            title: Text(
              '${value.allCup[index]['amount']} '
              '${value.allCup[index]['measurement']}',
            ),
            selected: value.allCup[index]['amount'] == amount ? true : false,
            trailing: value.allCup[index]['amount'] == amount
                ? const Icon(Icons.check_circle)
                : const SizedBox.shrink(),
            onTap: () {
              Navigator.pop(context);

              final amount = value.allCup[index]['amount'] as int;
              final String measurementString =
                  value.allCup[index]['measurement'];
              final measurement = measurementString.toLiquidMeasurement;

              context.read(editIntakeProvider.notifier).setSelectedCup(
                    amount: amount,
                    measurement: measurement,
                  );
            },
          ),
        ),
      ],
    );
  }
}

class EditDrinkTypeDialog extends StatelessWidget {
  const EditDrinkTypeDialog();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select a drink'),
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: double.maxFinite,
            height: 250.0,
            child: Scrollbar(
              child: const EditDrinkTypeLists(),
            ),
          ),
        ),
      ],
    );
  }
}

class EditDrinkTypeLists extends HookWidget {
  const EditDrinkTypeLists();

  @override
  Widget build(BuildContext context) {
    final drinkType = useProvider(drinkTypeProvider);

    return drinkType.when(
      data: (value) => ListView.builder(
        shrinkWrap: true,
        itemCount: value.allDrinkTypes.length,
        itemBuilder: (context, index) {
          return EditDrinkTypeItem(
            value: value,
            index: index,
          );
        },
      ),
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) {
        print('error: $error');
        print('stackTrace: $stackTrace');

        return const SizedBox.shrink();
      },
    );
  }
}

class EditDrinkTypeItem extends HookWidget {
  const EditDrinkTypeItem({
    @required this.value,
    @required this.index,
  });

  final DrinkType value;
  final int index;

  @override
  Widget build(BuildContext context) {
    final drinkTypes = useProvider(editDrinkTypesProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Icon((value.allDrinkTypes[index]['drinkTypes'] as String)
                  .toDrinkTypes
                  .icon),
            ),
            title: Text((value.allDrinkTypes[index]['drinkTypes'] as String)
                .toSentenceCase),
            selected: value.allDrinkTypes[index]['drinkTypes'] ==
                    drinkTypes.description.toLowerCase()
                ? true
                : false,
            trailing: value.allDrinkTypes[index]['drinkTypes'] ==
                    drinkTypes.description.toLowerCase()
                ? const Icon(Icons.check_circle)
                : const SizedBox.shrink(),
            onTap: () {
              Navigator.pop(context);

              context.read(editIntakeProvider.notifier).setSelectedDrinkTypes(
                    drinkTypes:
                        (value.allDrinkTypes[index]['drinkTypes'] as String)
                            .toDrinkTypes,
                  );
            },
          ),
        ),
      ],
    );
  }
}

class EditTileColorDialog extends StatelessWidget {
  const EditTileColorDialog();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select a color'),
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: double.maxFinite,
            height: 250.0,
            child: const Scrollbar(
              child: EditTileColorLists(),
            ),
          ),
        ),
      ],
    );
  }
}

class EditTileColorLists extends HookWidget {
  const EditTileColorLists();

  @override
  Widget build(BuildContext context) {
    final tileColor = useProvider(tileColorProvider);

    return tileColor.when(
      data: (value) => ListView.builder(
        shrinkWrap: true,
        itemCount: value.allTileColor.length,
        itemBuilder: (context, index) {
          return EditTileColorItem(
            value: value,
            index: index,
          );
        },
      ),
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) {
        print('error: $error');
        print('stackTrace: $stackTrace');

        return const SizedBox.shrink();
      },
    );
  }
}

class EditTileColorItem extends HookWidget {
  const EditTileColorItem({
    this.value,
    this.index,
  });

  final TileColor value;
  final int index;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final darkModeOn = brightness == Brightness.dark;
    final tileColors = useProvider(editTileColorsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: (value.allTileColor[index]['tileColors'] as String)
                        .toTileColors
                        .color ==
                    Colors.white
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: darkModeOn
                            ? Theme.of(context).chipTheme.backgroundColor
                            : const Color(0xFFe0e0e0),
                        width: 1.0,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: darkModeOn
                          ? Theme.of(context).chipTheme.backgroundColor
                          : (value.allTileColor[index]['tileColors'] as String)
                              .toTileColors
                              .color,
                    ),
                  )
                : CircleAvatar(
                    backgroundColor:
                        (value.allTileColor[index]['tileColors'] as String)
                            .toTileColors
                            .color,
                  ),
            title: Text(
              (value.allTileColor[index]['tileColors'] as String)
                  .toSentenceCase,
            ),
            selected: value.allTileColor[index]['tileColors'] ==
                    tileColors.description.toLowerCase()
                ? true
                : false,
            trailing: value.allTileColor[index]['tileColors'] ==
                    tileColors.description.toLowerCase()
                ? const Icon(Icons.check_circle)
                : const SizedBox.shrink(),
            onTap: () {
              Navigator.pop(context);

              context.read(editIntakeProvider.notifier).setSelectedTileColors(
                    tileColors:
                        (value.allTileColor[index]['tileColors'] as String)
                            .toTileColors,
                  );
            },
          ),
        ),
      ],
    );
  }
}
