import 'dart:ui';

import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/module_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/utils/catalog_l10n.dart';
import 'package:flutter_test/flutter_test.dart';

/// Every non-worker catalog id seeded from tiles.json. A new tile added to
/// the seed without its ARB keys will fail the parity check below.
const catalogTileIds = [
  'base.jungle_single_plantation',
  'base.jungle_double_plantation',
  'base.jungle_market_selling_2',
  'base.jungle_market_selling_3',
  'base.jungle_market_selling_4',
  'base.jungle_gold_mine_value_1',
  'base.jungle_gold_mine_value_2',
  'base.jungle_water',
  'base.jungle_sun_worshiping_site',
  'base.jungle_temple',
  'chocolatl.jungle_watering',
  'chocolatl.jungle_chocolate_kitchen',
  'chocolatl.jungle_chocolate_market',
  'chocolatl.hut_market_crier',
  'chocolatl.hut_hermit',
  'chocolatl.hut_road_worker',
  'chocolatl.hut_trader',
  'chocolatl.hut_farmer',
  'chocolatl.hut_shaman',
  'chocolatl.hut_monk',
  'chocolatl.hut_master_builder',
  'chocolatl.hut_foreman',
  'chocolatl.hut_fountain_master',
  'chocolatl.hut_chiefs_daughter',
  'chocolatl.hut_chiefs_son',
  'chocolatl.hut_chiefs_wife',
  'chocolatl.hut_chief',
  'diamante.jungle_gem_mine',
  'diamante.jungle_tree_of_life',
];

TileEntity tileWithId(String id) => TileEntity(
  id: id,
  // Empty fallbacks: a non-empty localized value proves the id resolved
  // through the ARB catalog instead of falling back to the entity.
  name: '',
  description: '',
  filenameImage: '',
  quantity: 1,
);

void main() {
  group('catalog l10n parity (en/ca/es)', () {
    for (final locale in const [Locale('en'), Locale('ca'), Locale('es')]) {
      final l10n = lookupAppLocalizations(locale);

      test('every catalog tile resolves name and description for $locale', () {
        for (final id in catalogTileIds) {
          final tile = tileWithId(id);
          expect(
            tile.localizedName(l10n).trim(),
            isNotEmpty,
            reason: 'name of $id',
          );
          expect(
            tile.localizedDescription(l10n).trim(),
            isNotEmpty,
            reason: 'description of $id',
          );
        }
      });

      test('worker tiles get a localized description for $locale', () {
        final worker = TileEntity(
          id: 'base.worker_red_1-1-1-1',
          name: '1-1-1-1',
          description: '',
          filenameImage: '',
          quantity: 4,
          type: TileType.player,
          color: TileColor.red,
        );
        // The distribution pattern stays language-neutral.
        expect(worker.localizedName(l10n), '1-1-1-1');
        final description = worker.localizedDescription(l10n);
        expect(description, contains('1-1-1-1'));
        expect(description, contains(TileColor.red.localizedName(l10n)));
      });

      test('boardgames, modules and tile types resolve for $locale', () {
        for (final id in [1, 2, 3]) {
          final boardgame = BoardgameEntity(
            id: id,
            name: '',
            description: '',
            filenameImage: '',
          );
          expect(
            boardgame.localizedName(l10n).trim(),
            isNotEmpty,
            reason: 'boardgame $id',
          );
        }
        for (var id = 1; id <= 8; id++) {
          final module = ModuleEntity(id: id, name: '', description: '');
          expect(
            module.localizedName(l10n).trim(),
            isNotEmpty,
            reason: 'module $id name',
          );
          expect(
            module.localizedDescription(l10n).trim(),
            isNotEmpty,
            reason: 'module $id description',
          );
        }
        for (final type in TileType.values) {
          expect(
            type.localizedName(l10n).trim(),
            isNotEmpty,
            reason: 'tile type $type',
          );
        }
      });
    }

    test('unknown ids fall back to the entity fields', () {
      final l10n = lookupAppLocalizations(const Locale('en'));
      final tile = TileEntity(
        id: 'future.new_tile',
        name: 'Seeded name',
        description: 'Seeded description',
        filenameImage: '',
        quantity: 1,
      );
      expect(tile.localizedName(l10n), 'Seeded name');
      expect(tile.localizedDescription(l10n), 'Seeded description');
      expect(
        ModuleEntity(
          id: 99,
          name: 'Seeded',
          description: 'D',
        ).localizedName(l10n),
        'Seeded',
      );
    });

    test('uses the official Devir terminology in Spanish and Catalan', () {
      final es = lookupAppLocalizations(const Locale('es'));
      final ca = lookupAppLocalizations(const Locale('ca'));

      // The expansion is "Xocolatl" in the Devir edition, not "Chocolatl".
      final chocolatl = BoardgameEntity(
        id: 2,
        name: 'Cacao: Chocolatl',
        description: '',
        filenameImage: '',
      );
      expect(chocolatl.localizedName(es), 'Cacao: Xocolatl');
      expect(chocolatl.localizedName(ca), 'Cacao: Xocolatl');

      final newWorkers = ModuleEntity(id: 8, name: '', description: '');
      expect(newWorkers.localizedName(es), 'Los nuevos recolectores');
      expect(newWorkers.localizedName(ca), 'Els nous recol·lectors');

      // Devir terms inside descriptions: recolectores / recol·lectors.
      final plantation = tileWithId('base.jungle_single_plantation');
      expect(plantation.localizedDescription(es), contains('recolector'));
      expect(plantation.localizedDescription(ca), contains('recol·lector'));
    });
  });
}
