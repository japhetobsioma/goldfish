import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../database/database_helper.dart';
import '../models/user_info.dart';

class UserInfoNotifier extends StateNotifier<AsyncValue<UserInfo>> {
  UserInfoNotifier() : super(const AsyncValue.loading()) {
    fetchUserInfo();
  }

  static final dbHelper = DatabaseHelper.instance;

  Future<void> fetchUserInfo() async {
    final hydrationPlan = await dbHelper.fetchHydrationPlan();

    state = AsyncValue.data(
      UserInfo(
        userInfo: hydrationPlan,
      ),
    );
  }

  Future<void> deleteHydrationPlan() async {
    await dbHelper.deleteHydrationPlan();
  }
}

final userInfoProvider =
    StateNotifierProvider<UserInfoNotifier, AsyncValue<UserInfo>>(
  (ref) => UserInfoNotifier(),
);
