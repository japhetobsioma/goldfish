import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStatusNotifier extends StateNotifier<AsyncValue<bool>> {
  UserStatusNotifier() : super(const AsyncValue.loading()) {
    fetchUserStatus();
  }

  Future<void> fetchUserStatus() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final isUserSignedUp = sharedPreferences.getBool('isUserSignedUp') ?? false;

    state = AsyncValue.data(isUserSignedUp);
  }

  Future<void> updateUserStatus(bool value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('isUserSignedUp', value);

    await fetchUserStatus();
  }
}

final userStatusProvider =
    StateNotifierProvider<UserStatusNotifier, AsyncValue<bool>>(
        (ref) => UserStatusNotifier());
