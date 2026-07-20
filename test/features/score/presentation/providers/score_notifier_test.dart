import 'package:companion_for_cacao/core/domain/entities/module_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/score/domain/entities/hut_type.dart';
import 'package:companion_for_cacao/features/score/domain/entities/score_state_entity.dart';
import 'package:companion_for_cacao/features/score/presentation/providers/score_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Fake game setup whose state the test drives directly.
class _FakeGameSetupNotifier extends GameSetupNotifier {
  _FakeGameSetupNotifier(this.initial);

  final GameSetupStateEntity initial;

  @override
  Future<GameSetupStateEntity> build() async => initial;

  void emit(GameSetupStateEntity value) => state = AsyncData(value);
}

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  ScoreNotifier notifier() => container.read(scoreProvider.notifier);
  ScoreStateEntity state() => container.read(scoreProvider);

  group('ScoreNotifier', () {
    test('starts empty without an active game', () {
      expect(state().players, isEmpty);
      expect(state().currentStepIndex, 0);
      expect(state().steps.first, ScoreStep.setup);
    });

    test('players can be added once per color and removed with their data', () {
      notifier()
        ..addPlayer('Alice', 'red')
        ..addPlayer('Dup', 'red')
        ..addPlayer('Bob', 'white')
        ..setAccumulatedGold('red', 10)
        ..addTemple();
      notifier()
        ..setTempleWorkers(1, 'red', 2)
        ..setMaskOwner(0, 'red')
        ..removePlayer('red');

      expect(state().players.map((p) => p.color), ['white']);
      expect(state().inputsByColor.containsKey('red'), isFalse);
      expect(state().maskOwners[0], isNull);
      expect(state().temples.single.workersOf('red'), 0);
    });

    test('toggling a module off from its own step clamps the index', () {
      notifier()
        ..addPlayer('Alice', 'red')
        ..addPlayer('Bob', 'white')
        ..setHutModuleActive(true);
      // Walk to the last step (Huts).
      while (!state().isLastStep) {
        notifier().nextStep();
      }
      expect(state().currentStep, ScoreStep.huts);

      notifier().setHutModuleActive(false);

      expect(state().currentStepIndex, state().steps.length - 1);
      // currentStep must not throw after the step list shrank.
      expect(state().currentStep, isNot(ScoreStep.huts));
    });

    test('gem mines replaces the temples step', () {
      notifier().setGemMinesActive(true);
      expect(state().steps, isNot(contains(ScoreStep.temples)));
      expect(state().steps, contains(ScoreStep.gemMines));
    });

    test('single-tile huts (Chief family) cannot be built twice', () {
      notifier()
        ..addPlayer('Alice', 'red')
        ..addPlayer('Bob', 'white')
        ..toggleHut('red', HutType.chief);
      expect(state().hutOwners(HutType.chief), ['red']);

      // Only one Chief tile exists: Bob's tap is refused.
      notifier().toggleHut('white', HutType.chief);
      expect(state().hutOwners(HutType.chief), ['red']);
      expect(state().canBuildHut('white', HutType.chief), isFalse);

      // After Alice releases it, Bob can build it.
      notifier()
        ..toggleHut('red', HutType.chief)
        ..toggleHut('white', HutType.chief);
      expect(state().hutOwners(HutType.chief), ['white']);
    });

    test('duplicated huts allow two owners but not a third copy', () {
      notifier()
        ..addPlayer('Alice', 'red')
        ..addPlayer('Bob', 'white')
        ..addPlayer('Carol', 'purple')
        ..toggleHut('red', HutType.marketCrier)
        ..toggleHut('white', HutType.marketCrier);
      // Two physical Market Crier tiles exist: both stick.
      expect(state().hutOwners(HutType.marketCrier), ['red', 'white']);

      // Both tiles are used up, so the Hermit (their back side) is gone.
      notifier().toggleHut('purple', HutType.hermit);
      expect(state().hutOwners(HutType.hermit), isEmpty);
      expect(state().canBuildHut('purple', HutType.hermit), isFalse);
    });

    test('mask ownership is reassigned or cleared explicitly', () {
      notifier()
        ..addPlayer('Alice', 'red')
        ..addPlayer('Bob', 'white')
        ..setMaskOwner(0, 'red')
        ..setMaskOwner(0, 'white');
      expect(state().maskOwners[0], 'white');

      notifier().setMaskOwner(0, null);
      expect(state().maskOwners[0], isNull);
    });

    test('starting a new game discards the previous scoring session', () async {
      final fake = _FakeGameSetupNotifier(GameSetupStateEntity());
      final container = ProviderContainer(
        overrides: [gameSetupProvider.overrideWith(() => fake)],
      );
      addTearDown(container.dispose);
      await container.read(gameSetupProvider.future);

      // Leftover standalone session from before the game.
      container.read(scoreProvider.notifier)
        ..addPlayer('Old', 'yellow')
        ..setAccumulatedGold('yellow', 33);
      expect(container.read(scoreProvider).players, hasLength(1));

      // A new game starts with different players and the hut module.
      fake.emit(
        GameSetupStateEntity(
          players: [
            PlayerEntity(name: 'Alice', color: 'red', isSelected: true),
            PlayerEntity(name: 'Bob', color: 'white', isSelected: true),
          ],
          modules: [
            ModuleEntity(id: 4, name: 'Huts', description: '', boardgameId: 2),
          ],
          isStarted: true,
        ),
      );

      final refreshed = container.read(scoreProvider);
      expect(refreshed.players.map((p) => p.name), ['Alice', 'Bob']);
      expect(refreshed.hutModuleActive, isTrue);
      expect(refreshed.inputOf('yellow').accumulatedGold, 0);
    });

    test('inputs are clamped to their game limits', () {
      notifier()
        ..addPlayer('Alice', 'red')
        ..setSunTokens('red', 99)
        ..setCacaoFruits('red', 99)
        ..setWaterFieldIndex('red', 99)
        ..setAccumulatedGold('red', -5);

      final input = state().inputOf('red');
      expect(input.sunTokens, 3);
      expect(input.cacaoFruits, 5);
      expect(input.waterFieldIndex, 8);
      expect(input.accumulatedGold, 0);
    });
  });
}
