import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/animated_key.dart';

class AnimatedListKeyNotifier extends StateNotifier<AnimatedListKey> {
  AnimatedListKeyNotifier() : super(_initialValue);

  static final _initialValue = AnimatedListKey(
    key: GlobalKey<AnimatedListState>(),
  );
}

final animatedListKeyProvider = StateNotifierProvider<AnimatedListKeyNotifier>(
    (ref) => AnimatedListKeyNotifier());
