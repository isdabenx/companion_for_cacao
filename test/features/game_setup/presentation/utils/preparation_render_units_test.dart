import 'package:companion_for_cacao/features/game_setup/presentation/utils/preparation_render_units.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/preparation_fixtures.dart';

void main() {
  group('buildRenderUnits', () {
    test('keeps ungrouped steps standalone in order', () {
      final units = buildRenderUnits([
        makePrepStep(id: 'a'),
        makePrepStep(id: 'b'),
      ]);

      expect(units, hasLength(2));
      expect(units.whereType<StepUnit>().map((u) => u.step.id), ['a', 'b']);
    });

    test('collapses a group at the position of its first member', () {
      final units = buildRenderUnits([
        makePrepStep(id: 'a'),
        makePrepStep(id: 'g1', groupId: 'group_player_red'),
        makePrepStep(id: 'b'),
        makePrepStep(id: 'g2', groupId: 'group_player_red'),
      ]);

      expect(units, hasLength(3));
      expect(units[0], isA<StepUnit>());
      final group = units[1] as GroupUnit;
      expect(group.groupId, 'group_player_red');
      expect(group.steps.map((s) => s.id), ['g1', 'g2']);
      expect((units[2] as StepUnit).step.id, 'b');
    });

    test('exposes every covered step through steps', () {
      final units = buildRenderUnits([
        makePrepStep(id: 'solo'),
        makePrepStep(id: 'g1', groupId: 'g'),
        makePrepStep(id: 'g2', groupId: 'g'),
      ]);

      expect(units[0].steps.map((s) => s.id), ['solo']);
      expect(units[1].steps.map((s) => s.id), ['g1', 'g2']);
    });
  });
}
