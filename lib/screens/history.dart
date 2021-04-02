import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../states/user_info.dart';
import '../common/helpers.dart';

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

class MostDrinkTypes extends StatelessWidget {
  const MostDrinkTypes();

  @override
  Widget build(BuildContext context) {
    final drinkTypes = [
      'water',
      'hot chocolate',
      'coffee',
      'lemonade',
      'iced tea',
      'juice',
      'milkshake',
      'tea',
      'milk',
      'beer',
      'soda',
      'wine',
      'liquor',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 20.0,
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 10.0,
        children: drinkTypes.map((e) {
          return ActionChip(
            avatar: Icon(e.toDrinkTypes.icon),
            label: Text(e.toSentenceCase),
            onPressed: () {},
          );
        }).toList(),
      ),
    );
  }
}
