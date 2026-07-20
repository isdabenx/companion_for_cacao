import 'dart:ui';

import 'package:companion_for_cacao/features/game_setup/domain/content/preparation_l10n.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PreparationL10n', () {
    // Every supported locale must produce non-empty content for the
    // preparation strings — a missing translation would silently fall
    // back at runtime, so this parity check catches it in CI.
    for (final locale in const [Locale('en'), Locale('ca'), Locale('es')]) {
      test('provides non-empty content for $locale', () {
        final copy = PreparationL10n.forLocale(locale);

        final samples = <String>[
          copy.villageBoardLabel,
          copy.villageBoardDetail('red'),
          copy.waterCarrierDetail('white'),
          copy.removeWorkerLabel('1-1-1-1'),
          copy.shuffleWorkersDetail,
          copy.initialTilesMarketDetail,
          copy.removeTilesLabel(2, copy.tileSinglePlantation),
          copy.removeTilesDetail(1, copy.tileTemple),
          copy.addTilesDetail(3, copy.tileTreeOfLife),
          copy.mapTokensDetail('purple'),
          copy.hutsMarketDetail,
          copy.gemMinesReminderDetail,
          copy.treeOfLife0004Detail('yellow'),
          copy.emperorOnWaterDetail,
          copy.newWorkersSelectionLabel,
        ];
        for (final text in samples) {
          expect(text.trim(), isNotEmpty);
        }
      });
    }

    test('translates player colors inside step texts', () {
      final ca = PreparationL10n.forLocale(const Locale('ca'));
      expect(ca.colorName('red'), 'vermell');
      expect(ca.villageBoardDetail('red'), contains('vermell'));
      expect(ca.villageBoardDetail('red'), isNot(contains('red')));

      final es = PreparationL10n.forLocale(const Locale('es'));
      expect(es.colorName('yellow'), 'amarillo');
      expect(es.ownTilesDetail('yellow'), contains('amarillo'));
    });

    test('English default keeps the pre-i18n wording', () {
      final en = PreparationL10n.en();
      expect(
        en.villageBoardDetail('red'),
        'Take the village board of color red and place it in front of you. '
        'Your worker draw pile and water carrier track live there.',
      );
      expect(
        en.removeTilesDetail(2, en.tileSinglePlantation),
        'Sort out 2x Single Plantation and put them back in the box.',
      );
    });
  });
}
