import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/helpers.dart';
import '../database/database_helper.dart';
import '../models/completion.dart';

class CompletionNotifier extends StateNotifier<AsyncValue<Completion>> {
  CompletionNotifier() : super(const AsyncValue.loading()) {
    _fetchCompletion();
  }

  static final dbHelper = DatabaseHelper.instance;

  Future<void> _fetchCompletion() async {
    final completionData = await dbHelper.getCompletionData();

    state = AsyncValue.data(
      Completion(
        completionData: completionData,
      ),
    );
  }

  Future<void> getStreaksInfo() async {
    final completionData = await dbHelper.getCompletionData();

    print(completionData);

    final streaks = getStreaks(completionData);

    print(streaks);
  }
}

final completionProvider =
    StateNotifierProvider<CompletionNotifier>((ref) => CompletionNotifier());
