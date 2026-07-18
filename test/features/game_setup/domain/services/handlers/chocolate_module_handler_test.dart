import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/chocolate_module_handler.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/tile_fixtures.dart';

void main() {
  group('ChocolateModuleHandler', () {
    late ChocolateModuleHandler handler;
    late List<TileEntity> mockTiles;
    late List<PlayerEntity> mockPlayers;
    late List<PreparationEntity> mockPreparationSteps;

    setUp(() {
      handler = ChocolateModuleHandler();

      mockTiles = [
        makeTile(
          id: 'base.jungle_gold_mine_value_1',
          name: 'Gold Mine Value 1',
          quantity: 4,
          type: TileType.goldMine,
        ),
        makeTile(
          id: 'base.jungle_gold_mine_value_2',
          name: 'Gold Mine Value 2',
          quantity: 2,
          type: TileType.goldMine,
        ),
        makeTile(
          id: 'base.jungle_market_selling_3',
          name: 'Market Selling 3',
          quantity: 5,
          type: TileType.market,
        ),
        makeTile(
          id: 'chocolatl.jungle_chocolate_kitchen',
          name: 'Chocolate Kitchen',
          quantity: 0,
          type: TileType.chocolateKitchen,
        ),
        makeTile(
          id: 'chocolatl.jungle_chocolate_market',
          name: 'Chocolate Market',
          quantity: 0,
          type: TileType.chocolateMarket,
        ),
      ];

      mockPlayers = [
        PlayerEntity(name: 'Player 1', color: 'red'),
        PlayerEntity(name: 'Player 2', color: 'blue'),
      ];

      mockPreparationSteps = [
        const PreparationEntity(
          id: 'setup_resources_bank',
          description: 'Setup resources bank',
          phase: PreparationPhase.supplies,
        ),
        const PreparationEntity(
          id: 'step_1',
          description: 'Another step',
          phase: PreparationPhase.supplies,
        ),
      ];
    });

    group('adjustTiles', () {
      test(
        'should remove correct tiles and add chocolate tiles for 2 players',
        () {
          final result = handler.adjustTiles(
            mockTiles,
            2,
            activeExpansions: [_createMockExpansion()],
          );

          final goldMine1 = result.firstWhere(
            (t) => t.id == 'base.jungle_gold_mine_value_1',
          );
          final goldMine2 = result.firstWhere(
            (t) => t.id == 'base.jungle_gold_mine_value_2',
          );
          final market3 = result.firstWhere(
            (t) => t.id == 'base.jungle_market_selling_3',
          );
          final kitchen = result.firstWhere(
            (t) => t.id == 'chocolatl.jungle_chocolate_kitchen',
          );
          final market = result.firstWhere(
            (t) => t.id == 'chocolatl.jungle_chocolate_market',
          );

          // 2 players: remove 1 gold mine value 1, 1 gold mine value 2, 2 markets selling 3
          expect(goldMine1.quantity, equals(3)); // 4 - 1
          expect(goldMine2.quantity, equals(1)); // 2 - 1
          expect(market3.quantity, equals(3)); // 5 - 2

          // Add 2 chocolate kitchens, 2 chocolate markets
          expect(kitchen.quantity, equals(2)); // 0 + 2
          expect(market.quantity, equals(2)); // 0 + 2
        },
      );

      test(
        'should remove correct tiles and add chocolate tiles for 3+ players',
        () {
          final result = handler.adjustTiles(
            mockTiles,
            3,
            activeExpansions: [_createMockExpansion()],
          );

          final goldMine1 = result.firstWhere(
            (t) => t.id == 'base.jungle_gold_mine_value_1',
          );
          final goldMine2 = result.firstWhere(
            (t) => t.id == 'base.jungle_gold_mine_value_2',
          );
          final market3 = result.firstWhere(
            (t) => t.id == 'base.jungle_market_selling_3',
          );
          final kitchen = result.firstWhere(
            (t) => t.id == 'chocolatl.jungle_chocolate_kitchen',
          );
          final market = result.firstWhere(
            (t) => t.id == 'chocolatl.jungle_chocolate_market',
          );

          // 3+ players: remove 2 gold mine value 1, 1 gold mine value 2, 3 markets selling 3
          expect(goldMine1.quantity, equals(2)); // 4 - 2
          expect(goldMine2.quantity, equals(1)); // 2 - 1
          expect(market3.quantity, equals(2)); // 5 - 3

          // Add 3 chocolate kitchens, 3 chocolate markets
          expect(kitchen.quantity, equals(3)); // 0 + 3
          expect(market.quantity, equals(3)); // 0 + 3
        },
      );

      test('should have correct moduleId', () {
        expect(ChocolateModuleHandler.moduleId, equals(3));
      });
    });

    group('modifyPreparationSteps', () {
      test('should insert setup_chocolate_bars after setup_resources_bank', () {
        final result = handler.modifyPreparationSteps(
          mockPlayers,
          mockTiles,
          mockPreparationSteps,
        );

        final resourceBankIndex = result.indexWhere(
          (step) => step.id == 'setup_resources_bank',
        );
        final chocolateBarsIndex = result.indexWhere(
          (step) => step.id == 'setup_chocolate_bars',
        );

        expect(resourceBankIndex, greaterThanOrEqualTo(0));
        expect(chocolateBarsIndex, equals(resourceBankIndex + 1));
        expect(
          result[chocolateBarsIndex].phase,
          equals(PreparationPhase.supplies),
        );
      });

      test(
        'should not insert setup_chocolate_bars if setup_resources_bank is missing',
        () {
          final stepsWithoutBank = [
            const PreparationEntity(
              id: 'step_1',
              description: 'Another step',
              phase: PreparationPhase.supplies,
            ),
          ];

          final result = handler.modifyPreparationSteps(
            mockPlayers,
            mockTiles,
            stepsWithoutBank,
          );

          expect(
            result.any((step) => step.id == 'setup_chocolate_bars'),
            isFalse,
          );
        },
      );

      group('tile substitution steps for 2 players', () {
        late List<PreparationEntity> stepsWithBaseRemovals;

        setUp(() {
          stepsWithBaseRemovals = [
            const PreparationEntity(
              id: 'setup_jungle_tiles_2p_removal_gold_mine_value_1',
              description:
                  'Sort out 1x Gold Mine, value 1 and put it back in the box',
              imageKey: 'jungle_gold_mine_v1',
              phase: PreparationPhase.boardSetup,
            ),
            const PreparationEntity(
              id: 'setup_jungle_tiles_2p_removal_market_selling_3',
              description:
                  'Sort out 1x Market, selling price 3 and put it back in the box',
              imageKey: 'jungle_market_selling_3',
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

        test('should modify base gold_mine_v1 step from 1x to 2x', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers,
            mockTiles,
            stepsWithBaseRemovals,
          );

          final goldMineStep = result.firstWhere(
            (s) => s.id == 'setup_jungle_tiles_2p_removal_gold_mine_value_1',
          );
          expect(goldMineStep.description, contains('2x Gold Mine'));
        });

        test('should modify base market_selling_3 step from 1x to 3x', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers,
            mockTiles,
            stepsWithBaseRemovals,
          );

          final marketStep = result.firstWhere(
            (s) => s.id == 'setup_jungle_tiles_2p_removal_market_selling_3',
          );
          expect(marketStep.description, contains('3x Market'));
        });

        test('should add gold_mine_v2 removal step', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers,
            mockTiles,
            stepsWithBaseRemovals,
          );

          final v2Step = result.where(
            (s) => s.id == 'setup_chocolate_remove_gold_mine_v2',
          );
          expect(v2Step, hasLength(1));
          expect(v2Step.first.description, contains('1x Gold Mine, value 2'));
          expect(v2Step.first.imageKey, equals('jungle_gold_mine_v2'));
        });

        test('should add chocolate kitchen and market addition steps', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers,
            mockTiles,
            stepsWithBaseRemovals,
          );

          final kitchenStep = result.where(
            (s) => s.id == 'setup_chocolate_add_kitchen',
          );
          final marketStep = result.where(
            (s) => s.id == 'setup_chocolate_add_market',
          );

          expect(kitchenStep, hasLength(1));
          expect(marketStep, hasLength(1));
          expect(
            kitchenStep.first.description,
            contains('2x Chocolate Kitchen'),
          );
          expect(marketStep.first.description, contains('2x Chocolate Market'));
        });

        test(
          'should insert substitution steps before setup_jungle_draw_pile',
          () {
            final result = handler.modifyPreparationSteps(
              mockPlayers,
              mockTiles,
              stepsWithBaseRemovals,
            );

            final drawPileIndex = result.indexWhere(
              (s) => s.id == 'setup_jungle_draw_pile',
            );
            final v2Index = result.indexWhere(
              (s) => s.id == 'setup_chocolate_remove_gold_mine_v2',
            );
            final kitchenIndex = result.indexWhere(
              (s) => s.id == 'setup_chocolate_add_kitchen',
            );

            expect(v2Index, lessThan(drawPileIndex));
            expect(kitchenIndex, lessThan(drawPileIndex));
          },
        );
      });

      group('tile substitution steps for 3+ players', () {
        late List<PreparationEntity> stepsWithDrawPile;
        late List<PlayerEntity> players3;

        setUp(() {
          players3 = [
            PlayerEntity(name: 'Player 1', color: 'red'),
            PlayerEntity(name: 'Player 2', color: 'blue'),
            PlayerEntity(name: 'Player 3', color: 'white'),
          ];

          stepsWithDrawPile = [
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

        test('should add all 5 substitution steps for 3+ players', () {
          final result = handler.modifyPreparationSteps(
            players3,
            mockTiles,
            stepsWithDrawPile,
          );

          expect(
            result.any((s) => s.id == 'setup_chocolate_remove_gold_mine_v1'),
            isTrue,
          );
          expect(
            result.any((s) => s.id == 'setup_chocolate_remove_gold_mine_v2'),
            isTrue,
          );
          expect(
            result.any(
              (s) => s.id == 'setup_chocolate_remove_market_selling_3',
            ),
            isTrue,
          );
          expect(
            result.any((s) => s.id == 'setup_chocolate_add_kitchen'),
            isTrue,
          );
          expect(
            result.any((s) => s.id == 'setup_chocolate_add_market'),
            isTrue,
          );
        });

        test(
          'should have correct quantities in descriptions for 3+ players',
          () {
            final result = handler.modifyPreparationSteps(
              players3,
              mockTiles,
              stepsWithDrawPile,
            );

            final v1Step = result.firstWhere(
              (s) => s.id == 'setup_chocolate_remove_gold_mine_v1',
            );
            final v2Step = result.firstWhere(
              (s) => s.id == 'setup_chocolate_remove_gold_mine_v2',
            );
            final marketStep = result.firstWhere(
              (s) => s.id == 'setup_chocolate_remove_market_selling_3',
            );
            final kitchenStep = result.firstWhere(
              (s) => s.id == 'setup_chocolate_add_kitchen',
            );
            final mktStep = result.firstWhere(
              (s) => s.id == 'setup_chocolate_add_market',
            );

            expect(v1Step.description, contains('2x Gold Mine, value 1'));
            expect(v2Step.description, contains('1x Gold Mine, value 2'));
            expect(marketStep.description, contains('3x Market'));
            expect(kitchenStep.description, contains('3x Chocolate Kitchen'));
            expect(mktStep.description, contains('3x Chocolate Market'));
          },
        );
      });
    });
  });
}

// Helper to create mock expansions with chocolate tiles
BoardgameEntity _createMockExpansion() {
  return makeBoardgame(
    id: 2,
    name: 'Chocolatl',
    tiles: [
      makeTile(
        id: 'chocolatl.jungle_chocolate_kitchen',
        name: 'Chocolate Kitchen',
        quantity: 3,
        type: TileType.chocolateKitchen,
        boardgameId: 2,
        moduleId: ChocolateModuleHandler.moduleId,
      ),
      makeTile(
        id: 'chocolatl.jungle_chocolate_market',
        name: 'Chocolate Market',
        quantity: 3,
        type: TileType.chocolateMarket,
        boardgameId: 2,
        moduleId: ChocolateModuleHandler.moduleId,
      ),
    ],
  );
}
