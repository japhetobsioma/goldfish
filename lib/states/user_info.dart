import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../database/database_helper.dart';
import '../models/user_info.dart';

class UserInfoNotifier extends StateNotifier<AsyncValue<UserInfo>> {
  UserInfoNotifier() : super(const AsyncValue.loading()) {
    _readUserInfo();
  }

  static final dbHelper = DatabaseHelper.instance;

  Future<void> _readUserInfo() async {
    final hydrationPlan = await dbHelper.readHydrationPlan();

    state = AsyncValue.data(
      UserInfo(
        userInfo: hydrationPlan,
      ),
    );
  }

  /// Delete hydration plan from the database.
  Future<void> deleteHydrationPlan() async {
    await dbHelper.deleteHydrationPlan();
  }
}

final userInfoProvider =
    StateNotifierProvider<UserInfoNotifier>((ref) => UserInfoNotifier());
