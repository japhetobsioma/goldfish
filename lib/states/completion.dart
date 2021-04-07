import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/helpers.dart';
import '../database/database_helper.dart';
import '../models/completion.dart';

class CompletionNotifier extends StateNotifier<AsyncValue<Completion>> {
  CompletionNotifier() : super(const AsyncValue.loading()) {
    fetchCompletion();
  }

  static final dbHelper = DatabaseHelper.instance;

  Future<void> fetchCompletion() async {
    final isCompletedList = await dbHelper.getCompletionIsCompleted();
    final allTimeRatio = getCompletionAllTimeRatio(isCompletedList);
    final totalCompletion = getTotalCompletion(isCompletedList);

    state = AsyncValue.data(
      Completion(
        allTimeRatio: allTimeRatio,
        totalCompletion: totalCompletion,
      ),
    );
  }

  Future<void> checkCompletionDates() async {
    final completionDates = await dbHelper.getCompletionDates();
    var dayDifference = getCompletionDayDifference(completionDates);

    if (dayDifference > 0) {
      var query = '';
      dayDifference -= 1;

      for (; dayDifference >= 0; dayDifference--) {
        if (dayDifference != 0) {
          query +=
              ' (datetime("now", "localtime", "-$dayDifference day"), 0), ';
        } else {
          query += ' (datetime("now", "localtime"), 0)';
        }
      }

      await dbHelper.setCompletionDates(query);
    }
  }

  Future<void> initializeCompletionDates() async {
    await dbHelper.setTodaysCompletionDate();
  }
}

final completionProvider =
    StateNotifierProvider<CompletionNotifier>((ref) => CompletionNotifier());
