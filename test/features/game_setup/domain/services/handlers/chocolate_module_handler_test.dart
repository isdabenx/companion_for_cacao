import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/chocolate_module_handler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChocolateModuleHandler', () {
    late ChocolateModuleHandler handler;
    late List<TileModel> mockTiles;
    late List<PlayerEntity> mockPlayers;
    late List<PreparationEntity> mockPreparationSteps;

    setUp(() {
      handler = ChocolateModuleHandler();

      mockTiles = [
        _createTile(
          id: 'base.jungle_gold_mine_value_1',
          name: 'Gold Mine Value 1',
          quantity: 4,
          type: TileType.goldMine,
        ),
        _createTile(
          id: 'base.jungle_gold_mine_value_2',
          name: 'Gold Mine Value 2',
          quantity: 2,
          type: TileType.goldMine,
        ),
        _createTile(
          id: 'base.jungle_market_selling_3',
          name: 'Market Selling 3',
          quantity: 5,
          type: TileType.market,
        ),
        _createTile(
          id: 'chocolatl.jungle_chocolate_kitchen',
          name: 'Chocolate Kitchen',
          quantity: 0,
          type: TileType.chocolateKitchen,
        ),
        _createTile(
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

        expect(result.length, equals(mockPreparationSteps.length + 1));

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

          expect(result.length, equals(stepsWithoutBank.length));
          expect(
            result.any((step) => step.id == 'setup_chocolate_bars'),
            isFalse,
          );
        },
      );
    });
  });
}

// Helper function to create mock tiles
TileModel _createTile({
  required String id,
  required String name,
  required int quantity,
  required TileType type,
}) {
  return TileModel(
    id: id,
    name: name,
    description: 'Test description',
    filenameImage: 'test.png',
    quantity: quantity,
    type: type,
    boardgameId: 1,
  );
}

// Helper to create mock expansions with chocolate tiles
BoardgameModel _createMockExpansion() {
  return BoardgameModel(
    id: 2,
    name: 'Chocolatl',
    description: 'Test Expansion',
    filenameImage: 'test.png',
    tiles: [
      _createTile(
        id: 'chocolatl.jungle_chocolate_kitchen',
        name: 'Chocolate Kitchen',
        quantity: 3,
        type: TileType.chocolateKitchen,
      ),
      _createTile(
        id: 'chocolatl.jungle_chocolate_market',
        name: 'Chocolate Market',
        quantity: 3,
        type: TileType.chocolateMarket,
      ),
    ],
  );
}
