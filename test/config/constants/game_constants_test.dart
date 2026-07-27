import 'package:companion_for_cacao/config/constants/game_constants.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameConstants.playerColorOrder', () {
    test('names the four player colours in their canonical order', () {
      expect(GameConstants.playerColorOrder, [
        'white',
        'red',
        'purple',
        'yellow',
      ]);
      expect(GameConstants.playerColorOrder.length, GameConstants.maxPlayers);
    });

    // The order is game data (domain); the palette that paints it is styling
    // (theme). Keeping them in two places is what lets the domain stay free of
    // theme imports — this test is the guard that they never drift apart.
    test('every colour has a palette entry, and the palette adds none', () {
      for (final name in GameConstants.playerColorOrder) {
        expect(
          AppColors.colors.containsKey(name),
          isTrue,
          reason: '$name has no colour in AppColors.colors',
        );
      }
      expect(
        AppColors.colors.keys.toSet(),
        GameConstants.playerColorOrder.toSet(),
        reason: 'the palette and the canonical order list different colours',
      );
    });

    test('findColorByName resolves every canonical colour', () {
      for (final name in GameConstants.playerColorOrder) {
        expect(
          AppColors.findColorByName(name),
          isNot(const Color(0x00000000)),
          reason: '$name resolved to transparent',
        );
      }
    });
  });
}
