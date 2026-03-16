import 'package:companion_for_cacao/core/data/database/app_database.dart';

class ModuleModel {
  ModuleModel({
    required this.id,
    required this.name,
    required this.description,
    this.boardgameId,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      boardgameId: json['boardgame'] as int?,
    );
  }

  factory ModuleModel.fromDrift(Module row) {
    return ModuleModel(
      id: row.id,
      name: row.name,
      description: row.description,
      boardgameId: row.boardgameId,
    );
  }

  int id;
  late String name;
  late String description;
  int? boardgameId;

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
}
