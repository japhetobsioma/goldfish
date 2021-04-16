import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/helpers.dart';
import '../common/routes.dart';
import '../models/cup.dart';
import '../models/drink_type.dart';
import '../models/tile_color.dart';
import '../states/animated_key.dart';
import '../states/completion.dart';
import '../states/cup.dart';
import '../states/drink_type.dart';
import '../states/intake_bank.dart';
import '../states/notifications_manager.dart';
import '../states/tile_color.dart';
import '../states/water_intake.dart';
import 'water_intake.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class HomeScreen extends HookWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    final animatedList = useProvider(animatedListKeyProvider);

    Future<dynamic> selectNotification(String payload) async {
      await Navigator.pushNamedAndRemoveUntil(
        context,
        homeRoute,
        (route) => false,
      );
    }

    useEffect(() {
      Future.microtask(() async {
        const initializationSettingsAndroid = AndroidInitializationSettings(
          '@mipmap/ic_launcher',
        );

        final initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
        );

        await flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
          onSelectNotification: selectNotification,
        );

        await context.read(completionProvider.notifier).checkCompletionDates();

        await context.read(intakeBankProvider.notifier).fetchIntakeBank();

        final sharedPreferences = await SharedPreferences.getInstance();
        final initializeNotification =
            sharedPreferences.getBool('initializeNotification') ?? true;

        if (initializeNotification) {
          await context
              .read(notificationManagerProvider.notifier)
              .generateScheduledNotifications();
          await context
              .read(notificationManagerProvider.notifier)
              .setAllScheduledNotifications();
        }

        await sharedPreferences.setBool('initializeNotification', false);
      });
      return () {};
    }, []);

    return WillPopScope(
      onWillPop: () => exit(0),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: WaterIntakeScreen(),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => const MenuBottomSheet(),
                  );
                },
              ),
              Spacer(),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => const MoreBottomSheet(),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await context
                .read(waterIntakeProvider.notifier)
                .insertWaterIntake();

            if (animatedList.key.currentState != null) {
              animatedList.key.currentState.insertItem(
                0,
                duration: const Duration(milliseconds: 500),
              );
            }
          },
          child: const Icon(Icons.local_drink),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class MenuBottomSheet extends HookWidget {
  const MenuBottomSheet();

  @override
  Widget build(BuildContext context) {
    final intakeBank = useProvider(intakeBankProvider);

    useEffect(() {
      context.read(intakeBankProvider.notifier).fetchIntakeBank();
      return () {};
    }, []);

    return Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          subtitle: const Text('Add water intake'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        intakeBank.when(
            data: (value) {
              final amount = value.intakeBankAmount.toInt() ?? 0;

              return ListTile(
                leading: const Icon(Icons.waves),
                title: const Text('Aquarium'),
                subtitle: const Text('Interact with your fishes'),
                onTap: () async {
                  Navigator.pop(context);

                  await context
                      .read(intakeBankProvider.notifier)
                      .updateIntakeBank(
                        value: amount.toDouble(),
                        arithmeticOperator: '-',
                      );

                  await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      Future.delayed(
                        const Duration(seconds: 1),
                        () async {
                          Navigator.pop(context);

                          await Navigator.pushNamed(
                            context,
                            aquariumRoute,
                            arguments: {'water': '$amount'},
                          );
                        },
                      );
                      return AlertDialog(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Opening Unity Player'),
                            const CircularProgressIndicator(),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink()),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('History'),
          subtitle: const Text('See your water intake history'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/history');
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          subtitle: const Text('Change settings'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/settings');
          },
        ),
      ],
    );
  }
}

class MoreBottomSheet extends HookWidget {
  const MoreBottomSheet();

  @override
  Widget build(BuildContext context) {
    final cup = useProvider(cupProvider);
    final drinkType = useProvider(drinkTypeProvider);
    final tileColor = useProvider(tileColorProvider);

    return Wrap(
      children: [
        cup.when(
          data: (value) => ListTile(
            leading: const Icon(Icons.cached),
            title: const Text('Change cup'),
            subtitle: Text(
              '${value.selectedCupAmount} ${value.selectedCupMeasurement}',
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => const CupDialog(),
              );
            },
          ),
          loading: () => const SizedBox.shrink(),
          error: (error, stackTrace) {
            print('error: $error');
            print('stackTrace: $stackTrace');

            return const SizedBox.shrink();
          },
        ),
        drinkType.when(
          data: (value) => ListTile(
            leading: const Icon(Icons.local_cafe),
            title: const Text('Change drink'),
            subtitle: Text('${value.selectedDrinkType.toSentenceCase}'),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => const DrinkTypeDialog(),
              );
            },
          ),
          loading: () => const SizedBox.shrink(),
          error: (error, stackTrace) {
            print('error: $error');
            print('stackTrace: $stackTrace');

            return const SizedBox.shrink();
          },
        ),
        tileColor.when(
          data: (value) => ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Change color'),
            subtitle: Text('${value.selectedTileColor.toSentenceCase}'),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => const TileColorDialog(),
              );
            },
          ),
          loading: () => const SizedBox.shrink(),
          error: (error, stackTrace) {
            print('error: $error');
            print('stackTrace: $stackTrace');

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class CupDialog extends StatelessWidget {
  const CupDialog();

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
              child: CupLists(),
            ),
          ),
        ),
      ],
    );
  }
}

