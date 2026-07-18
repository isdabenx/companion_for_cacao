import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/utils/preparation_image_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PreparationImageResolver', () {
    group('prefix-based keys', () {
      test('resolves village_board_<color> keys', () {
        expect(
          'village_board_red'.toAssetPath(),
          '${Assets.preparationVillagePrefix}red'
          '${Assets.preparationVillageSufix}',
        );
        expect(
          'village_board_yellow'.toAssetPath(),
          '${Assets.preparationVillagePrefix}yellow'
          '${Assets.preparationVillageSufix}',
        );
      });

      test('resolves carrier_<color> keys', () {
        expect(
          'carrier_purple'.toAssetPath(),
          '${Assets.preparationCarrierPrefix}purple'
          '${Assets.preparationCarrierSufix}',
        );
      });

      test('resolves tile_back_<color> keys', () {
        expect(
          'tile_back_white'.toAssetPath(),
          '${Assets.preparationTilePrefix}white'
          '${Assets.preparationTileSufix}',
        );
      });

      test('resolves tile_<filename> keys to the tiles image path', () {
        expect(
          'tile_base/temple.webp'.toAssetPath(),
          '${Assets.imagesTilePath}base/temple.webp',
        );
      });
    });

    group('literal keys', () {
      const expectedMappings = <String, String>{
        'initial_tiles_cacao': Assets.preparationInitialTilesCacao,
        'resources_cacao': Assets.preparationResourcesCacao,
        'resources_chocolate': Assets.preparationChocolateBar,
        'map_token': Assets.preparationMapToken,
        'map_board': Assets.preparationMapBoard,
        'initial_single_plantation_water':
            Assets.preparationInitialTilesWatering,
        'resources_gems': Assets.preparationGems,
        'resources_mine_car': Assets.preparationMineCar,
        'resources_masks': Assets.preparationMasks,
        'emperor_figure': Assets.preparationEmperor,
        'jungle_single_plantation': Assets.jungleSinglePlantation,
        'jungle_double_plantation': Assets.jungleDoublePlantation,
        'jungle_market_selling_2': Assets.jungleMarketSelling2,
        'jungle_market_selling_3': Assets.jungleMarketSelling3,
        'jungle_gold_mine_v1': Assets.jungleGoldMineV1,
        'jungle_gold_mine_v2': Assets.jungleGoldMineV2,
        'jungle_water': Assets.jungleWater,
        'jungle_sun_worshiping_site': Assets.jungleSunWorshipingSite,
        'jungle_temple': Assets.jungleTemple,
        'jungle_watering': Assets.jungleWatering,
        'jungle_chocolate_kitchen': Assets.jungleChocolateKitchen,
        'jungle_chocolate_market': Assets.jungleChocolateMarket,
        'jungle_gem_mine': Assets.jungleGemMine,
        'jungle_tree_of_life': Assets.jungleTreeOfLife,
      };

      for (final entry in expectedMappings.entries) {
        test('resolves "${entry.key}" to its asset path', () {
          expect(entry.key.toAssetPath(), entry.value);
        });
      }
    });

    group('unknown keys', () {
      test('returns the key itself for an unknown key', () {
        expect('some_unknown_key'.toAssetPath(), 'some_unknown_key');
      });

      test('returns the empty string unchanged', () {
        expect(''.toAssetPath(), '');
      });
    });
  });
}
