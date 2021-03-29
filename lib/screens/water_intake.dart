import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../common/helpers.dart';
import '../models/drink_type.dart';
import '../models/tile_color.dart';
import '../models/water_intake.dart';
import '../states/animated_key.dart';
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

    return Container(
      child: SfRadialGauge(
        enableLoadingAnimation: true,
        axes: [
          RadialAxis(
            minimum: 0,
            maximum: 1000.0,
            showTicks: false,
            showLabels: false,
            axisLineStyle: AxisLineStyle(
              thickness: 25.0,
              cornerStyle: CornerStyle.bothCurve,
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
                cornerStyle: CornerStyle.bothCurve,
                sizeUnit: GaugeSizeUnit.logicalPixel,
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
                        text: ' / 1000 ml',
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
                    final dateTime = getDate.toDateTime;
                    final timeDifference = getTimeDifference(dateTime);

                    return WaterIntakeItem(
                      tileColors: tileColors,
                      drinkTypes: drinkTypes,
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
    this.timeDifference,
    this.animation,
    this.value,
    this.index,
  });

  final TileColors tileColors;
  final DrinkTypes drinkTypes;
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
              '${value.todaysWaterIntake[index]['measurement']}',
              style: TextStyle(
                color: const Color(0xFF202124),
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            subtitle: Text(
              '${drinkTypes.name} · $timeDifference',
              style: TextStyle(
                color: const Color(0xFF202124),
              ),
            ),
            trailing: PopupMenuButton(
              onSelected: (value) {},
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                const PopupMenuItem(
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  child: Text('Delete'),
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: const Icon(
                  Icons.more_vert,
                  color: Color(0xFF202124),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
