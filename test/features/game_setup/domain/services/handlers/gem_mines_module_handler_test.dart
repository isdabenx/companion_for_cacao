import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/gem_mines_module_handler.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/tile_fixtures.dart';

void main() {
  group('GemMinesModuleHandler', () {
    late GemMinesModuleHandler handler;
    late List<TileModel> mockTiles;
    late List<PlayerEntity> mockPlayers2;
    late List<PlayerEntity> mockPlayers3;

    setUp(() {
      handler = GemMinesModuleHandler();

      mockTiles = [
        makeTile(
          id: 'base.jungle_temple',
          name: 'Temple',
          quantity: 5,
          type: TileType.temple,
        ),
        makeTile(
          id: 'base.jungle_single_plantation',
          name: 'Single Plantation',
          quantity: 6,
          type: TileType.plantation,
        ),
      ];

      mockPlayers2 = [
        PlayerEntity(name: 'Player 1', color: 'red'),
        PlayerEntity(name: 'Player 2', color: 'blue'),
      ];

      mockPlayers3 = [
        PlayerEntity(name: 'Player 1', color: 'red'),
        PlayerEntity(name: 'Player 2', color: 'blue'),
        PlayerEntity(name: 'Player 3', color: 'white'),
      ];
    });

    group('adjustTiles', () {
      test('should remove all temples and add 4 gem mines for 2 players', () {
        final result = handler.adjustTiles(
          mockTiles,
          2,
          activeExpansions: [_createMockExpansion()],
        );

        final temples = result.where((t) => t.type == TileType.temple);
        final gemMines = result.where((t) => t.type == TileType.gemMine);

        expect(temples, isEmpty);
        expect(gemMines, hasLength(1));
        expect(gemMines.first.quantity, equals(4)); // 5 - 1 = 4
      });

      test('should remove all temples and add 5 gem mines for 3+ players', () {
        final result = handler.adjustTiles(
          mockTiles,
          3,
          activeExpansions: [_createMockExpansion()],
        );

        final temples = result.where((t) => t.type == TileType.temple);
        final gemMines = result.where((t) => t.type == TileType.gemMine);

        expect(temples, isEmpty);
        expect(gemMines, hasLength(1));
        expect(gemMines.first.quantity, equals(5));
      });

      test('should have correct moduleId', () {
        expect(GemMinesModuleHandler.moduleId, equals(5));
      });
    });

    group('modifyPreparationSteps', () {
      group('tile substitution steps', () {
        late List<PreparationEntity> stepsWithBaseRemovals;

        setUp(() {
          stepsWithBaseRemovals = [
            const PreparationEntity(
              id: 'setup_jungle_tiles_2p_removal_temple',
              description: 'Sort out 1x Temple and put it back in the box',
              imageKey: 'jungle_temple',
              phase: PreparationPhase.boardSetup,
            ),
            const PreparationEntity(
              id: 'setup_jungle_draw_pile',
              description: 'Mix remaining jungle tiles',
              phase: PreparationPhase.boardSetup,
            ),
            const PreparationEntity(
              id: 'setup_resources_bank',
              description: 'Resources bank',
              phase: PreparationPhase.supplies,
            ),
          ];
        });

        test('should remove base temple removal step for 2 players', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers2,
            mockTiles,
            stepsWithBaseRemovals,
          );

          expect(
            result.any((s) => s.id == 'setup_jungle_tiles_2p_removal_temple'),
            isFalse,
          );
        });

        test('should add "sort out all temples" step for 2 players', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers2,
            mockTiles,
            stepsWithBaseRemovals,
          );

          final templeStep = result.where(
            (s) => s.id == 'setup_gem_mines_remove_temples',
          );
          expect(templeStep, hasLength(1));
          expect(templeStep.first.description, contains('all Temple tiles'));
          expect(templeStep.first.imageKey, equals('jungle_temple'));
        });

        test(
          'should add gem mine tiles step with correct quantity for 2 players',
          () {
            final result = handler.modifyPreparationSteps(
              mockPlayers2,
              mockTiles,
              stepsWithBaseRemovals,
            );

            final gemStep = result.where(
              (s) => s.id == 'setup_gem_mines_add_gem_mines',
            );
            expect(gemStep, hasLength(1));
            expect(gemStep.first.description, contains('4x Gem Mine'));
            expect(gemStep.first.imageKey, equals('jungle_gem_mine'));
          },
        );

        test(
          'should add gem mine tiles step with correct quantity for 3+ players',
          () {
            final stepsWithDrawPile = [
              const PreparationEntity(
                id: 'setup_jungle_draw_pile',
                description: 'Mix remaining jungle tiles',
                phase: PreparationPhase.boardSetup,
              ),
              const PreparationEntity(
                id: 'setup_resources_bank',
                description: 'Resources bank',
                phase: PreparationPhase.supplies,
              ),
            ];

            final result = handler.modifyPreparationSteps(
              mockPlayers3,
              mockTiles,
              stepsWithDrawPile,
            );

            final gemStep = result.where(
              (s) => s.id == 'setup_gem_mines_add_gem_mines',
            );
            expect(gemStep, hasLength(1));
            expect(gemStep.first.description, contains('5x Gem Mine'));
          },
        );

        test(
          'should insert substitution steps before setup_jungle_draw_pile',
          () {
            final result = handler.modifyPreparationSteps(
              mockPlayers2,
              mockTiles,
              stepsWithBaseRemovals,
            );

            final drawPileIndex = result.indexWhere(
              (s) => s.id == 'setup_jungle_draw_pile',
            );
            final templeIndex = result.indexWhere(
              (s) => s.id == 'setup_gem_mines_remove_temples',
            );
            final gemIndex = result.indexWhere(
              (s) => s.id == 'setup_gem_mines_add_gem_mines',
            );

            expect(templeIndex, lessThan(drawPileIndex));
            expect(gemIndex, lessThan(drawPileIndex));
            expect(templeIndex, lessThan(gemIndex));
          },
        );
      });

      group('gem mines supplies steps', () {
        test('should add remove gems step for 2 players', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers2,
            mockTiles,
            [],
          );

          final removeGemsStep = result.where(
            (s) => s.id == 'setup_gem_mines_remove_gems',
          );
          expect(removeGemsStep, hasLength(1));
          expect(removeGemsStep.first.description, contains('Remove 8 gems'));
          expect(removeGemsStep.first.phase, equals(PreparationPhase.supplies));
          expect(removeGemsStep.first.imageKey, equals('resources_gems'));
        });

        test('should NOT add remove gems step for 3+ players', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers3,
            mockTiles,
            [],
          );

          final removeGemsStep = result.where(
            (s) => s.id == 'setup_gem_mines_remove_gems',
          );
          expect(removeGemsStep, isEmpty);
        });

        test('should add mine car step for 2 players', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers2,
            mockTiles,
            [],
          );

          final mineCarStep = result.where(
            (s) => s.id == 'setup_gem_mines_mine_car',
          );
          expect(mineCarStep, hasLength(1));
          expect(
            mineCarStep.first.description,
            contains('remaining gems into the mine car'),
          );
          expect(mineCarStep.first.imageKey, equals('resources_mine_car'));
        });

        test('should add mine car step for 3+ players', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers3,
            mockTiles,
            [],
          );

          final mineCarStep = result.where(
            (s) => s.id == 'setup_gem_mines_mine_car',
          );
          expect(mineCarStep, hasLength(1));
          expect(mineCarStep.first.description, contains('Fill all 32 gems'));
        });

        test('should add masks step with 2-player rules', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers2,
            mockTiles,
            [],
          );

          final masksStep = result.where(
            (s) => s.id == 'setup_gem_mines_masks',
          );
          expect(masksStep, hasLength(1));
          expect(
            masksStep.first.description,
            contains('without the value 12 mask'),
          );
          expect(masksStep.first.phase, equals(PreparationPhase.supplies));
          expect(masksStep.first.imageKey, equals('resources_masks'));
        });

        test('should add masks step with 3+-player rules', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers3,
            mockTiles,
            [],
          );

          final masksStep = result.where(
            (s) => s.id == 'setup_gem_mines_masks',
          );
          expect(masksStep, hasLength(1));
          expect(masksStep.first.description, contains('7 masks'));
        });

        test('should add rule reminder step', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers2,
            mockTiles,
            [],
          );

          final reminderStep = result.where(
            (s) => s.id == 'setup_gem_mines_rule_reminder',
          );
          expect(reminderStep, hasLength(1));
          expect(reminderStep.first.description, contains('shake out 6 gems'));
        });
      });
    });
  });
}

// Helper to create mock expansions with gem mine tile
BoardgameModel _createMockExpansion() {
  return makeBoardgame(
    id: 3,
    name: 'Diamante',
    tiles: [
      makeTile(
        id: 'diamante.jungle_gem_mine',
        name: 'Gem Mine',
        filenameImage: 'diamante/gem_mine.webp',
        quantity: 5,
        type: TileType.gemMine,
        boardgameId: 3,
        moduleId: GemMinesModuleHandler.moduleId,
      ),
    ],
  );
}
