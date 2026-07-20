import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/table_zone.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/tree_of_life_module_handler.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/preparation_fixtures.dart';
import '../../../../../support/tile_fixtures.dart';

void main() {
  group('TreeOfLifeModuleHandler', () {
    late TreeOfLifeModuleHandler handler;
    late List<TileEntity> mockTiles;
    late List<PlayerEntity> mockPlayers2;
    late List<PlayerEntity> mockPlayers3;
    late List<PlayerEntity> mockPlayers4;

    setUp(() {
      handler = TreeOfLifeModuleHandler();

      mockTiles = [
        makeTile(
          id: 'base.jungle_gold_mine_value_1',
          name: 'Gold Mine Value 1',
          quantity: 2,
          type: TileType.goldMine,
        ),
        makeTile(
          id: 'base.jungle_gold_mine_value_2',
          name: 'Gold Mine Value 2',
          quantity: 2,
          type: TileType.goldMine,
        ),
        makeTile(
          id: 'base.worker_red_1-1-1-1',
          name: '1-1-1-1',
          type: TileType.player,
          color: TileColor.red,
          quantity: 4,
        ),
        makeTile(
          id: 'base.worker_purple_1-1-1-1',
          name: '1-1-1-1',
          type: TileType.player,
          color: TileColor.purple,
          quantity: 4,
        ),
      ];

      mockPlayers2 = [
        PlayerEntity(name: 'Player 1', color: 'red'),
        PlayerEntity(name: 'Player 2', color: 'purple'),
      ];

      mockPlayers3 = [
        PlayerEntity(name: 'Player 1', color: 'red'),
        PlayerEntity(name: 'Player 2', color: 'purple'),
        PlayerEntity(name: 'Player 3', color: 'white'),
      ];

      mockPlayers4 = [
        PlayerEntity(name: 'Player 1', color: 'red'),
        PlayerEntity(name: 'Player 2', color: 'purple'),
        PlayerEntity(name: 'Player 3', color: 'white'),
        PlayerEntity(name: 'Player 4', color: 'yellow'),
      ];
    });

    group('modifyPreparationSteps', () {
      group('tile substitution steps - 2 players, no Chocolate', () {
        late List<PreparationEntity> stepsWithBaseRemovals;

        setUp(() {
          stepsWithBaseRemovals = [
            makePrepStep(
              id: 'setup_jungle_tiles_2p_removal_gold_mine_value_1',
              label: 'Return 1x Gold Mine, value 1 to the box',
              detail:
                  'Sort out 1x Gold Mine, value 1 and put it back in the box.',
              tableZone: TableZone.box,
              groupId: 'group_return_to_box',
              quantity: 1,
              imageKey: 'jungle_gold_mine_v1',
              phase: PreparationPhase.boardSetup,
            ),
            makePrepStep(
              id: 'setup_jungle_draw_pile',
              detail: 'Mix remaining jungle tiles.',
              phase: PreparationPhase.boardSetup,
            ),
            makePrepStep(
              id: 'setup_shuffle_workers',
              detail: 'Shuffle workers.',
              phase: PreparationPhase.playerSetup,
            ),
          ];
        });

        test('should modify base gold_mine_v1 step from 1x to 2x', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers2,
            mockTiles,
            stepsWithBaseRemovals,
          );

          final goldMineStep = result.firstWhere(
            (s) => s.id == 'setup_jungle_tiles_2p_removal_gold_mine_value_1',
          );
          expect(goldMineStep.detail, contains('2x Gold Mine'));
          expect(goldMineStep.quantity, equals(2));
          // copyWith keeps the structured fields of the base removal step.
          expect(goldMineStep.imageKey, equals('jungle_gold_mine_v1'));
          expect(goldMineStep.groupId, equals('group_return_to_box'));
          expect(goldMineStep.tableZone, equals(TableZone.box));
        });

        test('should add gold_mine_v2 removal step', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers2,
            mockTiles,
            stepsWithBaseRemovals,
          );

          final v2Step = result.where(
            (s) => s.id == 'setup_tree_of_life_remove_gold_mine_v2',
          );
          expect(v2Step, hasLength(1));
          expect(v2Step.first.detail, contains('1x Gold Mine, value 2'));
          expect(v2Step.first.imageKey, equals('jungle_gold_mine_v2'));
          expect(v2Step.first.groupId, equals('group_return_to_box'));
          expect(v2Step.first.tableZone, equals(TableZone.box));
          expect(v2Step.first.quantity, equals(1));
        });

        test('should add tree of life tiles step with quantity 2', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers2,
            mockTiles,
            stepsWithBaseRemovals,
          );

          final tolStep = result.where(
            (s) => s.id == 'setup_tree_of_life_add_tiles',
          );
          expect(tolStep, hasLength(1));
          expect(tolStep.first.detail, contains('2x Tree of Life'));
          expect(tolStep.first.imageKey, equals('jungle_tree_of_life'));
          expect(tolStep.first.quantity, equals(2));
        });

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
            final v2Index = result.indexWhere(
              (s) => s.id == 'setup_tree_of_life_remove_gold_mine_v2',
            );
            final addIndex = result.indexWhere(
              (s) => s.id == 'setup_tree_of_life_add_tiles',
            );

            expect(v2Index, lessThan(drawPileIndex));
            expect(addIndex, lessThan(drawPileIndex));
          },
        );

        test('should add 0-0-0-4 worker step for 2 players', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers2,
            mockTiles,
            stepsWithBaseRemovals,
          );

          final worker0004Steps = result.where(
            (s) => s.id.startsWith('setup_tree_of_life_add_0004_'),
          );
          expect(worker0004Steps, hasLength(2));
          for (final step in worker0004Steps) {
            expect(step.label, equals('Add your 0-0-0-4 worker tile'));
            expect(step.detail, contains('0-0-0-4 worker tile'));
            expect(step.groupId, equals('group_player_${step.color}'));
            expect(step.quantity, equals(1));
          }
        });

        test('should insert 0-0-0-4 steps before setup_shuffle_workers', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers2,
            mockTiles,
            stepsWithBaseRemovals,
          );

          final shuffleIndex = result.indexWhere(
            (s) => s.id == 'setup_shuffle_workers',
          );
          final worker0004Indexes = <int>[];
          for (int i = 0; i < result.length; i++) {
            if (result[i].id.startsWith('setup_tree_of_life_add_0004_')) {
              worker0004Indexes.add(i);
            }
          }

          for (final idx in worker0004Indexes) {
            expect(idx, lessThan(shuffleIndex));
          }
        });
      });

      group('tile substitution steps - 2 players, WITH Chocolate', () {
        late List<PreparationEntity> stepsWithChocolate;

        setUp(() {
          stepsWithChocolate = [
            makePrepStep(
              id: 'setup_jungle_draw_pile',
              detail: 'Mix remaining jungle tiles.',
              phase: PreparationPhase.boardSetup,
            ),
            makePrepStep(
              id: 'setup_resources_bank',
              detail: 'Resources bank.',
              tableZone: TableZone.supplies,
              phase: PreparationPhase.supplies,
            ),
            makePrepStep(
              id: 'setup_chocolate_bars',
              detail: 'Chocolate bars supply.',
              tableZone: TableZone.supplies,
              phase: PreparationPhase.supplies,
            ),
            makePrepStep(
              id: 'setup_shuffle_workers',
              detail: 'Shuffle workers.',
              phase: PreparationPhase.playerSetup,
            ),
          ];
        });

        test(
          'should NOT add gold mine removal steps when Chocolate is active',
          () {
            final result = handler.modifyPreparationSteps(
              mockPlayers2,
              mockTiles,
              stepsWithChocolate,
            );

            expect(
              result.any(
                (s) => s.id == 'setup_tree_of_life_remove_gold_mine_v1',
              ),
              isFalse,
            );
            expect(
              result.any(
                (s) => s.id == 'setup_tree_of_life_remove_gold_mine_v2',
              ),
              isFalse,
            );
          },
        );

        test('should only add tree of life tiles step', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers2,
            mockTiles,
            stepsWithChocolate,
          );

          final tolStep = result.where(
            (s) => s.id == 'setup_tree_of_life_add_tiles',
          );
          expect(tolStep, hasLength(1));
          expect(tolStep.first.detail, contains('2x Tree of Life'));
        });
      });

      group('tile substitution steps - 3+ players, no Chocolate', () {
        late List<PreparationEntity> stepsWithDrawPile;

        setUp(() {
          stepsWithDrawPile = [
            makePrepStep(
              id: 'setup_jungle_draw_pile',
              detail: 'Mix remaining jungle tiles.',
              phase: PreparationPhase.boardSetup,
            ),
            makePrepStep(
              id: 'setup_remove_worker_1_red',
              detail: 'Remove 1-1-1-1 for red.',
              phase: PreparationPhase.playerSetup,
            ),
            makePrepStep(
              id: 'setup_remove_worker_1_purple',
              detail: 'Remove 1-1-1-1 for purple.',
              phase: PreparationPhase.playerSetup,
            ),
            makePrepStep(
              id: 'setup_remove_worker_1_white',
              detail: 'Remove 1-1-1-1 for white.',
              phase: PreparationPhase.playerSetup,
            ),
          ];
        });

        test('should add all 3 substitution steps', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers3,
            mockTiles,
            stepsWithDrawPile,
          );

          expect(
            result.any((s) => s.id == 'setup_tree_of_life_remove_gold_mine_v1'),
            isTrue,
          );
          expect(
            result.any((s) => s.id == 'setup_tree_of_life_remove_gold_mine_v2'),
            isTrue,
          );
          expect(
            result.any((s) => s.id == 'setup_tree_of_life_add_tiles'),
            isTrue,
          );
        });

        test('should have correct quantities for 3+ players', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers3,
            mockTiles,
            stepsWithDrawPile,
          );

          final v1Step = result.firstWhere(
            (s) => s.id == 'setup_tree_of_life_remove_gold_mine_v1',
          );
          final v2Step = result.firstWhere(
            (s) => s.id == 'setup_tree_of_life_remove_gold_mine_v2',
          );
          final tolStep = result.firstWhere(
            (s) => s.id == 'setup_tree_of_life_add_tiles',
          );

          expect(v1Step.detail, contains('2x Gold Mine, value 1'));
          expect(v2Step.detail, contains('1x Gold Mine, value 2'));
          expect(tolStep.detail, contains('3x Tree of Life'));
        });

        test('should remove 1-1-1-1 worker removal steps for 3 players', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers3,
            mockTiles,
            stepsWithDrawPile,
          );

          expect(
            result.any((s) => s.id.startsWith('setup_remove_worker_1_')),
            isFalse,
          );
        });
      });

      group('tile substitution steps - 3+ players, WITH Chocolate', () {
        test('should only add tree of life tiles step with quantity 3', () {
          final stepsWithChocolate = [
            makePrepStep(
              id: 'setup_jungle_draw_pile',
              detail: 'Mix remaining jungle tiles.',
              phase: PreparationPhase.boardSetup,
            ),
            makePrepStep(
              id: 'setup_chocolate_bars',
              detail: 'Chocolate bars supply.',
              tableZone: TableZone.supplies,
              phase: PreparationPhase.supplies,
            ),
          ];

          final result = handler.modifyPreparationSteps(
            mockPlayers3,
            mockTiles,
            stepsWithChocolate,
          );

          final tolStep = result.where(
            (s) => s.id == 'setup_tree_of_life_add_tiles',
          );
          expect(tolStep, hasLength(1));
          expect(tolStep.first.detail, contains('3x Tree of Life'));

          expect(
            result.any((s) => s.id == 'setup_tree_of_life_remove_gold_mine_v1'),
            isFalse,
          );
          expect(
            result.any((s) => s.id == 'setup_tree_of_life_remove_gold_mine_v2'),
            isFalse,
          );
        });
      });

      group('worker tile adjustments', () {
        test('should remove 2-1-0-1 worker removal steps for 4 players', () {
          final stepsWith4p = [
            makePrepStep(
              id: 'setup_jungle_draw_pile',
              detail: 'Mix remaining jungle tiles.',
              phase: PreparationPhase.boardSetup,
            ),
            makePrepStep(
              id: 'setup_remove_worker_1_red',
              detail: 'Remove 1-1-1-1 for red.',
              phase: PreparationPhase.playerSetup,
            ),
            makePrepStep(
              id: 'setup_remove_worker_2_red',
              detail: 'Remove 2-1-0-1 for red.',
              phase: PreparationPhase.playerSetup,
            ),
            makePrepStep(
              id: 'setup_remove_worker_1_purple',
              detail: 'Remove 1-1-1-1 for purple.',
              phase: PreparationPhase.playerSetup,
            ),
            makePrepStep(
              id: 'setup_remove_worker_2_purple',
              detail: 'Remove 2-1-0-1 for purple.',
              phase: PreparationPhase.playerSetup,
            ),
          ];

          final result = handler.modifyPreparationSteps(
            mockPlayers4,
            mockTiles,
            stepsWith4p,
          );

          // 2-1-0-1 removals should be gone
          expect(
            result.any((s) => s.id.startsWith('setup_remove_worker_2_')),
            isFalse,
          );
          // 1-1-1-1 removals should remain
          expect(
            result.any((s) => s.id.startsWith('setup_remove_worker_1_')),
            isTrue,
          );
        });
      });
    });
  });
}
