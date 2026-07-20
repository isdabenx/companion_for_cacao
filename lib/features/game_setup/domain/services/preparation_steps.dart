import 'package:companion_for_cacao/features/game_setup/domain/content/preparation_l10n.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/table_zone.dart';

/// Group ids shared by preparation steps that render as a single card.
abstract final class PreparationGroups {
  /// One card per player with their whole corner setup.
  static String player(String color) => 'group_player_$color';

  /// One card collecting every "return to the box" tile removal of the
  /// board-setup phase (base 2p removals, module substitutions...).
  static const String returnToBox = 'group_return_to_box';
}

/// Builders for the step shapes shared by the base game and modules.
abstract final class PreparationSteps {
  /// A "return Nx TILE to the box" removal, grouped into the shared
  /// return-to-box card of the board-setup phase.
  static PreparationEntity removal({
    required PreparationL10n copy,
    required String id,
    required int quantity,
    required String tileName,
    required String imageKey,
    String? rationale,
  }) {
    return PreparationEntity(
      id: id,
      label: copy.removeTilesLabel(quantity, tileName),
      detail: copy.removeTilesDetail(quantity, tileName),
      rationale: rationale,
      tableZone: TableZone.box,
      groupId: PreparationGroups.returnToBox,
      quantity: quantity,
      imageKey: imageKey,
      phase: PreparationPhase.boardSetup,
    );
  }

  /// An "add Nx TILE to the jungle tiles" module substitution step.
  static PreparationEntity addition({
    required PreparationL10n copy,
    required String id,
    required int quantity,
    required String tileName,
    required String imageKey,
    String? rationale,
  }) {
    return PreparationEntity(
      id: id,
      label: copy.addTilesLabel(quantity, tileName),
      detail: copy.addTilesDetail(quantity, tileName),
      rationale: rationale,
      tableZone: TableZone.junglePile,
      quantity: quantity,
      imageKey: imageKey,
      phase: PreparationPhase.boardSetup,
    );
  }
}
