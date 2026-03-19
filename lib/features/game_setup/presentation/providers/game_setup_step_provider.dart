import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_setup_step_provider.g.dart';

@riverpod
class GameSetupStep extends _$GameSetupStep {
  @override
  int build() => 0;

  void setStep(int step) => state = step;
}
