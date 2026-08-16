import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/preparation_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Lets the test flip the game from configured to started, which is the
/// transition PhaseExpansion listens for.
class _FakeGameSetupNotifier extends GameSetupNotifier {
  @override
  Future<GameSetupStateEntity> build() async => GameSetupStateEntity();

  void start() => state = AsyncData(GameSetupStateEntity(isStarted: true));
}

void main() {
  group('PhaseExpansion', () {
    test('only stores overrides, so a phase back at its default drops out', () {
      final container = ProviderContainer.test();
      final notifier = container.read(phaseExpansionProvider.notifier);

      notifier.toggle(PreparationPhase.playerSetup, isDefaultExpanded: true);
      expect(container.read(phaseExpansionProvider), {
        PreparationPhase.playerSetup: false,
      });

      notifier.toggle(PreparationPhase.playerSetup, isDefaultExpanded: true);
      expect(container.read(phaseExpansionProvider), isEmpty);
    });

    // Collapsing a phase is a decision the reader made, and it used to be
    // thrown away by stepping out to the game board and back — while the
    // steps ticked on the same screen survived.
    test(
      'a collapsed phase survives the screen losing its listeners',
      () async {
        final container = ProviderContainer.test();
        final subscription = container.listen(
          phaseExpansionProvider,
          (_, _) {},
        );
        container
            .read(phaseExpansionProvider.notifier)
            .toggle(PreparationPhase.boardSetup, isDefaultExpanded: true);

        // Closing the last subscription is what leaving the screen does.
        subscription.close();
        await container.pump();

        expect(container.read(phaseExpansionProvider), {
          PreparationPhase.boardSetup: false,
        });
      },
    );

    // Surviving the screen is the point; surviving the game is not — a new
    // preparation should not open already collapsed because of how someone
    // read the previous one.
    testWidgets('starting a new game expands the phases again', (tester) async {
      final fake = _FakeGameSetupNotifier();
      final container = ProviderContainer.test(
        overrides: [gameSetupProvider.overrideWith(() => fake)],
      );
      await container.read(gameSetupProvider.future);

      container
          .read(phaseExpansionProvider.notifier)
          .toggle(PreparationPhase.playerSetup, isDefaultExpanded: true);
      expect(container.read(phaseExpansionProvider), isNotEmpty);

      fake.start();
      await container.pump();

      expect(container.read(phaseExpansionProvider), isEmpty);
    });

    test('clearAll is still the way to reset it', () async {
      final container = ProviderContainer.test();
      final notifier = container.read(phaseExpansionProvider.notifier)
        ..toggle(PreparationPhase.supplies, isDefaultExpanded: true);
      expect(container.read(phaseExpansionProvider), isNotEmpty);

      notifier.clearAll();
      expect(container.read(phaseExpansionProvider), isEmpty);
    });
  });
}
