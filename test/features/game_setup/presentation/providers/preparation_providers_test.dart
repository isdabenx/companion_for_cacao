import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/preparation_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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
