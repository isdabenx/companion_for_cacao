import 'dart:convert';
import 'dart:io';

import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/core/domain/entities/hut_type.dart';
import 'package:companion_for_cacao/shared/utils/hut_type_assets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Cross-checks HutTypeAssets against the REAL catalog (tiles.json) and the
/// bundled image files, so the mapping can never drift from the seed data
/// again (a `tileId` mismatch made registered hut throws silently skip the
/// Chief family when filtering the tiles in play).
void main() {
  late Map<String, Map<String, dynamic>> catalogById;

  setUpAll(() {
    final raw = File('assets/initial_data/tiles.json').readAsStringSync();
    final tiles = (json.decode(raw) as List<dynamic>)
        .cast<Map<String, dynamic>>();
    catalogById = {for (final tile in tiles) tile['id'] as String: tile};
  });

  test('every HutType.tileId exists in tiles.json', () {
    for (final hut in HutType.values) {
      expect(
        catalogById,
        contains(hut.tileId),
        reason: '${hut.name}: no catalog tile with id ${hut.tileId}',
      );
    }
  });

  test('every HutType.imageAsset matches its catalog filenameImage', () {
    for (final hut in HutType.values) {
      final filenameImage = catalogById[hut.tileId]?['filenameImage'];
      expect(
        hut.imageAsset,
        '${Assets.imagesTilePath}$filenameImage',
        reason: '${hut.name}: imageAsset diverges from the catalog',
      );
    }
  });

  test('every HutType.imageAsset file is bundled', () {
    for (final hut in HutType.values) {
      expect(
        File(hut.imageAsset).existsSync(),
        isTrue,
        reason: '${hut.name}: missing image file ${hut.imageAsset}',
      );
    }
  });
}
