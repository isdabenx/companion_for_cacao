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

    testWidgets('should display Start Game text when not started', (
      tester,
    ) async {
      final container = ProviderContainer(
        overrides: [
          gameSetupProvider.overrideWith(
            () => FakeGameSetupNotifier(
              players: [
                FakePlayer(name: 'Player 1', color: 'red', isSelected: true),
                FakePlayer(name: 'Player 2', color: 'yellow', isSelected: true),
              ],
              isStarted: false,
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
      expect(find.text('Resume Game'), findsNothing);
    });

    testWidgets('should display Resume Game text when started', (tester) async {
      final container = ProviderContainer(
        overrides: [
          gameSetupProvider.overrideWith(
            () => FakeGameSetupNotifier(
              players: [
                FakePlayer(name: 'Player 1', color: 'red', isSelected: true),
                FakePlayer(name: 'Player 2', color: 'yellow', isSelected: true),
              ],
              isStarted: true,
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

      expect(find.text('Resume Game'), findsOneWidget);
      expect(find.text('Start Game'), findsNothing);
    });

    testWidgets('should NOT show Clear Setup button when form is empty', (
      tester,
    ) async {
      final container = ProviderContainer(
        overrides: [
          gameSetupProvider.overrideWith(
            () => FakeGameSetupNotifier(players: []),
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

      expect(find.text('Clear Setup'), findsNothing);
    });

    testWidgets('should show Clear Setup button when a player is entered', (
      tester,
    ) async {
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

      expect(find.text('Clear Setup'), findsOneWidget);
    });

    testWidgets('should call clearAll when Clear Setup is tapped', (
      tester,
    ) async {
      final notifier = FakeGameSetupNotifier(
        players: [FakePlayer(name: 'Player 1', color: 'red', isSelected: true)],
      );

      final container = ProviderContainer(
        overrides: [gameSetupProvider.overrideWith(() => notifier)],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: Scaffold(body: StartButtonWidget())),
        ),
      );

      await tester.pumpAndSettle();

      // Tap the Clear Setup button
      await tester.tap(find.text('Clear Setup'));
      await tester.pumpAndSettle();

      // Verify that clearAll was called
      expect(notifier.clearAllCalled, isTrue);
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
  FakeGameSetupNotifier({required this.players, this.isStarted = false});

  final List<FakePlayer> players;
  final bool isStarted;
  bool clearAllCalled = false;

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
      isStarted: isStarted,
    );
  }

  @override
  Future<void> clearAll() async {
    clearAllCalled = true;
  }
}
