import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_actor.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/table_zone.dart';
import 'package:flutter/foundation.dart';

/// One preparation step, structured by information level:
/// [label] says WHAT (one-line imperative), [detail] says HOW (the full
/// rulebook text) and [rationale] optionally says WHY. [actor] says who
/// performs it, [tableZone] where its result ends up on the table.
///
/// Steps sharing a [groupId] are rendered as a single card (a player's
/// corner, the return-to-box pile). The list itself stays flat so the
/// id-based completion carry-over of the pipeline keeps working unchanged.
class PreparationEntity {
  const PreparationEntity({
    required this.id,
    required this.label,
    required this.detail,
    required this.phase,
    required this.tableZone,
    this.actor = PreparationActor.table,
    this.rationale,
    this.groupId,
    this.quantity,
    this.imageKey,
    this.isCompleted = false,
    this.color,
    this.variables,
    this.colorReferenceImage = false,
    this.informational = false,
    this.imageStrip = const [],
  });

  final String id;

  /// WHAT — one-line imperative shown as the step title.
  final String label;

  /// HOW — the complete rulebook instruction, shown on expansion.
  final String detail;

  final PreparationPhase phase;

  /// Who performs the step. For [PreparationActor.player], [color]
  /// identifies which player.
  final PreparationActor actor;

  /// WHERE — the table zone the step's result ends up in.
  final TableZone tableZone;

  /// WHY — optional context for first-game players.
  final String? rationale;

  /// Steps sharing a groupId render as one card (e.g. `group_player_red`,
  /// `group_return_to_box`). Null means a standalone card.
  final String? groupId;

  /// How many physical pieces the step moves (badge "×N"). Null when it
  /// does not apply or means "all of them" (see label).
  final int? quantity;

  final String? imageKey;
  final bool isCompleted;
  final String? color;
  final Map<String, String>? variables;

  /// True when [imageKey] shows a component that comes in each player's
  /// colour, displayed as a neutral (grayscale) reference on an all-players
  /// step. Neutral images (e.g. map tokens) keep it false and stay in colour.
  final bool colorReferenceImage;

  /// True for a conditional guidance step (no checkbox): e.g. "if you store
  /// this expansion mixed in, remove its jungle tiles". It never counts
  /// toward completion and renders with an info affordance instead of a check.
  final bool informational;

  /// Extra tiles shown as an image strip under the label (e.g. the several
  /// tiles a mixed-storage note asks to take out), each with its quantity.
  /// Complements the single [imageKey].
  final List<({String imageKey, int quantity})> imageStrip;

  PreparationEntity copyWith({
    String? id,
    String? label,
    String? detail,
    PreparationPhase? phase,
    PreparationActor? actor,
    TableZone? tableZone,
    String? rationale,
    String? groupId,
    int? quantity,
    String? imageKey,
    bool? isCompleted,
    String? color,
    Map<String, String>? variables,
    bool? colorReferenceImage,
    bool? informational,
    List<({String imageKey, int quantity})>? imageStrip,
  }) {
    return PreparationEntity(
      id: id ?? this.id,
      label: label ?? this.label,
      detail: detail ?? this.detail,
      phase: phase ?? this.phase,
      actor: actor ?? this.actor,
      tableZone: tableZone ?? this.tableZone,
      rationale: rationale ?? this.rationale,
      groupId: groupId ?? this.groupId,
      quantity: quantity ?? this.quantity,
      imageKey: imageKey ?? this.imageKey,
      isCompleted: isCompleted ?? this.isCompleted,
      color: color ?? this.color,
      variables: variables ?? this.variables,
      colorReferenceImage: colorReferenceImage ?? this.colorReferenceImage,
      informational: informational ?? this.informational,
      imageStrip: imageStrip ?? this.imageStrip,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PreparationEntity &&
        other.id == id &&
        other.label == label &&
        other.detail == detail &&
        other.phase == phase &&
        other.actor == actor &&
        other.tableZone == tableZone &&
        other.rationale == rationale &&
        other.groupId == groupId &&
        other.quantity == quantity &&
        other.imageKey == imageKey &&
        other.isCompleted == isCompleted &&
        other.color == color &&
        other.colorReferenceImage == colorReferenceImage &&
        other.informational == informational &&
        listEquals(other.imageStrip, imageStrip) &&
        mapEquals(other.variables, variables);
  }

  @override
  int get hashCode => Object.hash(
    id,
    label,
    detail,
    phase,
    actor,
    tableZone,
    rationale,
    groupId,
    quantity,
    imageKey,
    isCompleted,
    color,
    colorReferenceImage,
    informational,
    Object.hashAll(imageStrip),
    variables == null ? null : Object.hashAll(variables!.entries),
  );
}
