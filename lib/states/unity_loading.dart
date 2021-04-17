import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/unity_loading.dart';

class UnityLoadingNotifier extends StateNotifier<UnityLoading> {
  UnityLoadingNotifier() : super(_initialValue);

  static final _initialValue = UnityLoading(true);

  void setIsFirstTimeOpeningUnity(bool value) {
    state = UnityLoading(value);
  }
}

final unityLoadingProvider =
    StateNotifierProvider<UnityLoadingNotifier, UnityLoading>(
  (ref) => UnityLoadingNotifier(),
);
