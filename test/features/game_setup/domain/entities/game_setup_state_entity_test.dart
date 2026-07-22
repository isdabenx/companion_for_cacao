import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/module_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameSetupStateEntity.hasIncompleteExpansion', () {
    final huts = ModuleEntity(id: 4, name: 'Huts', description: '');
    final maps = ModuleEntity(id: 5, name: 'Maps', description: '');
    final chocolatl = BoardgameEntity(
      id: 2,
      name: 'Cacao: Chocolatl',
      description: '',
      filenameImage: '',
      modules: [huts, maps],
    );

    test('is false when no expansion is selected', () {
      final state = GameSetupStateEntity(players: []);
      expect(state.hasIncompleteExpansion, isFalse);
      expect(state.expansionsWithoutModules, isEmpty);
    });

    test('is true when an expansion is selected without any module', () {
      final state = GameSetupStateEntity(players: [], expansions: [chocolatl]);
      expect(state.hasIncompleteExpansion, isTrue);
      expect(state.expansionsWithoutModules, [chocolatl]);
    });

    test('is false once at least one module of the expansion is picked', () {
      final state = GameSetupStateEntity(
        players: [],
        expansions: [chocolatl],
        modules: [huts],
      );
      expect(state.hasIncompleteExpansion, isFalse);
      expect(state.expansionsWithoutModules, isEmpty);
    });

    test('ignores expansions that expose no modules (e.g. base game)', () {
      final base = BoardgameEntity(
        id: 1,
        name: 'Cacao',
        description: '',
        filenameImage: '',
      );
      final state = GameSetupStateEntity(players: [], expansions: [base]);
      expect(state.hasIncompleteExpansion, isFalse);
    });
  });
}
