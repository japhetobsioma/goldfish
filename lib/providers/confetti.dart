import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConfettiNotifier extends StateNotifier<bool> {
  ConfettiNotifier() : super(false);

  void updateConfetti(bool value) {
    state = value;
  }
}

final confettiProvider = StateNotifierProvider<ConfettiNotifier, bool>(
  (ref) => ConfettiNotifier(),
);
