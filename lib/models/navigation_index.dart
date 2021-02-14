import 'package:hooks_riverpod/hooks_riverpod.dart';

class NavigationIndexNotifier extends StateNotifier<NavigationIndexModel> {
  NavigationIndexNotifier() : super(_initialState);

  static const _initialState = NavigationIndexModel(index: 0);

  void selectIndex(int index) {
    state = NavigationIndexModel(index: index);
  }
}

class NavigationIndexModel {
  final int index;

  const NavigationIndexModel({this.index});
}
