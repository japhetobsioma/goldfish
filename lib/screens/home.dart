import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../models/water_intake.dart';

// waterIntakeProvider will be also used in central.dart because we need to
// listen for any changes when the user clicked the FAB buttons.
final waterIntakeProvider =
    StateNotifierProvider((ref) => WaterIntakeNotifier());

final _totalIntakeState = Provider<double>((ref) {
  return ref.watch(waterIntakeProvider.state).totalIntake;
});

final _totalIntakeProvider = Provider<double>((ref) {
  return ref.watch(_totalIntakeState);
});

class HomeScreen extends HookWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    final _waterIntakeModel = useProvider(waterIntakeProvider.state);
    const _waterGoal = 3700.0;
    final _colorScheme = Theme.of(context).colorScheme;

    final _totalIntakeModel = useProvider(_totalIntakeProvider);

    var sTotalIntake =
        _totalIntakeModel.toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '');
    var sWaterGoal =
        _waterGoal.toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '');

    return ListView(
      children: [
        SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              interval: _waterIntakeModel.cup,
              startAngle: 270,
              endAngle: 270,
              minimum: 0,
              maximum: _waterGoal,
              showTicks: false,
              showLabels: false,
              axisLineStyle: AxisLineStyle(
                thickness: 20,
              ),
              pointers: <GaugePointer>[
                RangePointer(
                  value: _totalIntakeModel,
                  width: 20,
                  color: _colorScheme.primary,
                  enableAnimation: true,
                  cornerStyle: CornerStyle.bothCurve,
                ),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  widget: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headline5,
                      children: [
                        TextSpan(
                          text: '${sTotalIntake}ml',
                          style: TextStyle(
                            color: _colorScheme.primary,
                          ),
                        ),
                        TextSpan(
                          text: ' / ${sWaterGoal}ml',
                          style: TextStyle(
                            color: _colorScheme.secondaryVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  positionFactor: 0.10,
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