class CupLists extends HookWidget {
  const CupLists();

  @override
  Widget build(BuildContext context) {
    final cup = useProvider(cupProvider);

    return cup.when(
      data: (value) => ListView.builder(
        shrinkWrap: true,
        itemCount: value.allCup.length,
        itemBuilder: (context, index) {
          return CupItem(
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

class CupItem extends StatelessWidget {
  const CupItem({
    this.value,
    this.index,
  });

  final Cup value;
  final int index;

  @override
  Widget build(BuildContext context) {
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
            selected: value.allCup[index]['isActive'] == 'true' ? true : false,
            trailing: value.allCup[index]['isActive'] == 'true'
                ? const Icon(Icons.check_circle)
                : const SizedBox.shrink(),
            onTap: () {
              Navigator.pop(context);

              context
                  .read(cupProvider.notifier)
                  .setSelectedCup(value.allCup[index]['cupID']);
            },
          ),
        ),
      ],
    );
  }
}

class DrinkTypeDialog extends StatelessWidget {
  const DrinkTypeDialog();

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
            child: const Scrollbar(
              child: DrinkTypeLists(),
            ),
          ),
        ),
      ],
    );
  }
}

class DrinkTypeLists extends HookWidget {
  const DrinkTypeLists();

  @override
  Widget build(BuildContext context) {
    final drinkType = useProvider(drinkTypeProvider);

    return drinkType.when(
      data: (value) => ListView.builder(
        shrinkWrap: true,
        itemCount: value.allDrinkTypes.length,
        itemBuilder: (context, index) {
          final String drinkTypeString =
              value.allDrinkTypes[index]['drinkTypes'];
          final drinkTypes = drinkTypeString.toDrinkTypes;

          return DrinkTypeItem(
            drinkTypes: drinkTypes,
            drinkTypeString: drinkTypeString,
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

class DrinkTypeItem extends StatelessWidget {
  const DrinkTypeItem({
    this.drinkTypes,
    this.drinkTypeString,
    this.value,
    this.index,
  });

  final DrinkTypes drinkTypes;
  final String drinkTypeString;
  final DrinkType value;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Icon(drinkTypes.icon),
            ),
            title: Text(drinkTypeString.toSentenceCase),
            selected:
                value.allDrinkTypes[index]['isActive'] == 'true' ? true : false,
            trailing: value.allDrinkTypes[index]['isActive'] == 'true'
                ? const Icon(Icons.check_circle)
                : const SizedBox.shrink(),
            onTap: () {
              Navigator.pop(context);

              context.read(drinkTypeProvider.notifier).setSelectedDrinkType(
                  value.allDrinkTypes[index]['drinkTypes']);
            },
          ),
        ),
      ],
    );
  }
}

class TileColorDialog extends StatelessWidget {
  const TileColorDialog();

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
              child: TileColorLists(),
            ),
          ),
        ),
      ],
    );
  }
}

class TileColorLists extends HookWidget {
  const TileColorLists();

  @override
  Widget build(BuildContext context) {
    final tileColor = useProvider(tileColorProvider);

    return tileColor.when(
      data: (value) => ListView.builder(
        shrinkWrap: true,
        itemCount: value.allTileColor.length,
        itemBuilder: (context, index) {
          final String tileColorString =
              value.allTileColor[index]['tileColors'];
          final tileColor = tileColorString.toTileColors;

          return TileColorItem(
            tileColor: tileColor,
            tileColorString: tileColorString,
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

class TileColorItem extends StatelessWidget {
  const TileColorItem({
    this.tileColor,
    this.tileColorString,
    this.value,
    this.index,
  });

  final TileColors tileColor;
  final String tileColorString;
  final TileColor value;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: tileColor.color == Colors.white
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFe0e0e0),
                        width: 1.0,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: tileColor.color,
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: tileColor.color,
                  ),
            title: Text(tileColorString.toSentenceCase),
            selected:
                value.allTileColor[index]['isActive'] == 'true' ? true : false,
            trailing: value.allTileColor[index]['isActive'] == 'true'
                ? const Icon(Icons.check_circle)
                : const SizedBox.shrink(),
            onTap: () {
              Navigator.pop(context);

              context.read(tileColorProvider.notifier).setSelectedTileColor(
                  value.allTileColor[index]['tileColors']);
            },
          ),
        ),
      ],
    );
  }
}
