import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';

/// How one preparation list entry renders: a group card or a standalone
/// step. Shared by the list view and the guided pager so both modes show
/// exactly the same units in the same order.
sealed class PreparationRenderUnit {
  const PreparationRenderUnit();

  /// Every step this unit covers (one for a standalone step).
  List<PreparationEntity> get steps;
}

class GroupUnit extends PreparationRenderUnit {
  const GroupUnit(this.groupId, this.steps);

  final String groupId;

  @override
  final List<PreparationEntity> steps;
}

class StepUnit extends PreparationRenderUnit {
  const StepUnit(this.step);

  final PreparationEntity step;

  @override
  List<PreparationEntity> get steps => [step];
}

/// Collapses grouped steps into group units, keeping every other step
/// standalone. A group renders at the position of its first member.
List<PreparationRenderUnit> buildRenderUnits(List<PreparationEntity> items) {
  final units = <PreparationRenderUnit>[];
  final seenGroups = <String>{};
  for (final item in items) {
    final groupId = item.groupId;
    if (groupId == null) {
      units.add(StepUnit(item));
      continue;
    }
    if (seenGroups.add(groupId)) {
      units.add(
        GroupUnit(groupId, items.where((s) => s.groupId == groupId).toList()),
      );
    }
  }
  return units;
}
