import 'package:companion_for_cacao/core/utils/string_extensions.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StringCasing.capitalized', () {
    test('capitalizes the first letter only', () {
      expect('red'.capitalized, 'Red');
      expect('white player'.capitalized, 'White player');
    });

    test('handles empty and single-char strings', () {
      expect(''.capitalized, '');
      expect('a'.capitalized, 'A');
    });
  });

  group('PlayerEntity.displayName', () {
    test('prefers the typed name', () {
      expect(PlayerEntity(name: 'Alice', color: 'red').displayName, 'Alice');
    });

    test('falls back to the capitalized color when unnamed', () {
      expect(PlayerEntity(name: '', color: 'purple').displayName, 'Purple');
    });
  });
}
