import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeNotifier extends StateNotifier<AsyncValue<int>> {
  AppThemeNotifier() : super(const AsyncValue.loading()) {
    fetchAppTheme();
  }

  Future<void> fetchAppTheme() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final appTheme = sharedPreferences.getInt('AppTheme') ?? 0;

    state = AsyncValue.data(appTheme);
  }

  Future<void> updateAppTheme(int value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt('AppTheme', value);

    await fetchAppTheme();
  }
}

final appThemeProvider =
    StateNotifierProvider<AppThemeNotifier, AsyncValue<int>>(
        (ref) => AppThemeNotifier());
