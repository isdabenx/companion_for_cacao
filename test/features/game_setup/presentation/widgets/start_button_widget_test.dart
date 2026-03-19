import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/start_button_widget.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StartButtonWidget', () {
    testWidgets('should be disabled when less than 2 players selected', (
      tester,
    ) async {
      final container = ProviderContainer(
        overrides: [
          gameSetupProvider.overrideWith(
            () => FakeGameSetupNotifier(
              players: [], // No players selected
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: Scaffold(body: StartButtonWidget())),
        ),
      );

      await tester.pumpAndSettle();

      // Find the FilledButton
      final buttonFinder = find.byType(FilledButton);
      expect(buttonFinder, findsOneWidget);

      // Verify button is disabled (onPressed is null)
      final button = tester.widget<FilledButton>(buttonFinder);
      expect(button.onPressed, isNull);
    });

    testWidgets('should be disabled with only 1 player', (tester) async {
      final container = ProviderContainer(
        overrides: [
          gameSetupProvider.overrideWith(
            () => FakeGameSetupNotifier(
              players: [
                FakePlayer(name: 'Player 1', color: 'red', isSelected: true),
              ],
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: Scaffold(body: StartButtonWidget())),
        ),
      );

      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('should be enabled with 2 or more players', (tester) async {
      final container = ProviderContainer(
        overrides: [
          gameSetupProvider.overrideWith(
            () => FakeGameSetupNotifier(
              players: [
                FakePlayer(name: 'Player 1', color: 'red', isSelected: true),
                FakePlayer(name: 'Player 2', color: 'yellow', isSelected: true),
              ],
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: Scaffold(body: StartButtonWidget())),
        ),
      );

      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('should display Start Game text', (tester) async {
      final container = ProviderContainer(
        overrides: [
          gameSetupProvider.overrideWith(
            () => FakeGameSetupNotifier(
              players: [
                FakePlayer(name: 'Player 1', color: 'red', isSelected: true),
                FakePlayer(name: 'Player 2', color: 'yellow', isSelected: true),
              ],
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: Scaffold(body: StartButtonWidget())),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Start Game'), findsOneWidget);
    });
  });
}

// Fake classes for testing
class FakePlayer {
  FakePlayer({
    required this.name,
    required this.color,
    required this.isSelected,
  });
  final String name;
  final String color;
  final bool isSelected;
}

class FakeGameSetupNotifier extends GameSetupNotifier {
  FakeGameSetupNotifier({required this.players});

  final List<FakePlayer> players;

  @override
  Future<GameSetupStateEntity> build() async {
    return GameSetupStateEntity(
      players: players
          .map(
            (p) => PlayerEntity(
              name: p.name,
              color: p.color,
              isSelected: p.isSelected,
            ),
          )
          .toList(),
    );
  }
}
