import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../database/database_helper.dart';
import '../models/completion.dart';
import '../common/helpers.dart';

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
}

final completionProvider =
    StateNotifierProvider<CompletionNotifier>((ref) => CompletionNotifier());
