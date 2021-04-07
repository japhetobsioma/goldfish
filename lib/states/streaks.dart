import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/helpers.dart';
import '../database/database_helper.dart';
import '../models/streaks.dart';

class StreaksNotifier extends StateNotifier<AsyncValue<Streaks>> {
  StreaksNotifier() : super(const AsyncValue.loading()) {
    fetchStreaks();
  }

  static final dbHelper = DatabaseHelper.instance;

  /// Initialize the streaks provider by getting the data from database.
  Future<void> fetchStreaks() async {
    /// We get the streaks from completion data from database.
    final completionData = await dbHelper.getCompletionData();

    /// Then we pass it in this function to get the current streaks and
    /// last streaks (or best streaks).
    final streaks = getStreaks(completionData);

    state = AsyncValue.data(
      Streaks(
        currentStreaks: streaks.currentStreaks,
        lastStreaks: streaks.lastStreaks,
      ),
    );
  }
}

final streaksProvider =
    StateNotifierProvider<StreaksNotifier>((ref) => StreaksNotifier());
