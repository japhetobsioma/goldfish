import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../database/app_database.dart';

class AppDatabaseNotifier extends StateNotifier<AppDatabase> {
  AppDatabaseNotifier() : super(_initialValue);

  static final _initialValue = AppDatabase();
}

final appDatabaseProvider =
    StateNotifierProvider<AppDatabaseNotifier>((ref) => AppDatabaseNotifier());
