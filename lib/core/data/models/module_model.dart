import 'package:companion_for_cacao/core/data/database/app_database.dart';

class ModuleModel {
  ModuleModel({
    required this.id,
    required this.name,
    required this.description,
    this.boardgameId,
  });

  factory ModuleModel.fromDrift(Module row) {
    return ModuleModel(
      id: row.id,
      name: row.name,
      description: row.description,
      boardgameId: row.boardgameId,
    );
  }

  final int id;
  final String name;
  final String description;
  final int? boardgameId;

  ModuleModel copyWith({
    int? id,
    String? name,
    String? description,
    int? boardgameId,
  }) {
    return ModuleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      boardgameId: boardgameId ?? this.boardgameId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ModuleModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.boardgameId == boardgameId;
  }

  @override
  int get hashCode => Object.hash(id, name, description, boardgameId);
}
