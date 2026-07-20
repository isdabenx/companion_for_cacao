import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_actor.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/table_zone.dart';

/// Builds a [PreparationEntity] with sensible test defaults.
///
/// Only override what the test cares about; everything else gets a
/// generic value.
PreparationEntity makePrepStep({
  String id = 'test.step',
  String label = 'Test step',
  String detail = 'Test step detail',
  PreparationPhase phase = PreparationPhase.boardSetup,
  PreparationActor actor = PreparationActor.table,
  TableZone tableZone = TableZone.junglePile,
  String? rationale,
  String? groupId,
  int? quantity,
  String? imageKey,
  bool isCompleted = false,
  String? color,
  Map<String, String>? variables,
}) {
  return PreparationEntity(
    id: id,
    label: label,
    detail: detail,
    phase: phase,
    actor: actor,
    tableZone: tableZone,
    rationale: rationale,
    groupId: groupId,
    quantity: quantity,
    imageKey: imageKey,
    isCompleted: isCompleted,
    color: color,
    variables: variables,
  );
}
