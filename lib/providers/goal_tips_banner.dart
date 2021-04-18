import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalTipsBannerNotifier extends StateNotifier<AsyncValue<bool>> {
  GoalTipsBannerNotifier() : super(const AsyncValue.loading()) {
    fetchGoalTipsBanner();
  }

  Future<void> fetchGoalTipsBanner() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final showGoalTipsBanner =
        sharedPreferences.getBool('ShowGoalTipsBanner') ?? true;

    state = AsyncValue.data(showGoalTipsBanner);
  }

  Future<void> setGoalTipsBanner(bool value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('ShowGoalTipsBanner', false);

    await fetchGoalTipsBanner();
  }
}

final goalTipsBannerProvider =
    StateNotifierProvider<GoalTipsBannerNotifier, AsyncValue<bool>>(
  (ref) => GoalTipsBannerNotifier(),
);
