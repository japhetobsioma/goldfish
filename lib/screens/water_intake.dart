import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../common/helpers.dart';
import '../states/total_water.dart';
import '../states/water_intake.dart';

class WaterIntakeScreen extends StatelessWidget {
  const WaterIntakeScreen();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(
            height: 30.0,
          ),
          const WaterIntakeInfo(),
          const WaterIntakeTiles(),
        ],
      ),
    );
  }
}

class WaterIntakeInfo extends HookWidget {
  const WaterIntakeInfo();

  @override
  Widget build(BuildContext context) {
    final totalWaterIntake = useProvider(totalWaterIntakeProvider.state);

    return Container(
      child: SfRadialGauge(
        enableLoadingAnimation: true,
        axes: [
          RadialAxis(
            interval: 10.0,
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
                value: totalWaterIntake.when(
                  data: (value) {
                    return value.totalWaterIntake.toDouble();
                  },
                  loading: () => 0,
                  error: (error, stackTrace) {
                    print('error $error');
                    print('stackTrace $stackTrace');

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
                        text: totalWaterIntake.when(
                          data: (value) {
                            return value.totalWaterIntake.toString();
                          },
                          loading: () => '',
                          error: (error, stackTrace) {
                            print('error $error');
                            print('stackTrace $stackTrace');

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

class WaterIntakeTiles extends HookWidget {
  const WaterIntakeTiles();

  @override
  Widget build(BuildContext context) {
    final waterIntake = useProvider(waterIntakeProvider.state);

    return waterIntake.when(
      data: (value) => Container(
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: value.waterIntake.length,
          itemBuilder: (context, index) {
            final String getDrinkTypes = value.waterIntake[index]['drinkTypes'];
            final drinkTypes = getDrinkTypes.toDrinkTypes;

            final String getTileColors = value.waterIntake[index]['tileColors'];
            final tileColors = getTileColors.toTileColors;

            final String getDate = value.waterIntake[index]['date'];
            final dateTime = getDate.toDateTime;
            final timeDifference = getTimeDifference(dateTime);

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 1,
              ),
              child: Card(
                color: tileColors.color,
                child: ListTile(
                  leading: Icon(
                    drinkTypes.icon,
                    color: tileColors.subtitleColor,
                    size: 35.0,
                  ),
                  title: Text(
                    '${value.waterIntake[index]['amount']} '
                    '${value.waterIntake[index]['measurement']}',
                    style: TextStyle(
                      color: tileColors.textIconColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${drinkTypes.name} · $timeDifference',
                    style: TextStyle(
                      color: tileColors.subtitleColor,
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
                      child: Icon(
                        Icons.more_vert,
                        color: tileColors.subtitleColor,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) {
        print('error $error');
        print('stackTrace $stackTrace');

        return const CircularProgressIndicator();
      },
    );
  }
}
