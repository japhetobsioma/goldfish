import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../common/helpers.dart';
import '../models/cup.dart';
import '../models/drink_type.dart';
import '../models/tile_color.dart';
import '../models/water_intake.dart';
import '../states/animated_key.dart';
import '../states/cup.dart';
import '../states/drink_type.dart';
import '../states/edit_intake.dart';
import '../states/tile_color.dart';
import '../states/user_info.dart';
import '../states/water_intake.dart';

class WaterIntakeScreen extends StatelessWidget {
  const WaterIntakeScreen();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read(waterIntakeProvider).fetchWaterIntake(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 30.0,
            ),
            const WaterIntakeGauge(),
            const WaterIntakeLists(),
            const SizedBox(
              height: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}

class WaterIntakeGauge extends HookWidget {
  const WaterIntakeGauge();

  @override
  Widget build(BuildContext context) {
    final waterIntake = useProvider(waterIntakeProvider.state);
    final userInfo = useProvider(userInfoProvider.state);

    useEffect(() {
      context.read(waterIntakeProvider).fetchWaterIntake();
      context.read(userInfoProvider).fetchUserInfo();
      return () {};
    }, []);

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
            ),
            pointers: [
              RangePointer(
                value: waterIntake.when(
                  data: (value) {
                    final total = value.todaysTotalWaterIntake ?? 0;
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
                color: Theme.of(context).primaryColor,
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
                            final total = value.todaysTotalWaterIntake ?? 0;
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
                          color: Theme.of(context).primaryColor,
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
                          color: Colors.black54,
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
    final waterIntake = useProvider(waterIntakeProvider.state);
    final animatedList = useProvider(animatedListKeyProvider.state);

    useEffect(() {
      context.read(waterIntakeProvider).fetchWaterIntake();
      return () {};
    }, []);

    return waterIntake.when(
      data: (value) {
        return Container(
          child: value.todaysWaterIntake.isNotEmpty
              ? AnimatedList(
                  key: animatedList.key,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  initialItemCount: value.todaysWaterIntake.length,
                  itemBuilder: (context, index, animation) {
                    final String getDrinkTypes =
                        value.todaysWaterIntake[index]['drinkTypes'];
                    final drinkTypes = getDrinkTypes.toDrinkTypes;
                    final String getTileColors =
                        value.todaysWaterIntake[index]['tileColors'];
                    final tileColors = getTileColors.toTileColors;
                    final String getDate =
                        value.todaysWaterIntake[index]['date'];
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 1.0,
      ),
      child: SizeTransition(
        sizeFactor: animation,
        child: Card(
          color: tileColors.color,
          child: ListTile(
            leading: tileColors.color == Colors.white
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFe0e0e0),
                        width: 1.0,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: tileColors.color,
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
              '${value.todaysWaterIntake[index]['amount']} '
              '${value.todaysWaterIntake[index]['measurement']} ',
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
                  value.todaysWaterIntake[index]['measurement'];
              final measurement = measurementString.toLiquidMeasurement;

              context.read(editIntakeProvider).setEditIntake(
                    waterIntakeID: value.todaysWaterIntake[index]
                        ['waterIntakeID'],
                    amount: value.todaysWaterIntake[index]['amount'],
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
    final tileColors = useProvider(editTileColorsProvider);
    final amount = useProvider(editAmountProvider);
    final measurement = useProvider(editMeasurementProvider);
    final drinkTypes = useProvider(editDrinkTypesProvider);
    final date = useProvider(editDateProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: const Color(0xFF202124),
        ),
        backgroundColor: tileColors.color,
        title: const Text(
          'Edit intake information',
          style: TextStyle(
            color: Color(0xFF202124),
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
                      .read(editIntakeProvider)
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
    final animatedList = useProvider(animatedListKeyProvider.state);
    final waterIntake = useProvider(waterIntakeProvider.state);
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
            await context.read(editIntakeProvider).deleteWaterIntake();

            final builder = (context, animation) {
              return waterIntake.when(
                data: (value) {
                  final String getDrinkTypes =
                      value.todaysWaterIntake[index]['drinkTypes'];
                  final drinkTypes = getDrinkTypes.toDrinkTypes;
                  final String getTileColors =
                      value.todaysWaterIntake[index]['tileColors'];
                  final tileColors = getTileColors.toTileColors;
                  final String getDate = value.todaysWaterIntake[index]['date'];
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

            Navigator.popUntil(context, ModalRoute.withName('/home'));
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
    final cup = useProvider(cupProvider.state);

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

              context.read(editIntakeProvider).setSelectedCup(
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
    final drinkType = useProvider(drinkTypeProvider.state);

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

              context.read(editIntakeProvider).setSelectedDrinkTypes(
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
    final tileColor = useProvider(tileColorProvider.state);

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
                        color: const Color(0xFFe0e0e0),
                        width: 1.0,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor:
                          (value.allTileColor[index]['tileColors'] as String)
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

              context.read(editIntakeProvider).setSelectedTileColors(
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
