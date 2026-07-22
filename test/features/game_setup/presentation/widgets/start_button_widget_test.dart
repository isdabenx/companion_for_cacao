import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/module_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/start_button_widget.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
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
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: StartButtonWidget()),
          ),
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
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: StartButtonWidget()),
          ),
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
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: StartButtonWidget()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('is enabled with 2 selected players even without names', (
      tester,
    ) async {
      final container = ProviderContainer(
        overrides: [
          gameSetupProvider.overrideWith(
            () => FakeGameSetupNotifier(
              players: [
                FakePlayer(name: '', color: 'red', isSelected: true),
                FakePlayer(name: '', color: 'yellow', isSelected: true),
              ],
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: StartButtonWidget()),
          ),
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
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: StartButtonWidget()),
          ),
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
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: StartButtonWidget()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Resume Game'), findsOneWidget);
      expect(find.text('Start Game'), findsNothing);
    });

    testWidgets('does not render the clear control itself', (tester) async {
      // Clear moved to the game-setup app bar; the button widget is now just
      // the start/resume action.
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
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: StartButtonWidget()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Clear Setup'), findsNothing);
    });

    testWidgets('surfaces the players hint when fewer than 2 are selected', (
      tester,
    ) async {
      final container = ProviderContainer(
        overrides: [
          gameSetupProvider.overrideWith(
            () => FakeGameSetupNotifier(
              players: [FakePlayer(name: '', color: 'white', isSelected: true)],
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: StartButtonWidget()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
      expect(find.text('Add at least 2 players'), findsOneWidget);
    });

    testWidgets('is disabled when a selected expansion has no modules', (
      tester,
    ) async {
      final chocolatl = BoardgameEntity(
        id: 2,
        name: 'Cacao: Chocolatl',
        description: '',
        filenameImage: '',
        modules: [ModuleEntity(id: 4, name: 'Huts', description: '')],
      );
      final container = ProviderContainer(
        overrides: [
          gameSetupProvider.overrideWith(
            () => FakeGameSetupNotifier(
              players: [
                FakePlayer(name: '', color: 'white', isSelected: true),
                FakePlayer(name: '', color: 'red', isSelected: true),
              ],
              expansions: [chocolatl],
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: StartButtonWidget()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
      // The reason is surfaced near the button.
      expect(find.text('An expansion has no modules selected'), findsOneWidget);
    });

    testWidgets('is enabled once the selected expansion has a module', (
      tester,
    ) async {
      final huts = ModuleEntity(id: 4, name: 'Huts', description: '');
      final chocolatl = BoardgameEntity(
        id: 2,
        name: 'Cacao: Chocolatl',
        description: '',
        filenameImage: '',
        modules: [huts],
      );
      final container = ProviderContainer(
        overrides: [
          gameSetupProvider.overrideWith(
            () => FakeGameSetupNotifier(
              players: [
                FakePlayer(name: '', color: 'white', isSelected: true),
                FakePlayer(name: '', color: 'red', isSelected: true),
              ],
              expansions: [chocolatl],
              modules: [huts],
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: StartButtonWidget()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);
      expect(find.text('An expansion has no modules selected'), findsNothing);
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

// Test fake: public fields configure the fixture and spy on calls.
// ignore_for_file: riverpod_lint/avoid_public_notifier_properties
class FakeGameSetupNotifier extends GameSetupNotifier {
  FakeGameSetupNotifier({
    required this.players,
    this.isStarted = false,
    this.expansions = const [],
    this.modules = const [],
  });

  final List<FakePlayer> players;
  final bool isStarted;
  final List<BoardgameEntity> expansions;
  final List<ModuleEntity> modules;

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
      expansions: expansions,
      modules: modules,
    );
  }
}
