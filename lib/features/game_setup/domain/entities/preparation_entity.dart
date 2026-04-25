import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:flutter/foundation.dart';

class PreparationEntity {
  const PreparationEntity({
    required this.id,
    required this.description,
    required this.phase,
    this.imageKey,
    this.isCompleted = false,
    this.color,
    this.variables,
  });
  final String id;
  final String description;
  final PreparationPhase phase;
  final String? imageKey;
  final bool isCompleted;
  final String? color;
  final Map<String, String>? variables;

  PreparationEntity copyWith({
    String? id,
    String? description,
    PreparationPhase? phase,
    String? imageKey,
    bool? isCompleted,
    String? color,
    Map<String, String>? variables,
  }) {
    return PreparationEntity(
      id: id ?? this.id,
      description: description ?? this.description,
      phase: phase ?? this.phase,
      imageKey: imageKey ?? this.imageKey,
      isCompleted: isCompleted ?? this.isCompleted,
      color: color ?? this.color,
      variables: variables ?? this.variables,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PreparationEntity &&
        other.id == id &&
        other.description == description &&
        other.phase == phase &&
        other.imageKey == imageKey &&
        other.isCompleted == isCompleted &&
        other.color == color &&
        mapEquals(other.variables, variables);
  }

  @override
  int get hashCode => Object.hash(
    id,
    description,
    phase,
    imageKey,
    isCompleted,
    color,
    variables == null ? null : Object.hashAll(variables!.entries),
  );
}
